test_that("plumber API starts and stops", {

  pkg_path <- system.file(package = "callthat")

  callthat:::callthat_session_set_remote()

  expect_silent(
    local_connection <- call_that_plumber_start(
      paste0(pkg_path, "/plumber/sample-api")
    )
  )

  expect_silent(
    test_api <- call_that_session_start(local_connection, local_connection)
  )

  expect_equal(
   call_that_test_remote(
      "sample-api",
      api_connection = local_connection,
      plumber_directory = paste0(pkg_path, "/plumber"),
      test_directory = paste0(pkg_path, "/tests"),
      testthat_reporter = testthat::SilentReporter
    ),
   "remote"
  )


  expect_silent(
    call_that_session_stop()
  )
})


