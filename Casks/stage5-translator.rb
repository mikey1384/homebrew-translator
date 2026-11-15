cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.33.0"
  sha256 arm:   "160f449180ed0df82aeb625ee8de1d658f61007585eded5bc87d8aba89a4f42d",
         intel: "95599a59760ff90fd4ea566b23357404d1bd333417b12e012c2ce9feefb72169"

  url "https://github.com/mikey1384/translator/releases/download/v#{version}-mac/Translator-#{version}-darwin-#{arch}.zip",
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
