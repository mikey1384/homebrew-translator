# Translator Homebrew tap

This is the publisher-maintained Homebrew tap for [Translator](https://translator.tools/), the open-source macOS and Windows video workstation for downloading, transcription, subtitle translation and review, styling, dubbing, clips, and export.

## Install on macOS

```bash
brew install --cask mikey1384/translator/stage5-translator
```

Homebrew selects the Apple Silicon or Intel build automatically. Translator requires macOS 12 Monterey or later.

Upgrade with:

```bash
brew upgrade --cask stage5-translator
```

Uninstall with:

```bash
brew uninstall --cask stage5-translator
```

## Trust and maintenance

- App source: [mikey1384/translator](https://github.com/mikey1384/translator)
- Product site and direct downloads: [translator.tools](https://translator.tools/)
- License: [MIT](https://github.com/mikey1384/translator/blob/master/LICENSE)
- Release artifacts come from immutable, versioned GitHub release URLs.
- Checksums are read from GitHub's release-asset digests and verified on every change.
- A daily workflow updates this tap when a new stable Translator release appears.

This tap is maintained by Translator's publisher. It is not an official Homebrew core cask.
