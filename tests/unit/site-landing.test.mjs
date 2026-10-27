import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { test } from "node:test";

const root = join(dirname(fileURLToPath(import.meta.url)), "../..");
const indexPath = join(root, "site", "index.html");

test("site/index.html exists and links both play pages", () => {
  const html = readFileSync(indexPath, "utf8");
  assert.match(html, /FUBoot Tours/);
  assert.match(html, /href="vrml\/play-opensea\.html"/);
  assert.match(html, /href="vrml\/harbour\/play\.html"/);
});

test("play pages exist under site/vrml", () => {
  readFileSync(join(root, "site", "vrml", "play-opensea.html"), "utf8");
  readFileSync(join(root, "site", "vrml", "harbour", "play.html"), "utf8");
});
