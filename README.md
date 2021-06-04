
<!-- README.md is generated from README.Rmd. Please edit that file -->

# callthat <img src='man/figures/logo.png' align="right" height="138" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/edgararuiz/callthat/workflows/R-CMD-check/badge.svg)](https://github.com/edgararuiz/callthat/actions)
[![Codecov test
coverage](https://codecov.io/gh/edgararuiz/callthat/branch/master/graph/badge.svg)](https://codecov.io/gh/edgararuiz/callthat?branch=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/callthat)](https://CRAN.R-project.org/package=callthat)
<!-- badges: end -->

`callthat` is meant for `plumber` API developers who plan to distribute
their APIs inside an R package. This package enables the testing of the
API’s endpoints within the `testthat` framework. This allows the R
Checks to also confirm that the endpoints still behave as expected.

The ultimate goal of `callthat` is to ensure that the package’s
automated testing catches issues with the API even if the developer did
not perform unit testing.

## Installation

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("edgararuiz/callthat")
```

## Usage

### `plumber` API in your package

Place your API in the `inst/plumber` folder of your package. That way
`plumber::available_apis("MyPakcageName")` can locate the APIs, after
your package is installed.

In `MyPakcageName/inst/plumber/sample-api`:

``` r
library(plumber)

#* Runs a prediction of the Weight
#* @get /predict
function(weight) {
  wtg <- as.numeric(weight)
  model <- stats::lm(mpg ~ wt, data = datasets::mtcars)
  stats::predict(model, newdata = data.frame(wt = wtg))
}
```

### Inside the `testthat` folder

``` r
library(testthat)
library(callthat)
library(httr)
```

Create the test using the same name as the name of the API. Add the
prefix `test-plumber`.

In `MyPakcageName/tests/testthat/test-plumber-sample-api.R`:

``` r
test_that("Show how to use test", {
  expect_silent({
    
    # ------------- Start plumber API ------------------- 
    local_api <- call_that_plumber_start(
      system.file("plumber/sample-api", package = "MyPackageName")
      )
    
    # ------------- Start test session ------------------ 
    api_session <- call_that_session_start(local_api)
  })
  expect_s3_class(
    
    # ---------------- Make API call --------------------
    get_predict <- call_that_api_get(
      api_session, 
      endpoint = "predict", 
      query = list(weight = 1)
      ),
    "response"
  )
  
  # ---------- Run tests against response ---------------
  ## Test to confirm that the response was a success
  expect_equal(
    get_predict$status_code,
    200
  )
  ## Test to confirm the output of the API is correct
  expect_equal(
    round(content(get_predict)[[1]]),
    32
  )
  
  # ----- Close the session, and the plumber API --------
  expect_null(
    call_that_session_stop(api_session)
  )
})
```

### Managing the API tests

`callthat` matches the API to the test by name. The
`call_that_available_tests()` returns a table with the available APIs in
your package, and it displays if there is a matching test.

``` r
call_that_available_tests()
```

    #> # A tibble: 1 x 4
    #>   api        api_path              test_exists test_path                        
    #>   <chr>      <fs::path>            <lgl>       <fs::path>                       
    #> 1 sample-api inst/plumber/sample-… TRUE        inst/tests/test-plumber-sample-a…

### Run tests against the published API

`callthat` makes it possible to run the exact same tests used for unit
testing, for integration testing.

Open a connection with the published API. If that API is running in
RStudio Connect, then use `call_that_rsc_connection()`, otherwise use
the generic `call_that_connection()`.

``` r
published_api <- call_that_rsc_connection(
  url = "https://colorado.rstudio.com/rsc/callthat/testapi",
  key = Sys.getenv("RSC_TOKEN") # Optional, only if access to your API is restricted
  )

published_api
#> RStudio Connect API:  https://colorado.rstudio.com/rsc/callthat/testapi
#> API Key: XXXXXXXXXXXXXX
```

The `call_that_test_remote()` functions runs the tests for the API, but
it is possible to also pass the published API’s connection so that the
tests run remotely.

``` r
call_that_test_remote("sample-api", published_api)
```

    #> ✓ |  OK F W S | Context
    #> ⠏ |   0       | plumber-sample-api                                              ✓ |   5       | plumber-sample-api
    #> 
    #> ══ Results ═════════════════════════════════════════════════════════════════════
    #> [ FAIL 0 | WARN 0 | SKIP 0 | PASS 5 ]
