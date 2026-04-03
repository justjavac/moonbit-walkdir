# justjavac/walkdir

[![license](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)
[![coverage](https://img.shields.io/codecov/c/github/justjavac/walkdir/main?label=coverage)](https://codecov.io/gh/justjavac/walkdir)

`justjavac/walkdir` is a MoonBit walkdir library focused on predictable output.
It traverses directories depth-first, sorts child names lexicographically by
default, and exposes typed entries that are easy to inspect in tests or tools.

## Features

- Deterministic depth-first traversal
- Stable lexicographic ordering by default
- `DirEntry` values with `path`, `depth`, and `kind`
- `walk_files` helper for file-only use cases
- Full test coverage

## Installation

```bash
moon add justjavac/walkdir
```

## API

### `walk`

```moonbit
pub fn walk(
  root : String,
  include_root? : Bool = true,
  include_dirs? : Bool = true,
  max_depth? : Int,
  sort? : Bool = true,
) -> Array[DirEntry] raise
```

Use `walk` when you want both files and directories in a single traversal result.

- `include_root`: include the root directory in the output
- `include_dirs`: include child directories in the output
- `max_depth`: stop descending once the current depth reaches this value
- `sort`: sort each directory's children before descending

### `walk_files`

```moonbit
pub fn walk_files(
  root : String,
  max_depth? : Int,
  sort? : Bool = true,
) -> Array[String] raise
```

Use `walk_files` when only file paths matter.

### `DirEntry`

```moonbit
pub(all) struct DirEntry {
  path : String
  depth : Int
  kind : EntryKind
}
```

Helper methods:

- `DirEntry::is_dir()`
- `DirEntry::is_file()`

## Examples

Run the bundled examples with:

```bash
moon run src/examples/collect_all --target native
moon run src/examples/files_only --target native
moon run src/examples/max_depth --target native
```

## Testing

Local validation commands:

```bash
moon fmt
moon check --target all
moon test --target native -v
moon coverage analyze -p justjavac/walkdir
```

The coverage badge above is driven by Codecov and the Ubuntu coverage job in CI.
It updates after the `main` branch finishes CI and Codecov processes the
uploaded report.
