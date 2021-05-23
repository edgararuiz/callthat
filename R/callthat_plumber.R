callthat_plumber_connection <- function(port, host, r_session, docs) {
  structure(
    list(
      url = paste0(host, ":", port),
      r_session = r_session,
      docs = docs
    ),
    class = c("callthat_plumber_connection", "callthat_connection")
  )
}

setOldClass("callthat_plumber_connection")

#' @export
callthat_plumber_running <- function(x, ...) {
  if (x$r_session$is_alive()) {
    TRUE
  } else {
    FALSE
  }
}

#' @export
print.callthat_plumber_connection <- function(x, ...) {
  if (callthat_plumber_running(x)) {
    docs_msg <- NULL
    if(x$docs) docs_msg <- paste0("\nSwagger page: ", x$url, "/__docs__/")
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

#' @export
callthat_plumber_start <- function(api_file = "plumber.R",
                                 host = "http://127.0.0.1",
                                 port = 6556,
                                 root_folder = system.file("plumber/sample-api", package = "callthat"),
                                 docs = TRUE
                                 ) {
  if(root_folder == system.file("plumber/sample-api", package = "callthat") &&
     api_file == "plumber.R") {
    print("Starting callthat's sample API")
  }
  api_path <- paste(root_folder, api_file, sep = "/")
  rs <- r_session$new()
  rs$call(function(ap, prt, docs) {
    ar <- plumber::plumb(ap)
    plumber::pr_run(ar, port = prt, docs = docs)
    },
    args = list(ap = api_path, prt = port, docs = docs)
  )
  callthat_plumber_connection(
    host = host,
    port = port,
    r_session = rs,
    docs = docs
  )
}

#' @export
callthat_plumber_stop <- function(x) {
  x$r_session$close(grace = 0)
}
