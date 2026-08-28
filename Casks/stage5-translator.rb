cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.18.2"
  sha256 arm:   "2b7dcd146bc178b6d1236b7ff473aff5304074810f7b83ccd455051275e6e36c",
         intel: "fad1ef1edf0096c038c9111427ceae1f515c27c8305a4fbc66e0ac6b56fc1e06"

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
