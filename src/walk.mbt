///|
/// Describes errors raised before traversal starts.
pub(all) suberror WalkError {
  NotFound(String)
  NotDirectory(String)
} derive(Show)

///|
/// Walks a directory tree in deterministic depth-first order.
///
/// Children are sorted lexicographically by default so repeated runs produce
/// the same output. Set `include_root=false` to skip the root entry and
/// `include_dirs=false` to emit only files. `max_depth=0` keeps traversal at
/// the root level.
///
/// # Parameters
///
/// - `root`: The directory to traverse.
/// - `include_root`: Whether the returned array should include the root itself.
/// - `include_dirs`: Whether directories should be included in the returned array.
/// - `max_depth`: The maximum depth to descend from `root`.
/// - `sort`: Whether to sort each directory's children before traversal.
///
/// # Errors
///
/// - Raises `WalkError::NotFound(root)` when `root` does not exist.
/// - Raises `WalkError::NotDirectory(root)` when `root` is not a directory.
///
/// # Example
/// ```mbt check
/// test "walk example" {
///   let entries = @walkdir.walk("testdata/walk_fixture", max_depth=1)
///   assert_eq(entries.length(), 4)
/// }
/// ```
pub fn walk(
  root : String,
  include_root? : Bool = true,
  include_dirs? : Bool = true,
  max_depth? : Int,
  sort? : Bool = true,
) -> Array[DirEntry] raise {
  validate_root(root)
  let entries : Array[DirEntry] = []
  if include_root {
    entries.push(make_entry(root, 0, Dir))
  }
  walk_dir(root, 0, include_dirs~, max_depth, sort~, entries)
  entries
}

///|
/// Walks a directory tree and returns only file paths.
///
/// This is a convenience wrapper around `walk(..., include_dirs=false,
/// include_root=false)` for file-oriented use cases such as indexing or
/// filtering.
///
/// # Parameters
///
/// - `root`: The directory to traverse.
/// - `max_depth`: The maximum depth to descend from `root`.
/// - `sort`: Whether to sort each directory's children before traversal.
///
/// # Errors
///
/// Raises the same errors as `walk`.
///
/// # Example
/// ```mbt check
/// test "walk_files example" {
///   let files = @walkdir.walk_files("testdata/walk_fixture")
///   assert_eq(files.length(), 4)
/// }
/// ```
pub fn walk_files(
  root : String,
  max_depth? : Int,
  sort? : Bool = true,
) -> Array[String] raise {
  let entries = match max_depth {
    Some(depth) =>
      walk(root, include_root=false, include_dirs=false, max_depth=depth, sort~)
    None => walk(root, include_root=false, include_dirs=false, sort~)
  }
  entries.map(entry => entry.path)
}

///|
/// Validates that traversal starts from an existing directory.
fn validate_root(root : String) -> Unit raise {
  if !@fs.path_exists(root) {
    raise WalkError::NotFound(root)
  }
  if !@fs.is_dir(root) {
    raise WalkError::NotDirectory(root)
  }
}

///|
/// Recursively collects entries under the current directory.
fn walk_dir(
  current : String,
  current_depth : Int,
  include_dirs~ : Bool,
  max_depth : Int?,
  sort~ : Bool,
  entries : Array[DirEntry],
) -> Unit raise {
  guard can_descend(current_depth, max_depth) else { () }
  let children = @fs.read_dir(current)
  if sort {
    children.sort_by((lhs, rhs) => lhs.lexical_compare(rhs))
  }
  let base : @path.Path = current
  for name in children {
    let child : @path.Path = name
    let child_path = "\{base.join(child)}"
    let child_depth = current_depth + 1
    if @fs.is_dir(child_path) {
      if include_dirs {
        entries.push(make_entry(child_path, child_depth, Dir))
      }
      walk_dir(
        child_path,
        child_depth,
        include_dirs~,
        max_depth,
        sort~,
        entries,
      )
    } else {
      entries.push(make_entry(child_path, child_depth, File))
    }
  }
}

///|
/// Decides whether traversal may continue below the current depth.
fn can_descend(current_depth : Int, max_depth : Int?) -> Bool {
  match max_depth {
    Some(limit) => current_depth < limit
    None => true
  }
}

///|
/// Builds a `DirEntry` value from raw traversal data.
fn make_entry(path : String, depth : Int, kind : EntryKind) -> DirEntry {
  DirEntry::{ path, depth, kind }
}
