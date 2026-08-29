cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.18.3"
  sha256 arm:   "0be2b062850a1c74c8d5f082d340bcd46ba7c2c9c20f28b072c695b5650da8c9",
         intel: "c286fbe5c4f415471ab31ad5dd2a025e67e952be1bb2ff96fc86f9617bd178eb"

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
