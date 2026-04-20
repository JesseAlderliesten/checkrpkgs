
<!-- badges: start -->

![](https://img.shields.io/github/r-package/v/JesseAlderliesten/checkrpkgs?color=blue)
[![R-CMD-check](https://github.com/JesseAlderliesten/checkrpkgs/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/JesseAlderliesten/checkrpkgs/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# checkrpkgs

`checkrpkgs` provides information on installing and configuring
[R](https://www.r-project.org/),
[RStudio](https://posit.co/products/open-source/rstudio/?sid=1), and
[Rtools](https://cran.r-project.org/bin/windows/Rtools/); obtaining
information about to-be-installed and already-installed packages; and
how to get the source code of R-functions.

## Folder structure

    ├── .github
    │   └── workflows: workflows to run tests with GitHub Actions
    ├── R: functions
    ├── inst
    │   └── tinytest: tests
    ├── man: help-files
    └── tests: setup to use 'tinytest' for testing

## Installation

You can install `checkrpkgs` from
[GitHub](https://github.com/JesseAlderliesten/checkrpkgs) with:

``` r
if(!requireNamespace("remotes", quietly = TRUE)) {
  install.packages(pkgs = "remotes", quiet = FALSE)
}
remotes::install_github(repo = "JesseAlderliesten/checkrpkgs", dependencies = TRUE,
                        upgrade = FALSE, force = FALSE, quiet = FALSE,
                        build_vignettes = TRUE, lib = NULL,
                        verbose = getOption("verbose"))
```

## Example

The main content of `checkrpkgs` consists of vignettes:

- *Installing R, Rtools and RStudio*:
  `vignette("install_r", package = "checkrpkgs")`. This vignette
  contains instructions on installing and configuring
  [R](https://www.r-project.org/),
  [RStudio](https://posit.co/products/open-source/rstudio/?sid=1), and
  [Rtools](https://cran.r-project.org/bin/windows/Rtools/).
- *Instructions about R packages*:
  `vignette("r_pkgs", package = "checkrpkgs")`. This vignette contains
  information on installing and getting information about R packages. It
  also explains how to obtain the source code of R functions.
- *Using Git and GitHub*:
  `vignette("git_github", package = "checkrpkgs")`. This vignette
  contains information about setting up and using Git and
  [GitHub](https://github.com/).

In addition, `checkrpkgs` contains the functions `check_pkgs()` and
`get_details_pkgs()`:

``` r
library(checkrpkgs)
check_pkgs(pkgs = "abcdef1") # package is absent
#> Warning in check_pkgs(pkgs = "abcdef1"): non-installed packages: 'abcdef1'
#> $absent
#> [1] "abcdef1"
#> 
#> $nonfunc
#> character(0)

get_details_pkgs(pkgs = c("utils", "checkrpkgs"))
#>            Package      LibPath                                            
#> checkrpkgs "checkrpkgs" "C:/Users/Eigenaar/AppData/Local/R/win-library/4.5"
#> utils      "utils"      "C:/Program Files/R/R-4.5.2/library"               
#>            Version Priority Depends
#> checkrpkgs "0.1.1" NA       NA     
#> utils      "4.5.2" "base"   NA     
#>            Imports                                              LinkingTo
#> checkrpkgs "checkinput (>= 0.0.6), progutils (>= 0.0.3), utils" NA       
#> utils      NA                                                   NA       
#>            Suggests                                                                                                     
#> checkrpkgs "BiocManager, conflicted, ctv, knitr, methods, pkgbuild,\nremotes, rmarkdown, strict, tinytest, tools, stats"
#> utils      "methods, xml2, commonmark, knitr, jsonlite"                                                                 
#>            Enhances License              License_is_FOSS License_restricts_use
#> checkrpkgs NA       "MIT + file LICENSE" NA              NA                   
#> utils      NA       "Part of R 4.5.2"    NA              NA                   
#>            OS_type MD5sum NeedsCompilation Built   Repository
#> checkrpkgs NA      NA     "no"             "4.5.2" NA        
#> utils      NA      NA     "yes"            "4.5.2" NA        
#>            Additional_repositories
#> checkrpkgs NA                     
#> utils      NA                     
#>            URL                                               SystemRequirements
#> checkrpkgs "https://github.com/JesseAlderliesten/checkrpkgs" NA                
#> utils      NA                                                NA
```
