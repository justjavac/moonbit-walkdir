///|
fn main {
  let files = try! @walkdir.walk_files("testdata/walk_fixture")
  for file in files {
    println(file)
  }
}
