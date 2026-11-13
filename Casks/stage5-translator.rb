cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.32.6"
  sha256 arm:   "2b614f9ca60871d52fa110342f54555729ef4e5315f96f3f27180693d755114f",
         intel: "7034e97e319ca633efea59a2e86e4ee989f0bc70c35a255d418470b3e70863ee"

  url "https://github.com/mikey1384/translator/releases/download/v#{version}-mac/Translator-#{version}-darwin-#{arch}.zip",
      verified: "github.com/mikey1384/translator/"
  name "Translator"
  desc "Video discovery, subtitle translation, editing, dubbing, and export workstation"
  homepage "https://translator.tools/"

  livecheck do
    url :url
    regex(/^v(\d+\.\d+\.\d+)(?:-mac)?$/i)
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "Translator.app"
end
