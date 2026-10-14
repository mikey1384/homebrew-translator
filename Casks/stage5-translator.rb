cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.25.0"
  sha256 arm:   "f31380921790ccf47661628557f444716aed891f9e8d941e4f4101a3da9b66f4",
         intel: "5cfc445e887a7e551caae25ffc417fdbf506d3760fbc942a2f5336863e12ba02"

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
