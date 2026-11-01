cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.32.2"
  sha256 arm:   "2a51802343d951fea47f0e14fc1305fa7e524fdc9c6d6e1970ff8e1f7c25836b",
         intel: "378f1c2eae8ec1c39ef539755e0dd15d9091aa6e415c05bffca545a51eeb2c22"

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
