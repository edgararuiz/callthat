
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
library(magrittr)
library(httr)
```

### Local

``` r
library(callthat)

my_api <- callthat_local_start()
#> [1] "Starting callthat's sample API"

my_api
#> API is running on http://127.0.0.1:6556 inside an R session on PID 75098
#> Swagger page: http://127.0.0.1:6556/__docs__/

class(my_api)
#> [1] "callthat_local_connection" "callthat_connection"

callthat_local_running(my_api)
#> [1] TRUE

callthat_api_get(my_api, "data")
#> Response [http://127.0.0.1:6556/data]
#>   Date: 2021-05-21 16:44
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 4.15 kB
```

### RStudio Connect

``` r
rsc_api <- callthat_rsc_connection("https://colorado.rstudio.com/rsc/access-to-care/api")

rsc_api
#> RStudio Connect API:  https://colorado.rstudio.com/rsc/access-to-care/api
#> API Key: None set
```

``` r
callthat_api_get(rsc_api, "summary", list("state" = "CA"))
#> Response [https://colorado.rstudio.com/rsc/access-to-care/api/summary?state=CA]
#>   Date: 2021-05-21 16:44
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 111 B
```

### Secured API inside RStudio Connect

``` r
secured_api <- callthat_rsc_connection(url = "https://colorado.rstudio.com/rsc/callthat/testapi",
                                       key = Sys.getenv("CONNECT_API_KEY"))

secured_api
#> RStudio Connect API:  https://colorado.rstudio.com/rsc/callthat/testapi
#> API Key: XXXXXXXXXXXXXX
```

``` r
callthat_api_get(secured_api, "data") 
#> Response [https://colorado.rstudio.com/rsc/callthat/testapi/data]
#>   Date: 2021-05-21 16:45
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 4.15 kB
```

### Generic connection

``` r
remote_api <- callthat_connection("https://colorado.rstudio.com/rsc/access-to-care/api")

remote_api
#> Connection to API located in: https://colorado.rstudio.com/rsc/access-to-care/api
```

``` r
la_summary <- callthat_api_get(remote_api, "summary", list("state" = "LA"))

httr::content(la_summary)
#> [[1]]
#> [[1]]$state
#> [1] "LA"
#> 
#> [[1]]$hospitals
#> [1] 90
#> 
#> [[1]]$population
#> [1] 4670724
#> 
#> [[1]]$under
#> [1] 1
#> 
#> [[1]]$counties
#> [1] 64
#> 
#> [[1]]$state_id
#> [1] 19
#> 
#> [[1]]$full
#> [1] "Louisiana"
```
