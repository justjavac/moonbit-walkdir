///|
test "can_descend handles none and boundaries" {
  assert_true(can_descend(0, None))
  assert_true(can_descend(0, Some(1)))
  assert_false(can_descend(1, Some(1)))
  assert_false(can_descend(0, Some(-1)))
}

///|
test "make_entry builds the expected value" {
  let actual = make_entry("demo", 2, File)
  let expected = DirEntry::{ path: "demo", depth: 2, kind: File }
  assert_eq(actual, expected)
}
