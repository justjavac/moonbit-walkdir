///|
fn main {
  let entries = try! @walkdir.walk("testdata/walk_fixture", max_depth=1)
  for entry in entries {
    println("\{entry.depth}: \{entry.kind} \{entry.path}")
  }
}
