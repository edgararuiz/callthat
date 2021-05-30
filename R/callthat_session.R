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

callthat_session_connection <- function(api_connection) {
  callthat_session_context$connection <- api_connection
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
  current_session <- callthat_session_get()
  if(is.null(current_session)) current_session <- "local"
  if(current_session == "remote") return(remote_connection)
  if(current_session == "local") return(local_connection)
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

#' Locates available tests in the package
#' @details It locates plumber tests inside the package.  It is meant to run
#' against the package's source folders. It looks for file names with the prefix
#' 'test-plumber-...'.
#' @param test_directory Location of the test scripts
#' @export
call_that_available_tests <- function(test_directory = "tests/testthat") {
  all_tests <- dir_ls(path(test_directory))
}


