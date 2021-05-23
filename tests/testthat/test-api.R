test_that("RSC API calls works", {
  rsc_url <- "https://colorado.rstudio.com/rsc/access-to-care/api"

  rsc_connection <- callthat_rsc_connection(rsc_url, key = "THISISNOTAKEY")
  rsc_msg <- capture.output(rsc_connection)[[1]]
  substr_msg <- substr(rsc_msg, 1, 19)

  rsc_get <- callthat_api_get(rsc_connection, "summary", list(state = "CA"))

  expect_s3_class(rsc_connection, "callthat_connection")
  expect_equal(substr_msg, "RStudio Connect API")
  expect_s3_class(rsc_get, "response")
})

test_that("Generic API calls works", {
  generic_url <- "http://httpbin.org/get"

  generic_connection <- callthat_connection(generic_url)
  generic_msg <- capture.output(generic_connection)[[1]]
  substr_msg <- substr(generic_msg, 1, 17)

  generic_get <- callthat_api_get(generic_connection)

  expect_s3_class(generic_connection, "callthat_connection")
  expect_equal(substr_msg, "Connection to API")
  expect_s3_class(generic_get, "response")
})

test_that("Error when not a valid connection", {
  expect_error(
    callthat_api_get(list())
  )
})

test_that("Generic POST & PUT works", {

  expect_equal(
    callthat_api_post(
      callthat_connection("http://httpbin.org/"),
      endpoint = "post",
      body = "Test"
    )$status_code,
    200
  )

  expect_equal(
    callthat_api_put(
      callthat_connection("http://httpbin.org/"),
      endpoint = "put",
      body = "Test"
    )$status_code,
    200
  )
})
