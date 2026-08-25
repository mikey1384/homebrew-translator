cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.17.0"
  sha256 arm:   "4004c3a226c1016a65a9aa29650ee856c95952ffd5a0eea2b8dc5a5314c6edd4",
         intel: "bacf2279afde3614946e9741087b7dc40dc80d9b849e5937b88087f777954bfc"

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
