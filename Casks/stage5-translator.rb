cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.35.1"
  sha256 arm:   "156cec9018df6e5f9fb5d924d96677c2a3c2502d5b06af6ad30d40bab65f5781",
         intel: "f84866bf6dda1a2d6a0882420553fd64e474502f1fbc54aa44a473a1d4642134"

  url "https://github.com/mikey1384/translator/releases/download/v#{version}/Translator-#{version}-darwin-#{arch}.zip",
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
