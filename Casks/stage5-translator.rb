cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.35.0"
  sha256 arm:   "d3c784857de3b5e22bbd9e56ed3b557991cc3708c757867bdb9526ed207141b5",
         intel: "20ab51f0aaeac5ba1592d572f1e9114a541dff9ac1e22ec89d15d44521fd52c0"

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
