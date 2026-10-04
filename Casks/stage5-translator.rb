cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.22.1"
  sha256 arm:   "49f2f7e394afe723a95bec49ba4f24a87a9c7b52703e6ab3e5ef31a04d9c32c2",
         intel: "7a80d5b6848c01207a273e10667b96ae56c0dae171fcfeb336efa39e95b353f5"

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
