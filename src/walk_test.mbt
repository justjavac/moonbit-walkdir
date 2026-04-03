///|
fn fixture_root() -> String {
  join_path("testdata", "walk_fixture")
}

///|
fn join_path(lhs : String, rhs : String) -> String {
  let left : @path.Path = lhs
  let right : @path.Path = rhs
  "\{left.join(right)}"
}

///|
fn entry(
  path : String,
  depth : Int,
  kind : @walkdir.EntryKind,
) -> @walkdir.DirEntry {
  @walkdir.DirEntry::{ path, depth, kind }
}

///|
test "walk returns sorted depth-first entries" {
  let root = fixture_root()
  let nested = join_path(root, "nested")
  let deeper = join_path(nested, "deeper")
  let actual = @walkdir.walk(root)
  let expected = [
    entry(root, 0, Dir),
    entry(join_path(root, "alpha.txt"), 1, File),
    entry(join_path(root, "bravo.log"), 1, File),
    entry(nested, 1, Dir),
    entry(join_path(nested, "charlie.txt"), 2, File),
    entry(deeper, 2, Dir),
    entry(join_path(deeper, "delta.md"), 3, File),
  ]
  assert_eq(actual, expected)
}

///|
test "walk respects include flags and max depth" {
  let root = fixture_root()
  let actual = @walkdir.walk(
    root,
    include_root=false,
    include_dirs=false,
    max_depth=1,
    sort=false,
  )
  let paths = actual.map(entry => entry.path)
  paths.sort_by((lhs, rhs) => lhs.lexical_compare(rhs))
  assert_eq(paths, [join_path(root, "alpha.txt"), join_path(root, "bravo.log")])
}

///|
test "walk_files returns only file paths" {
  let root = fixture_root()
  let nested = join_path(root, "nested")
  let deeper = join_path(nested, "deeper")
  let all_files = @walkdir.walk_files(root)
  let shallow_files = @walkdir.walk_files(root, max_depth=1)
  assert_eq(all_files, [
    join_path(root, "alpha.txt"),
    join_path(root, "bravo.log"),
    join_path(nested, "charlie.txt"),
    join_path(deeper, "delta.md"),
  ])
  assert_eq(shallow_files, [
    join_path(root, "alpha.txt"),
    join_path(root, "bravo.log"),
  ])
}

///|
test "dir entry helpers expose kind checks" {
  let dir_entry = entry(fixture_root(), 0, Dir)
  let file_entry = entry(join_path(fixture_root(), "alpha.txt"), 1, File)
  assert_true(dir_entry.is_dir())
  assert_false(dir_entry.is_file())
  assert_true(file_entry.is_file())
  assert_false(file_entry.is_dir())
}

///|
test "walk reports missing roots" {
  let missing = join_path("testdata", "does_not_exist")
  let result : Result[Array[@walkdir.DirEntry], Error] = try? @walkdir.walk(
    missing,
  )
  guard result is Err(@walkdir.WalkError::NotFound(path)) && path == missing else {
    fail("expected NotFound")
  }
}

///|
test "walk rejects file roots" {
  let file_path = join_path(fixture_root(), "alpha.txt")
  let result : Result[Array[@walkdir.DirEntry], Error] = try? @walkdir.walk(
    file_path,
  )
  guard result is Err(@walkdir.WalkError::NotDirectory(path)) &&
    path == file_path else {
    fail("expected NotDirectory")
  }
}
