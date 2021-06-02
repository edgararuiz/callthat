test_that("plumber API starts and stops", {

  pkg_path <- system.file(package = "callthat")

  expect_silent(
    local_connection <- call_that_plumber_start(
      paste0(pkg_path, "/plumber/sample-api")
    )
  )

  expect_silent(
    test_api <- call_that_session_start(local_connection, local_connection)
  )

  expect_s3_class(
    test_api,
    "call_that_plumber_connection"
  )

  expect_equal(
    substr(capture.output(test_api)[[1]], 1, 14),
    "API is running"
  )

  expect_s3_class(
    call_that_api_get(test_api, "data"),
    "response"
  )

  expect_s3_class(
    call_that_api_post(
      test_api,
      endpoint = "sum",
      body = list(a = 1, b = 2),
      encode = "json"
    ),
    "response"
  )

  expect_s3_class(
    call_that_api_put(
      test_api,
      endpoint = "predict",
      body = list(weight = 2),
      encode = "json"
    ),
    "response"
  )

  expect_silent(
    call_that_session_stop(test_api)
  )

  expect_equal(
    capture.output(test_api),
    "API is not running"
  )
})

test_that("Exceptions work", {
  test_file <- tempfile()
  writeLines("stop()", test_file)
  expect_error(call_that_plumber_start(
    api_folder = path_dir(test_file),
    api_file =  path_file(test_file)
  ))

  expect_error(
    call_that_plumber_start()
  )

  expect_error(
    call_that_plumber_start("notarealpath.R")
  )
})



