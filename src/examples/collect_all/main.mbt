///|
fn main {
  let entries = try! @walkdir.walk("testdata/walk_fixture")
  for entry in entries {
    println("\{entry.depth}: \{entry.kind} \{entry.path}")
  }
}
