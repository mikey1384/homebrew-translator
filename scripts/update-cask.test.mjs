import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import {
  copyFile,
  mkdir,
  mkdtemp,
  readFile,
  rm,
  writeFile,
} from "node:fs/promises";
import { tmpdir } from "node:os";
import path from "node:path";
import test from "node:test";
import { renderCask } from "./update-cask.mjs";

const template = `cask "stage5-translator" do
  arch arm: "arm64", intel: "x64"
  version "1.32.2"
  sha256 arm:   "${"a".repeat(64)}",
         intel: "${"b".repeat(64)}"
  url "https://github.com/mikey1384/translator/releases/download/v#{version}/Translator-#{version}-darwin-#{arch}.zip",
      verified: "github.com/mikey1384/translator/"
  app "Translator.app"
end
`;

function release(tag = "v1.32.6-mac", version = "1.32.6") {
  return {
    tag_name: tag,
    draft: false,
    prerelease: false,
    assets: ["arm64", "x64"].map((arch, index) => ({
      name: `Translator-${version}-darwin-${arch}.zip`,
      state: "uploaded",
      digest: `sha256:${String(index + 1).repeat(64)}`,
      browser_download_url: `https://github.com/mikey1384/translator/releases/download/${tag}/Translator-${version}-darwin-${arch}.zip`,
    })),
  };
}

function urls(cask, version) {
  const url = cask.match(/^  url "([^"]+)"/m)?.[1];
  return ["arm64", "x64"].map((arch) =>
    url.replaceAll("#{version}", version).replaceAll("#{arch}", arch),
  );
}

test("Mac-only releases retain the tag suffix only in the release directory", () => {
  const { expected, version } = renderCask(template, release());
  assert.equal(version, "1.32.6");
  assert.match(expected, /version "1\.32\.6"/);
  assert.deepEqual(urls(expected, version), [
    "https://github.com/mikey1384/translator/releases/download/v1.32.6-mac/Translator-1.32.6-darwin-arm64.zip",
    "https://github.com/mikey1384/translator/releases/download/v1.32.6-mac/Translator-1.32.6-darwin-x64.zip",
  ]);
  assert.ok(expected.includes(`sha256 arm:   "${"1".repeat(64)}"`));
  assert.ok(expected.includes(`intel: "${"2".repeat(64)}"`));
});

test("ordinary release tags remain supported", () => {
  const { expected, version } = renderCask(template, release("v1.32.6"));
  assert.equal(version, "1.32.6");
  assert.deepEqual(urls(expected, version), [
    "https://github.com/mikey1384/translator/releases/download/v1.32.6/Translator-1.32.6-darwin-arm64.zip",
    "https://github.com/mikey1384/translator/releases/download/v1.32.6/Translator-1.32.6-darwin-x64.zip",
  ]);
});

test("the next full release removes a previous Mac-only suffix", () => {
  const mac = renderCask(template, release()).expected;
  const { expected, version } = renderCask(mac, release("v1.32.7", "1.32.7"));
  assert.equal(version, "1.32.7");
  assert.ok(!expected.includes("-mac"));
  assert.equal(
    urls(expected, version)[0],
    "https://github.com/mikey1384/translator/releases/download/v1.32.7/Translator-1.32.7-darwin-arm64.zip",
  );
});

test("the URL is refreshed even when the numeric version and digests match", () => {
  const normal = renderCask(template, release("v1.32.6")).expected;
  const mac = renderCask(normal, release()).expected;
  assert.notEqual(mac, normal);
  assert.equal(renderCask(mac, release()).expected, mac);
});

test("unsupported, prerelease and injected tags fail closed", () => {
  for (const tag of [
    "v1.32",
    "1.32.6",
    "v1.32.6-beta.1",
    "v1.32.6-mac-beta",
    "v1.32.6-win",
    "v1.32.6/mac",
    'v1.32.6"',
    "v1.32.6-mac\n",
  ])
    assert.throws(
      () => renderCask(template, release(tag)),
      /Unexpected release version/,
    );
});

test("drafts and prereleases are rejected", () => {
  for (const flag of ["draft", "prerelease"])
    assert.throws(() => renderCask(template, { ...release(), [flag]: true }));
});

test("both uploaded architecture assets must exist exactly once", () => {
  const missing = release();
  missing.assets.pop();
  assert.throws(
    () => renderCask(template, missing),
    /Expected one release asset/,
  );
  const duplicate = release();
  duplicate.assets.push(duplicate.assets[0]);
  assert.throws(
    () => renderCask(template, duplicate),
    /Expected one release asset/,
  );
  const unfinished = release();
  unfinished.assets[1].state = "new";
  assert.throws(() => renderCask(template, unfinished), /not uploaded/);
});

test("asset links must belong to the exact release and architecture", () => {
  for (const url of [
    "https://example.com/Translator-1.32.6-darwin-arm64.zip",
    "https://github.com/mikey1384/translator/releases/download/v1.32.6/Translator-1.32.6-darwin-arm64.zip",
    "https://github.com/mikey1384/translator/releases/download/v1.32.6-mac/Translator-1.32.6-darwin-x64.zip",
  ]) {
    const invalid = release();
    invalid.assets[0].browser_download_url = url;
    assert.throws(
      () => renderCask(template, invalid),
      /Unexpected release asset URL/,
    );
  }
});

test("missing or malformed SHA-256 digests are rejected", () => {
  for (const digest of [undefined, "sha256:abc", `sha512:${"1".repeat(64)}`]) {
    const invalid = release();
    invalid.assets[0].digest = digest;
    assert.throws(() => renderCask(template, invalid));
  }
});

test("an unfamiliar cask URL cannot silently keep a stale download", () => {
  assert.throws(
    () =>
      renderCask(
        template.replace("/download/v", "/download/other-v"),
        release(),
      ),
    /Could not find the cask download URL/,
  );
});

async function cliFixture(t, payload, status = 200) {
  const dir = await mkdtemp(path.join(tmpdir(), "translator-cask-test-"));
  t.after(() => rm(dir, { recursive: true, force: true }));
  await mkdir(path.join(dir, "scripts"));
  await mkdir(path.join(dir, "Casks"));
  const script = path.join(dir, "scripts", "update-cask.mjs");
  const cask = path.join(dir, "Casks", "stage5-translator.rb");
  const mock = path.join(dir, "mock-fetch.mjs");
  await copyFile(new URL("./update-cask.mjs", import.meta.url), script);
  await writeFile(cask, template);
  await writeFile(
    mock,
    `import assert from "node:assert/strict";
globalThis.fetch = async url => {
  assert.equal(url, "https://api.github.com/repos/mikey1384/translator/releases/latest");
  return new Response(${JSON.stringify(JSON.stringify(payload))}, { status: ${status} });
};`,
  );
  return {
    cask,
    run: (...args) =>
      spawnSync(process.execPath, ["--import", mock, script, ...args], {
        encoding: "utf8",
        env: { ...process.env, GITHUB_TOKEN: "" },
      }),
  };
}

test("CLI check is read-only, update fixes the cask, and a stale suffix is detected", async (t) => {
  const { cask, run } = await cliFixture(t, release());
  assert.notEqual(run("--check").status, 0);
  assert.equal(await readFile(cask, "utf8"), template);
  const update = run();
  assert.equal(update.status, 0, update.stderr);
  const written = await readFile(cask, "utf8");
  assert.equal(written, renderCask(template, release()).expected);
  assert.equal(run("--check").status, 0);
  assert.match(run().stdout, /already current/);
  const broken = written.replace("v#{version}-mac/", "v#{version}/");
  await writeFile(cask, broken);
  assert.notEqual(run("--check").status, 0);
  assert.equal(await readFile(cask, "utf8"), broken);
});

test("CLI refuses incomplete release metadata without changing the cask", async (t) => {
  const invalid = release();
  invalid.assets.pop();
  const { cask, run } = await cliFixture(t, invalid);
  assert.notEqual(run().status, 0);
  assert.equal(await readFile(cask, "utf8"), template);
});

test("a failed GitHub API request leaves the cask unchanged", async (t) => {
  const { cask, run } = await cliFixture(t, {}, 503);
  const result = run();
  assert.notEqual(result.status, 0);
  assert.match(result.stderr, /GitHub release API returned 503/);
  assert.equal(await readFile(cask, "utf8"), template);
});
