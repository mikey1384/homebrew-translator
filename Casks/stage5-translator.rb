cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.23.1"
  sha256 arm:   "9ecfe8379a339e9fd536b0ace554fb8a7afbce7b17f19104e87a36ade5175d16",
         intel: "29e897833584acf53cac1aa0260b1b88b07abaa655c5c76c25a29ae00966c2ad"

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
