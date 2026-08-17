cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.16.14"
  sha256 arm:   "2d1b2827db81df561dc1377a0ca5ac13b89f294a71198c575964a73ccc00a04b",
         intel: "025c359ceecfc02f885b11a0da1110cc69559e5c1b093c286ab788a5c9720f8f"

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
