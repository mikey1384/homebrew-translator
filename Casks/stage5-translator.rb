cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.28.1"
  sha256 arm:   "8c7111523b31255c72ab3ce7d9bfad6e07e7c0cdbf56eb9bfe8fdfbdae35dcb5",
         intel: "72c774b401429a9d959e900d3a004f2b28411732e6311e2bada83ffa9ed9e475"

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
