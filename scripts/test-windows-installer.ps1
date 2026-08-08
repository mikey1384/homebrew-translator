$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$currentVersion = "1.16.5"
$previousVersion = "1.16.3"
$downloadRoot = Join-Path $env:RUNNER_TEMP "translator-installer-smoke"
New-Item -ItemType Directory -Force -Path $downloadRoot | Out-Null

function Download-And-VerifyInstaller {
  param(
    [Parameter(Mandatory = $true)][string]$Version
  )

  $baseUrl = "https://downloads.stage5.tools/win/$Version/Translator-x64.exe"
  $installer = Join-Path $downloadRoot "Translator-$Version-x64.exe"
  $checksumFile = "$installer.sha256"
  Invoke-WebRequest -UseBasicParsing "$baseUrl.sha256" -OutFile $checksumFile
  $checksumText = (Get-Content -Raw -Path $checksumFile).Trim()
  $expectedSha = ($checksumText -split '\s+')[0].ToUpperInvariant()

  Invoke-WebRequest -UseBasicParsing $baseUrl -OutFile $installer
  $actualSha = (Get-FileHash -Algorithm SHA256 $installer).Hash.ToUpperInvariant()
  if ($actualSha -ne $expectedSha) {
    throw "SHA-256 mismatch for Translator $Version. Expected $expectedSha, received $actualSha."
  }

  $signature = Get-AuthenticodeSignature $installer
  if ($signature.Status -ne [System.Management.Automation.SignatureStatus]::Valid) {
    throw "Translator $Version Authenticode status is $($signature.Status), not Valid."
  }
  if ($signature.SignerCertificate.Subject -notmatch "Stage5 Tools LLC") {
    throw "Translator $Version is signed by an unexpected subject: $($signature.SignerCertificate.Subject)"
  }

  Write-Host "Verified Translator ${Version}: SHA-256 $actualSha; signer $($signature.SignerCertificate.Subject)"
  return $installer
}

function Get-TranslatorUninstallEntry {
  $roots = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
  )

  return Get-ItemProperty -Path $roots -ErrorAction SilentlyContinue |
    Where-Object {
      $null -ne $_.PSObject.Properties["DisplayName"] -and
      $_.DisplayName -eq "Translator"
    } |
    Select-Object -First 1
}

function Wait-ForTranslatorState {
  param(
    [Parameter(Mandatory = $true)][bool]$Installed,
    [int]$TimeoutSeconds = 120
  )

  $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
  do {
    $entry = Get-TranslatorUninstallEntry
    if ($Installed -and $null -ne $entry) { return $entry }
    if (-not $Installed -and $null -eq $entry) { return $null }
    Start-Sleep -Seconds 2
  } while ((Get-Date) -lt $deadline)

  throw "Translator did not reach installed=$Installed within $TimeoutSeconds seconds."
}

function Install-Translator {
  param(
    [Parameter(Mandatory = $true)][string]$Installer,
    [Parameter(Mandatory = $true)][string]$ExpectedVersion,
    [Parameter(Mandatory = $true)][string]$Scenario
  )

  Write-Host "Starting $Scenario with Translator $ExpectedVersion"
  $process = Start-Process -FilePath $Installer -ArgumentList "/S" -Wait -PassThru
  if ($process.ExitCode -ne 0) {
    throw "$Scenario returned installer exit code $($process.ExitCode)."
  }

  $entry = Wait-ForTranslatorState -Installed $true
  if ($entry.DisplayVersion -ne $ExpectedVersion) {
    throw "$Scenario installed version $($entry.DisplayVersion), expected $ExpectedVersion."
  }
  if ($entry.Publisher -notmatch "Stage5 Tools LLC") {
    throw "$Scenario registered unexpected publisher: $($entry.Publisher)"
  }
  if ([string]::IsNullOrWhiteSpace($entry.InstallLocation) -or -not (Test-Path $entry.InstallLocation)) {
    throw "$Scenario did not register a valid install location."
  }

  $app = Join-Path $entry.InstallLocation "Translator.exe"
  if (-not (Test-Path $app)) {
    throw "$Scenario did not install Translator.exe at $app."
  }

  Write-Host "$Scenario passed: version $($entry.DisplayVersion), publisher $($entry.Publisher), location $($entry.InstallLocation)"
}

function Uninstall-Translator {
  param(
    [Parameter(Mandatory = $true)][string]$Scenario
  )

  $entry = Get-TranslatorUninstallEntry
  if ($null -eq $entry) {
    throw "$Scenario could not find the Translator uninstall entry."
  }

  $command = if (-not [string]::IsNullOrWhiteSpace($entry.QuietUninstallString)) {
    $entry.QuietUninstallString
  } else {
    $entry.UninstallString
  }
  if ([string]::IsNullOrWhiteSpace($command)) {
    throw "$Scenario found no uninstall command."
  }

  if ($command -match '^\s*"([^"]+\.exe)"\s*(.*)$') {
    $uninstaller = $Matches[1]
    $arguments = $Matches[2]
  } elseif ($command -match '^\s*(.+?\.exe)\s*(.*)$') {
    $uninstaller = $Matches[1]
    $arguments = $Matches[2]
  } else {
    throw "$Scenario could not parse uninstall command: $command"
  }

  if (-not (Test-Path $uninstaller)) {
    throw "$Scenario uninstall executable does not exist: $uninstaller"
  }
  if ($arguments -notmatch '(^|\s)/S(\s|$)') {
    $arguments = ($arguments + " /S").Trim()
  }

  Write-Host "Starting $Scenario"
  $process = Start-Process -FilePath $uninstaller -ArgumentList $arguments -Wait -PassThru
  if ($process.ExitCode -ne 0) {
    throw "$Scenario returned uninstaller exit code $($process.ExitCode)."
  }
  Wait-ForTranslatorState -Installed $false | Out-Null
  Write-Host "$Scenario passed"
}

$currentInstaller = Download-And-VerifyInstaller -Version $currentVersion
$previousInstaller = Download-And-VerifyInstaller -Version $previousVersion

if ($null -ne (Get-TranslatorUninstallEntry)) {
  throw "The supposedly clean Windows runner already contains Translator."
}

Install-Translator -Installer $currentInstaller -ExpectedVersion $currentVersion -Scenario "clean silent install"
Install-Translator -Installer $currentInstaller -ExpectedVersion $currentVersion -Scenario "same-version silent reinstall"
Uninstall-Translator -Scenario "post-reinstall silent uninstall"

Install-Translator -Installer $previousInstaller -ExpectedVersion $previousVersion -Scenario "previous-version silent install"
Install-Translator -Installer $currentInstaller -ExpectedVersion $currentVersion -Scenario "silent upgrade"
Uninstall-Translator -Scenario "post-upgrade silent uninstall"

Write-Host "Translator Windows installer lifecycle smoke test passed."
