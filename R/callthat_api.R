#' @importFrom plumber plumb pr_run
#' @importFrom callr r_session r_safe
#' @importFrom httr GET

#' @export
callthat_api <- function(port, r_session) {
  structure(
    list(
      port = port,
      r_session = r_session
    ),
    class = "callthat_api"
  )
}

setOldClass("callthat_api")

#' @export
callthat_api_running <- function(x, ...) {
  if (x$r_session$is_alive()) {
    TRUE
  } else {
    FALSE
  }
}

#' @export
print.callthat_api <- function(x, ...) {
  if (callthat_api_running(x)) {
    cat(paste0(
      "API is running on port ", x$port,
      " inside PID ", x$r_session$get_pid()
    ))
  } else {
    cat("API is not running")
  }
  invisible(x)
}

#' @export
callthat_api_start <- function(api_file = "plumber.R",
                               port = 1212,
                               root_folder = system.file("sample-api", package = "callthat")) {
  api_path <- paste(root_folder, api_file, sep = "/")
  rs <- r_session$new()
  rs$call(function(ap, prt) {
    ar <- plumb(ap)
    pr_run(ar, port = prt, docs = FALSE)
  },
  args = list(ap = api_path, prt = port)
  )
  callthat_api(
    port = port,
    r_session = rs
  )
}

#' @export
callthat_api_stop <- function(x) {
  x$r_session$close(grace = 0)
}
