#' @importFrom rlang enexprs enexpr

#' @export
callthat_api_get <- function(api_connection, endpoint, query = NULL, ...) UseMethod("callthat_api_get")

#' @export
callthat_api_get.callthat_connection <- function(api_connection, endpoint, query = NULL, ...)  {
  vars <- enexprs(...)
  query <- enexpr(query)
  url_path <- paste0(api_connection$url, "/",  endpoint)
  all_args <- c(url_path, vars, query = query)
  r_safe(function() 1)
  r_safe(function(all_args)
    do.call(httr::GET, all_args),
    args = list(all_args = all_args)
  )
}

#' @export
callthat_api_get.default <- function(...) {
  stop("No valid API connection object was passed to this function")
}
