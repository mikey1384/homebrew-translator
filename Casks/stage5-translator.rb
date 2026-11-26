cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.36.0"
  sha256 arm:   "c40bcafbada42be46214fe3c0d63e4053cc642388bd1006c16b9deec423689b5",
         intel: "fd6ae4bc0b06e0c48dfafcb446df80d7fe7b3926d0bcd8593980ee4538542dae"

  url "https://github.com/mikey1384/translator/releases/download/v#{version}/Translator-#{version}-darwin-#{arch}.zip",
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
