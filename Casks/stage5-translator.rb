cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.27.0"
  sha256 arm:   "b5367be7c9603bb625612032e9edf09a8b012575498e38617bc826638f48dc5b",
         intel: "83b0a3d3be51ca374b47bbb552d92fd792ebb369150cd89681dc5addc8b76b0b"

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
