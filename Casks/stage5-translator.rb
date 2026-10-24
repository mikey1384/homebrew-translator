cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.28.6"
  sha256 arm:   "e08520c2c24872711041f6acacce42ce911421675ce56b6957cc472e48761414",
         intel: "c38e7aaa65099ccae0d95b7a3a785e70fac31b0de1082e29a9f925c2960a9d99"

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
