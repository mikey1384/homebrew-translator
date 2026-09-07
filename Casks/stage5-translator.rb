cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.20.2"
  sha256 arm:   "49e5964e8f7eba727a51d80d09ccf3d16099596885dbcd79280005c777f88cc5",
         intel: "299abf42b8e9192d470b4bf40ab3ea075008ffeca8cf5abcbfb38c414561ea80"

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
