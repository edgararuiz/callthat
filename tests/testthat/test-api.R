test_that("RSC API calls works", {
  rsc_url <- "https://colorado.rstudio.com/rsc/access-to-care/api"

  rsc_connection <- call_that_rsc_connection(rsc_url, key = "THISISNOTAKEY")

  expect_s3_class(
    rsc_connection,
    "call_that_connection"
  )

  expect_equal(
    substr(capture.output(rsc_connection)[[1]], 1, 19),
    "RStudio Connect API"
  )

  expect_s3_class(
    call_that_api_get(rsc_connection, "summary", list(state = "CA")),
    "response"
  )
})

test_that("Generic API calls works", {
  expect_silent(
    generic_conn <- call_that_connection("http://httpbin.org/get")
  )

  generic_msg <- capture.output(generic_conn)[[1]]

  expect_equal(
    substr(generic_msg, 1, 17),
    "Connection to API"
  )
})
