cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.29.0"
  sha256 arm:   "24b0d49985a526abee9ff2269558ff5dfd2e90f62e955a8721af6a8270dc17b2",
         intel: "162f97375d2f2a55624861b1d89fdf9b97bde78695b4cf5e17d7f4fa23725d8b"

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
