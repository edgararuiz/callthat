call_that_plumber_connection <- function(port, host, r_session, docs) {
  structure(
    list(
      url = paste0(host, ":", port),
      r_session = r_session,
      docs = docs
    ),
    class = c("call_that_plumber_connection", "call_that_connection")
  )
}

setOldClass("call_that_plumber_connection")

#' Confirm if a local plumber app is running
#' @details It returns a TRUE/FALSE based on if the R session that is running the
#' plumber API is running.
#' @param api_connection A call_that_connection object
#' @param ... Available to allow backwards compatability in case more arguments are implemented in later versions of this package. Not in use today.
#' @seealso call_that_plumber_start
#' @export
call_that_plumber_running <- function(api_connection, ...) {
  if (api_connection$r_session$is_alive()) {
    TRUE
  } else {
    FALSE
  }
}

#' @export
print.call_that_plumber_connection <- function(x, ...) {
  if (call_that_plumber_running(x)) {
    docs_msg <- NULL
    if (x$docs) docs_msg <- paste0("\nSwagger page: ", x$url, "/__docs__/")
    cat(paste0(
      "API is running on ", x$url,
      " inside an R session on PID ", x$r_session$get_pid(),
      docs_msg
    ))
  } else {
    cat("API is not running")
  }
  invisible(x)
}

#' Runs a plumber app in a separate R session
#' @param api_folder The API source file root folder.
#' @param api_file API's file name
#' @param host URL for the API's host. Defaults to 127.0.0.1
#' @param port The port number to run the API at. Defaults to 6556.
#' @param docs Flag that indicates wether to start the Swagger page for the app.  Defaults to TRUE.
#' @return An \code{httr} \code{request} object
#' @export
call_that_plumber_start <- function(api_folder = NULL,
                                    port = 6556,
                                    docs = TRUE,
                                    api_file = "plumber.R",
                                    host = "http://127.0.0.1"
                                    ) {
  if(is.null(api_folder)) stop("No API folder location passed")

  api_path <- path(api_folder, api_file)

  if(!file_exists(api_path)) stop(paste0("Invalid plumber file path"))

  r_safe(function(x) {})
  rs <- r_session$new()
  rs$call(function(ap, prt, docs) {
    ar <- plumber::plumb(ap)
    plumber::pr_run(ar, port = prt, docs = docs)
  },
  args = list(ap = api_path, prt = port, docs = docs)
  )
  call_that_plumber_connection(
    host = host,
    port = port,
    r_session = rs,
    docs = docs
  )
}

#' Stops a local plumber API
#' @details It stops the R session that is running a local API.
#' @param api_connection A call_that_connection object
#' @export
call_that_plumber_stop <- function(api_connection) {
  api_connection$r_session$close(grace = 0)
}
