cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.16.9"
  sha256 arm:   "deaf01022f469d4dc204548812d18e36aebcf40826b6fa6766f1d9fe1121c7ad",
         intel: "9bf2e26bf1b1ed16428f0814d6e4949c5334c5d63c69b1845ac3e150b0636437"

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
