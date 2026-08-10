cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.16.7"
  sha256 arm:   "81e4476ea128333f2177ca84f039069a208882a41a1591ad2da08e5946b10f55",
         intel: "e2869b5784d5cb23ab104f07b8c6a0e6f0e50f243d47a4a2025b55df288cf267"

  url "https://github.com/mikey1384/translator/releases/download/v#{version}/Translator-#{version}-darwin-#{arch}.zip",
      verified: "github.com/mikey1384/translator/"
  name "Translator"
  desc "Video discovery, subtitle translation, editing, dubbing, and export workstation"
  homepage "https://translator.tools/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "Translator.app"
end
