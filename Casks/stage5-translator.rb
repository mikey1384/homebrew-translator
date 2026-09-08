cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.20.3"
  sha256 arm:   "ef1b137bdddcf3be9dd307d4a01b56cf642efab6ad5585b88c57d03f1cb23527",
         intel: "2ac630b10be8b161ca03e7856f9619b202d23679ed30cfa9555b03ba6fde731a"

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
