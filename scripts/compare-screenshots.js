// Visual regression comparison for Roblox screenshots.
// Usage: node scripts/compare-screenshots.js <name> [thresholdPct]
// Expects: tests/baselines/<name>.png  tests/current/<name>.png
// Writes:  tests/diffs/<name>.png  + exits 1 if diff exceeds threshold.
const fs = require("fs");
const path = require("path");
const { PNG } = require("pngjs");
const pixelmatch = require("pixelmatch");

const name = process.argv[2];
const thresholdPct = Number(process.argv[3] || 1.0); // default 1% differing pixels

if (!name) {
  console.error("Usage: node scripts/compare-screenshots.js <name> [thresholdPct]");
  process.exit(2);
}

const baselinePath = path.join(__dirname, "..", "tests", "baselines", `${name}.png`);
const currentPath = path.join(__dirname, "..", "tests", "current", `${name}.png`);
const diffDir = path.join(__dirname, "..", "tests", "diffs");
const diffPath = path.join(diffDir, `${name}.png`);

if (!fs.existsSync(baselinePath)) {
  console.error(`Missing baseline: ${baselinePath}`);
  console.error("Capture the current screen first and copy it to tests/baselines/ to establish a baseline.");
  process.exit(2);
}
if (!fs.existsSync(currentPath)) {
  console.error(`Missing current screenshot: ${currentPath}`);
  process.exit(2);
}

const baseline = PNG.sync.read(fs.readFileSync(baselinePath));
const current = PNG.sync.read(fs.readFileSync(currentPath));

if (baseline.width !== current.width || baseline.height !== current.height) {
  console.error(`Size mismatch: baseline ${baseline.width}x${baseline.height} vs current ${current.width}x${current.height}`);
  process.exit(2);
}

const diff = new PNG({ width: baseline.width, height: baseline.height });
const diffPixels = pixelmatch(baseline.data, current.data, diff.data, baseline.width, baseline.height, {
  threshold: 0.15, // perceptual threshold per channel (lighting/AA tolerance)
});

const totalPixels = baseline.width * baseline.height;
const diffPct = (diffPixels / totalPixels) * 100;

fs.mkdirSync(diffDir, { recursive: true });
fs.writeFileSync(diffPath, PNG.sync.write(diff));

const pass = diffPct <= thresholdPct;
console.log(
  `${name}: ${diffPixels}/${totalPixels} pixels differ (${diffPct.toFixed(2)}%) - threshold ${thresholdPct}% -> ${pass ? "PASS" : "FAIL"}`
);
console.log(`Diff written: ${diffPath}`);
process.exit(pass ? 0 : 1);
