cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.16.16"
  sha256 arm:   "5ce4fa8ed0a237c4ddbe1c1518231cdafcaf8199d514fb061220aea64c39ea2e",
         intel: "4a60f971f0b15f3c9846780388f0bda4b36c607a6668454b26d9dfa97fa43c2b"

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
