callthat_session_context <- new.env(parent = emptyenv())

callthat_session_set_local <- function() {
  callthat_session_context$current_environment <- "local"
}

callthat_session_set_remote <- function() {
  callthat_session_context$current_environment <- "remote"
}

callthat_session_get <- function() {
  callthat_session_context$current_environment
}

callthat_session_connection_set <- function(api_connection) {
  callthat_session_context$connection <- api_connection
}

callthat_session_connection_get <- function() {
  callthat_session_context$connection
}

callthat_session_connection_reset <- function(api_connection) {
  callthat_session_context$connection <- NULL
}

#' Allows to switch between running tests locally or remotely
#' @details The purpose is to allow running the exact same tests locally, and
#' after the API is published.
#' @param local_connection A \code{call_that_connection} object. This will be the
#' default connections to be used for tests
#' @param remote_connection A \code{call_that_connection} object. This will be the
#' connections used when running the tests remotely. Defaults to NULL.
#' @seealso call_that_session_stop
#' @export
call_that_session_start <- function(local_connection, remote_connection = NULL) {

  ret_conn <- NULL
  current_session <- callthat_session_get()

  if(is.null(current_session)) current_session <- "local"

  if(current_session == "remote") {
    if(!is.null(callthat_session_connection_get())) {
      ret_conn <- callthat_session_connection_get()
    } else {
      if(is.null(remote_connection)) stop("No default remote connection is available")
      ret_conn <- remote_connection
    }
  }

  if(current_session == "local") ret_conn <- local_connection

  ret_conn
}

#' Stops an API connection
#' @details Use this function at the end of the tests to make sure the connection
#' is closed.  It is meant to make sure the R session running the local API is
#' stopped.
#' @param api_connection A \code{call_that_connection} object.
#' @export
call_that_session_stop <- function(api_connection) {
  UseMethod("call_that_session_stop")
}

#' @export
call_that_session_stop.call_that_plumber_connection <- function(api_connection) {
  call_that_plumber_stop(
    api_connection = api_connection
    )
}

#' @export
call_that_session_stop.default <- function(api_connection) {
}

#' Matches APIs to tests
#' @details It looks for test scripts with the prefix 'test-plumber-...'. It
#' matches the last part of the script's name and matches it to plumber API
#' inside the 'inst/plumber' folder.
#' @param test_directory Location of the test scripts. Defaults to 'test/testthat'.
#' @param plumber_directory Location of the plumber APIs. Defaults to 'inst/plumber'.
#' @export
call_that_available_tests <- function(test_directory = "tests/testthat", plumber_directory = "inst/plumber") {
  all_tests <- dir_ls(path(test_directory))

  test_names <- path_file(all_tests)

  first_part <- substr(test_names, 1, 13)

  test_prefix <- "test-plumber-"

  plumber_tests_path <- all_tests[first_part == test_prefix]

  plumber_tests_1 <- test_names[first_part == test_prefix]

  plumber_tests_2 <- substr(plumber_tests_1, 14, nchar(plumber_tests_1) - 2)

  inst_plumber <- dir_ls(plumber_directory)

  plumber_apis <- as.character(
    lapply(strsplit(inst_plumber, "/"), function(x) x[[length(x)]])
    )

  ats <- lapply(
    plumber_apis,
    function(x) {
      tp <- plumber_tests_path[x == plumber_apis]
      tibble(
        api = x,
        api_path = path(plumber_directory, x),
        test_exists = !is.na(tp),
        test_path = tp
      )
    })

  Reduce(rbind, ats)
}

#' Runs a test script against a remote connection
#' @param api_name Character vector with the name of the API
#' @param api_connection Optional argument.  A \code{call_that_connection} object.
#' @param testthat_reporter Optional argument. The reporter to use when running
#' the test script.  Defaults to \code{testthat::ProgressReporter}
#' If none is passed, the pre-set remote connection set at the test script level
#' will be used.
#' @export
call_that_test_remote <- function(api_name = NULL,
                                  api_connection = NULL,
                                  testthat_reporter = testthat::ProgressReporter
                                  ){

  avt <- call_that_available_tests()

  mt <- avt[avt$api== api_name,]

  if(nrow(mt) > 1) stop("Multiple test scripts found")

  test_path <- mt$test_path

  prev_env <- callthat_session_context$current_environment

  callthat_session_set_remote()

  if(!is.null(api_connection)) {
    callthat_session_connection_set(api_connection = api_connection)
  }

  test_file(test_path, reporter = testthat_reporter)

  if(!is.null(api_connection)) {
    callthat_session_connection_reset()
  }

  callthat_session_context$current_environment <- prev_env
}


