cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.16.10"
  sha256 arm:   "e4c4193528c7838ee8a9b92839d9331d7f107c8f2ecf945ce2ead6889c9c1b95",
         intel: "ef1fba5ec2e6e9d5309b32e900a9b33fae35dbc0c4b1d3a329dcc2fa91cef1ff"

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
