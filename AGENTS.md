# AGENTS Guide

This repository contains the MoonBit module `justjavac/walkdir`.

## What This Project Is

- A deterministic walkdir library for MoonBit.
- The public package lives under `src/`.
- The main implementation files are `src/entry.mbt` and `src/walk.mbt`.
- The checked package interface is `src/pkg.generated.mbti`.

## Repository Layout

- `moon.mod.json`: module metadata. The module uses `source = "src"`.
- `src/moon.pkg`: package imports for the main library package.
- `src/*_test.mbt`: black-box tests for public behavior.
- `src/*_wbtest.mbt`: white-box tests for internal helpers.
- `src/README.mbt.md`: short module documentation with checked examples.
- `src/examples/`: runnable example packages.
- `testdata/walk_fixture/`: filesystem fixture used by tests and examples.
- `.github/workflows/ci.yml`: CI for tests and coverage uploads.
- `codecov.yml`: Codecov flag configuration.

## Editing Expectations

- Keep source files inside `src/` unless the change is specifically about root-level repo files.
- Preserve MoonBit block style with `///|` between top-level blocks.
- Prefer small focused edits that keep each commit readable.
- Do not hand-edit `pkg.generated.mbti` unless you are intentionally checking in the result of `moon info`.
- Keep example packages under `src/examples/` aligned with the public API.

## Documentation Expectations

- Public types and functions should have proper doc comments.
- Internal helpers should keep short one-line comments when the intent is not obvious.
- `README.md` is the repository-level guide.
- `src/README.mbt.md` is the lightweight module document.

## Validation Workflow

Run these when changing library behavior or docs with checked examples:

```bash
moon fmt
moon check --target all
moon test --target native -v
moon info --target native
moon coverage analyze -p justjavac/walkdir
```

When checking examples manually, use:

```bash
moon run src/examples/collect_all --target native
moon run src/examples/files_only --target native
moon run src/examples/max_depth --target native
```

## Testing Notes

- Prefer updating or extending `testdata/walk_fixture/` instead of building test directories dynamically unless the test specifically needs that.
- Keep black-box tests focused on public behavior such as order, filtering, depth limits, and error cases.
- Use white-box tests sparingly for helpers like depth checks or entry construction.

## Coverage Notes

- The repository currently expects full source coverage.
- CI uploads coverage for Linux, macOS, and Windows separately through Codecov flags.
