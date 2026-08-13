cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.16.12"
  sha256 arm:   "2f6676a056bba7cd7b76cbee52a0094933ff60feca2d355d875d94868fe01351",
         intel: "8847e308334f8a208779e89871fabc0c9113e999bf0c2728a0e291188cf93128"

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
