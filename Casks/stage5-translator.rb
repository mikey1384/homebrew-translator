cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.16.13"
  sha256 arm:   "a9b9fee7f6ee2622b0eec98ddb1131139350710217b974c74fb1300614fd5e20",
         intel: "11c2c9b70f74e83b91b53aba52eb6272d8603ce5da0cc8f85498cd806566eca3"

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
