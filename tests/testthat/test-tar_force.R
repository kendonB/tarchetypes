tar_test("tar_force() can force a target to always run", {
  tar_script({
    tar_pipeline(
      tarchetypes::tar_force(x, command = tempfile(), force = 1 > 0)
    )
  })
  targets::tar_make(callr_function = NULL)
  out <- tar_read(x)
  targets::tar_make(callr_function = NULL)
  expect_false(out == tar_read(x))
})

tar_test("tar_force() does not always force a target to always run", {
  tar_script({
    tar_pipeline(
      tarchetypes::tar_force(x, command = "value", force = 1 < 0)
    )
  })
  targets::tar_make(callr_function = NULL)
  out <- tar_read(x)
  targets::tar_make(callr_function = NULL)
  expect_true(out == tar_read(x))
})
