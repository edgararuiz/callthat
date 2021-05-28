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

#' @export
call_that_session_start <- function(local_connection, remote_connection) {
  current_session <- callthat_session_get()
  if(is.null(current_session)) current_session <- "local"
  if(current_session == "remote") return(remote_connection)
  if(current_session == "local") return(local_connection)
}

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



