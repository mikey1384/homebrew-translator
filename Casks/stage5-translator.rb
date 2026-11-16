cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"

  version "1.33.1"
  sha256 arm:   "8e317ad92b102e3fc58c753c706a50f90c5960428d91ab1330105bedc7e01835",
         intel: "24bfd3bad1ba82cb558c745b1dd19b05115287f997718d5cfda7c431c2a0d07c"

  url "https://github.com/mikey1384/translator/releases/download/v#{version}-mac/Translator-#{version}-darwin-#{arch}.zip",
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
