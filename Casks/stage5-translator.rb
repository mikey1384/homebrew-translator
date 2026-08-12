cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.16.8"
  sha256 arm:   "2ccd0c6eb399bd1d9de4e72774d0f9f86a3b838f40e4126a0cbae868d8fab131",
         intel: "7bb4116f04110f4b8580e7decab0d5253f104e9b57af66581e9635b1dd01483a"

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
