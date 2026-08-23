cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.16.18"
  sha256 arm:   "0fcae25fc0f51878b1be2438d98afa37203ac9786d79919b4bda5f42e3228f4e",
         intel: "8f1de8173692363fd8474ceb068fb61af17dad1a96558518e25ea528e2910adf"

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
