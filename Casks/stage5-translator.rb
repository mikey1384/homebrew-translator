cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.18.4"
  sha256 arm:   "8208996151611c2aebb6637d4294915c49eefb39d2bc23491f3d07c103b31dde",
         intel: "6118de643d939c4b96edfbdf0a534f568a6ecf129869f17efa29efede28d97c5"

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
