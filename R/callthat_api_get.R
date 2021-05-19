#' @export
callthat_api_get <- function(api_connection, endpoint, query = NULL, ...) UseMethod("callthat_api_get")

#' @export
callthat_api_get.callthat_connection <- function(api_connection, endpoint, query = NULL, ...)  {
  url_path <- paste0(api_connection$url, "/",  endpoint)
  r_safe(function() 1)
  r_safe(function(ur, enp, qry)
    httr::GET(url = ur, query = qry),
    args = list(ur = url_path, qry = query)
  )
}

#' @export
callthat_api_get.default <- function(...) {
  stop("No valid API connection object was passed to this function")
}

