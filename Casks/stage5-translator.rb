cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.21.0"
  sha256 arm:   "01179a16b61a3bac9aa89d02f79fcd3e3aabd548df3006de57922bb488a016bb",
         intel: "364e491b9fc9a1241bb2289046ff7fc63f3b31d11ecb52bbdc574cbe1f481310"

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
