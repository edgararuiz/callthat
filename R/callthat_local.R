callthat_local_connection <- function(port, host, r_session, docs) {
  structure(
    list(
      url = paste0(host, ":", port),
      r_session = r_session,
      docs = docs
    ),
    class = c("callthat_local_connection", "callthat_connection")
  )
}

setOldClass("callthat_local_connection")

#' @export
callthat_local_running <- function(x, ...) {
  if (x$r_session$is_alive()) {
    TRUE
  } else {
    FALSE
  }
}

#' @export
print.callthat_local_connection <- function(x, ...) {
  if (callthat_local_running(x)) {
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
callthat_local_start <- function(api_file = "plumber.R",
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
  callthat_local_connection(
    host = host,
    port = port,
    r_session = rs,
    docs = docs
  )
}

#' @export
callthat_local_stop <- function(x) {
  x$r_session$close(grace = 0)
}
