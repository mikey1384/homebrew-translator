cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.16.11"
  sha256 arm:   "122a92fb35ff115805fcb27ea71ac5c2aabd61202f3a7a4237adbb80a59084f7",
         intel: "471f34c974f533a1a909cb4afb3e30ad4b7f7a0f4a2e672215657d4b17c36ccb"

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
