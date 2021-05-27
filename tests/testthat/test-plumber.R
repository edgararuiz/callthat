test_that("plumber API starts and stops", {

  test_api <- call_that_plumber_start(
    system.file("plumber/sample-api", package = "callthat")
  )

  expect_s3_class(test_api, "call_that_plumber_connection")

  expect_equal(
    substr(capture.output(test_api)[[1]], 1, 14),
    "API is running"
  )

  expect_true(call_that_plumber_running(test_api))

  expect_s3_class(
    call_that_api_get(test_api, "data"),
    "response"
    )

  expect_silent(call_that_plumber_stop(test_api))

  expect_equal(
    capture.output(test_api),
    "API is not running"
  )

  expect_false(call_that_plumber_running(test_api))
})

test_that("Exceptions work", {
  expect_error(call_that_plumber_start())
  expect_error(call_that_plumber_start("notarealpath.R"))
})
