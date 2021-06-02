#' Initializes folders and files needed to run callthat
#' @export
use_callthat <- function() {

  if(!dir_exists("inst/callthat")) dir_create("inst/callthat")

  if(!dir_exists("tests/callthat")) dir_create("tests/callthat")


}

#' Runs the callthat tests for R check
#' @param package The name of the package
#' @param reporter testthat reporter
#' @export
call_that_package_check <- function(package, reporter = testthat::ProgressReporter, ...) {
  require(package, character.only = TRUE)
  test_dir(
    "testthat",
    package = package,
    reporter = reporter,
    ...,
    load_package = "installed"
  )
}
