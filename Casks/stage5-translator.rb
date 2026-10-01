cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.21.2"
  sha256 arm:   "f6acabe7787250c8f5fbb32b34291012c11685768b00b9b5af0ac71edac9fcde",
         intel: "1f28157c274ead5933d2ce85d706da647678bd98d2f9a591b64096c177f03f2d"

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
