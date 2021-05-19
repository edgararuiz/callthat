
<!-- README.md is generated from README.Rmd. Please edit that file -->

# callthat

<!-- badges: start -->
<!-- badges: end -->

`callthat` is meant for `plumber` API developers who plan to distribute
their APIs inside an R package. This package enables the testing of the
API’s endpoints within the `testthat` framework. This allows the R
Checks to also confirm that the endpoints still behave as expected. The
ultimate goal of `callthat` is to ensure for the package’s automated
testing confirms that the APIs still work even if the developer did not
run the package’s test locally.

## Installation

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("edgararuiz/callthat")
```

## Usage

``` r
library(callthat)

my_api <- callthat_local_start()
#> [1] "Starting callthat's sample API"

my_api
#> API is running on port  inside PID 52178
#> Swagger page: :/__docs__/

class(my_api)
#> [1] "callthat_connection"       "callthat_local_connection"

callthat_local_running(my_api)
#> [1] TRUE

callthat_api_get(my_api, "data")
#> Response [http://127.0.0.1:6556/data]
#>   Date: 2021-05-19 00:09
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 4.15 kB

remote_api <- callthat_connection("https://colorado.rstudio.com/rsc/access-to-care/api")

remote_api
#> $url
#> [1] "https://colorado.rstudio.com/rsc/access-to-care/api"
#> 
#> attr(,"class")
#> [1] "callthat_connection"

callthat_api_get(remote_api, "summary", list("state" = "LA"))
#> Response [https://colorado.rstudio.com/rsc/access-to-care/api/summary?state=LA]
#>   Date: 2021-05-19 00:09
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 109 B
```
