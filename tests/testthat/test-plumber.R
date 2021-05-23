
test_api <- callthat_plumber_start()

test_that("plumber API starts and stops", {

  expect_s3_class(test_api, "callthat_plumber_connection")
  expect_equal(
    substr(capture.output(test_api)[[1]], 1, 14),
    "API is running"
  )
  expect_true(callthat_plumber_running(test_api))

  expect_silent(callthat_plumber_stop(test_api))
  expect_equal(
    capture.output(test_api),
    "API is not running"
  )
  expect_false(callthat_plumber_running(test_api))
})


