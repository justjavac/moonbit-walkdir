# walkdir

Deterministic directory walking for MoonBit.

```mbt check
///|
test "walkdir basic example" {
  let files = @walkdir.walk_files("testdata/walk_fixture", max_depth=1)
  assert_eq(files.length(), 2)
}
```
