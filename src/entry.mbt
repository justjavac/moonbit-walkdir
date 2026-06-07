///|
/// Describes whether a walked entry is a file or a directory.
pub(all) enum EntryKind {
  File
  Dir
} derive(Eq, Debug, ToJson)

///|
pub impl Show for EntryKind with fn output(kind, logger) {
  match kind {
    File => logger.write_string("File")
    Dir => logger.write_string("Dir")
  }
}

///|
/// Represents one item returned by directory traversal.
///
/// `path` is the full path returned by the walker, `depth` is the nesting level
/// relative to the requested root, and `kind` tells whether the entry is a file
/// or directory.
pub(all) struct DirEntry {
  path : String
  depth : Int
  kind : EntryKind
} derive(Eq, Debug, ToJson)

///|
pub impl Show for DirEntry with fn output(entry, logger) {
  logger.write_string("DirEntry::{ path: ")
  logger.write(entry.path)
  logger.write_string(", depth: ")
  logger.write(entry.depth)
  logger.write_string(", kind: ")
  logger.write(entry.kind)
  logger.write_string(" }")
}

///|
/// Returns `true` when this entry represents a directory.
///
/// # Example
/// ```mbt check
/// test "DirEntry::is_dir example" {
///   let entry = @walkdir.DirEntry::{ path: "demo", depth: 0, kind: Dir }
///   assert_true(entry.is_dir())
/// }
/// ```
pub fn DirEntry::is_dir(entry : DirEntry) -> Bool {
  entry.kind is Dir
}

///|
/// Returns `true` when this entry represents a file.
///
/// # Example
/// ```mbt check
/// test "DirEntry::is_file example" {
///   let entry = @walkdir.DirEntry::{ path: "demo.txt", depth: 1, kind: File }
///   assert_true(entry.is_file())
/// }
/// ```
pub fn DirEntry::is_file(entry : DirEntry) -> Bool {
  entry.kind is File
}
