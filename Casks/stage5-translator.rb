cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.31.1"
  sha256 arm:   "f838ae28a1c45154ec405bce2d1f3f31a646d47c5cc92157782da598b3a5f67e",
         intel: "f8c65e545c992d0d45f54c162a4feabb2eb095727a9aab231d47a730ba7618a2"

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
