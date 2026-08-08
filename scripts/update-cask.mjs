#!/usr/bin/env node

import assert from "node:assert/strict";
import { readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const caskPath = path.join(root, "Casks", "stage5-translator.rb");
const checkOnly = process.argv.includes("--check");
const releaseUrl = "https://api.github.com/repos/mikey1384/translator/releases/latest";

const response = await fetch(releaseUrl, {
  headers: {
    Accept: "application/vnd.github+json",
    "User-Agent": "stage5-homebrew-translator-updater",
    "X-GitHub-Api-Version": "2022-11-28",
  },
});
assert.equal(response.ok, true, `GitHub release API returned ${response.status}`);

const release = await response.json();
assert.equal(release.draft, false, "Latest release must not be a draft");
assert.equal(release.prerelease, false, "Latest release must not be a prerelease");

const version = String(release.tag_name ?? "").replace(/^v/, "");
assert.match(version, /^\d+\.\d+\.\d+$/, "Unexpected release version");

function shaFor(assetName) {
  const asset = release.assets?.find((candidate) => candidate.name === assetName);
  assert.ok(asset, `Missing release asset: ${assetName}`);
  assert.match(asset.digest ?? "", /^sha256:[0-9a-f]{64}$/);
  return asset.digest.slice("sha256:".length);
}

const armSha = shaFor(`Translator-${version}-darwin-arm64.zip`);
const intelSha = shaFor(`Translator-${version}-darwin-x64.zip`);
const current = await readFile(caskPath, "utf8");
const versionPattern = /^  version "[^"]+"$/m;
const checksumPattern =
  /^  sha256 arm:\s+"[0-9a-f]{64}",\n\s+intel: "[0-9a-f]{64}"$/m;

assert.match(current, versionPattern, "Could not find the cask version line");
assert.match(current, checksumPattern, "Could not find the cask checksum block");

const expected = current
  .replace(versionPattern, `  version "${version}"`)
  .replace(
    checksumPattern,
    `  sha256 arm:   "${armSha}",\n         intel: "${intelSha}"`,
  );

if (checkOnly) {
  assert.equal(current, expected, `Cask is stale; run ${path.relative(root, fileURLToPath(import.meta.url))}`);
  console.log(`Cask is current at Translator ${version}.`);
} else if (current === expected) {
  console.log(`Cask is already current at Translator ${version}.`);
} else {
  await writeFile(caskPath, expected);
  console.log(`Updated cask to Translator ${version}.`);
}
