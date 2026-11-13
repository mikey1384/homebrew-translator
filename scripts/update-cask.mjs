#!/usr/bin/env node

import assert from "node:assert/strict";
import { readFile, realpath, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const caskPath = path.join(root, "Casks", "stage5-translator.rb");
const releaseUrl =
  "https://api.github.com/repos/mikey1384/translator/releases/latest";

export function renderCask(current, release) {
  assert.equal(release.draft, false, "Latest release must not be a draft");
  assert.equal(
    release.prerelease,
    false,
    "Latest release must not be a prerelease",
  );

  const tag = String(release.tag_name ?? "");
  const match = /^v(\d+\.\d+\.\d+)(-mac)?$/.exec(tag);
  assert.ok(match, "Unexpected release version");
  const [, version, suffix = ""] = match;

  function shaFor(arch) {
    const assetName = `Translator-${version}-darwin-${arch}.zip`;
    const assets =
      release.assets?.filter((candidate) => candidate.name === assetName) ?? [];
    assert.equal(assets.length, 1, `Expected one release asset: ${assetName}`);
    const [asset] = assets;
    assert.equal(
      asset.state,
      "uploaded",
      `Release asset is not uploaded: ${assetName}`,
    );
    assert.equal(
      asset.browser_download_url,
      `https://github.com/mikey1384/translator/releases/download/${tag}/${assetName}`,
      `Unexpected release asset URL: ${assetName}`,
    );
    assert.match(asset.digest ?? "", /^sha256:[0-9a-f]{64}$/);
    return asset.digest.slice("sha256:".length);
  }

  const armSha = shaFor("arm64");
  const intelSha = shaFor("x64");
  const versionPattern = /^  version "[^"]+"$/m;
  const checksumPattern =
    /^  sha256 arm:\s+"[0-9a-f]{64}",\n\s+intel: "[0-9a-f]{64}"$/m;
  const urlPattern =
    /^  url "https:\/\/github\.com\/mikey1384\/translator\/releases\/download\/v#\{version\}(?:-mac)?\/Translator-#\{version\}-darwin-#\{arch\}\.zip",$/m;

  assert.match(current, versionPattern, "Could not find the cask version line");
  assert.match(
    current,
    checksumPattern,
    "Could not find the cask checksum block",
  );
  assert.match(current, urlPattern, "Could not find the cask download URL");

  // The cask and asset filenames use the numeric version. The release path
  // must also retain the tag's optional Mac-only suffix.
  const expected = current
    .replace(versionPattern, `  version "${version}"`)
    .replace(
      checksumPattern,
      `  sha256 arm:   "${armSha}",\n         intel: "${intelSha}"`,
    )
    .replace(
      urlPattern,
      `  url "https://github.com/mikey1384/translator/releases/download/v#{version}${suffix}/Translator-#{version}-darwin-#{arch}.zip",`,
    );
  return { expected, version };
}

async function main() {
  const headers = {
    Accept: "application/vnd.github+json",
    "User-Agent": "stage5-homebrew-translator-updater",
    "X-GitHub-Api-Version": "2022-11-28",
  };
  if (process.env.GITHUB_TOKEN) {
    headers.Authorization = `Bearer ${process.env.GITHUB_TOKEN}`;
  }

  const response = await fetch(releaseUrl, { headers });
  assert.equal(
    response.ok,
    true,
    `GitHub release API returned ${response.status}`,
  );
  const release = await response.json();
  const current = await readFile(caskPath, "utf8");
  const { expected, version } = renderCask(current, release);

  if (process.argv.includes("--check")) {
    assert.equal(
      current,
      expected,
      `Cask is stale; run ${path.relative(root, fileURLToPath(import.meta.url))}`,
    );
    console.log(`Cask is current at Translator ${version}.`);
  } else if (current === expected) {
    console.log(`Cask is already current at Translator ${version}.`);
  } else {
    await writeFile(caskPath, expected);
    console.log(`Updated cask to Translator ${version}.`);
  }
}

const entryPath =
  process.argv[1] && (await realpath(process.argv[1]).catch(() => undefined));
if (entryPath === fileURLToPath(import.meta.url)) {
  await main();
}
