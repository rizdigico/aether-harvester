# Asset source policy

## What is tracked in git
- Editable Blender sources: `assets/blender/**/*.blend` — ALWAYS tracked.
- Source textures: `assets/textures/**` — ALWAYS tracked.
- Approved visual baselines: `tests/baselines/**` — ALWAYS tracked (CI compares against them).
- Asset manifests: `docs/autonomy/ASSET_MANIFEST.json`, `LICENSE_MANIFEST.json` — ALWAYS tracked.
- Deterministic exports that cannot be recreated without Blender runtime: `assets/export/**` — tracked with manifest entries.

## What is ignored
- `tests/current/`, `tests/diffs/` — regenerated on every capture.
- `artifacts/current/` — scratch screenshots/profiles.
- Node modules, .rokit, build outputs.

## Policy
1. Never commit a `.blend` without a manifest entry (ASSET_MANIFEST.json).
2. Never commit an export without recording its source `.blend` and export recipe.
3. Baseline updates require intentional design change + vision approval (see docs/autonomy/VISUAL_QA.md).
