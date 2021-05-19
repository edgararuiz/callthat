#' @export
callthat_rsc_connection <- function(url, key = NULL) {
  structure(
    list(
      url = url,
      key = key
    ),
    class = c("callthat_rsc_connection", "callthat_connection")
  )
}

setOldClass("callthat_rsc_connection")

#' @export
print.callthat_rsc_connection <- function(x, ...) {
  cat(paste0(
    "RStudio Connect API:  ", x$url,
    "\nAPI Key: ", ifelse(is.null(x$key), "None set", "XXXXXXXXXXXXXX")
  ))
}

