
<!-- badges: start -->

![](https://img.shields.io/github/r-package/v/JesseAlderliesten/checkrpkgs?color=blue)
[![R-CMD-check](https://github.com/JesseAlderliesten/checkrpkgs/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/JesseAlderliesten/checkrpkgs/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# checkrpkgs

`checkrpkgs` explains how to install and configure
[R](https://www.r-project.org/),
[RStudio](https://posit.co/products/open-source/rstudio/?sid=1), and
[Rtools](https://cran.r-project.org/bin/windows/Rtools/); how to install
R packages; how to get information about to-be-installed and
already-installed packages; how to get the source code of R functions;
and how to set up and use Git and GitHub with RStudio.

## Installation

Visit the [checkrpkgs
website](https://jessealderliesten.github.io/checkrpkgs/) to explore the
package, or install `checkrpkgs` from
[GitHub](https://github.com/JesseAlderliesten/checkrpkgs) using the
following R code (you need to run R as administrator):

``` r
if(!requireNamespace("remotes", quietly = TRUE)) {
  install.packages(pkgs = "remotes", quiet = FALSE)
}
remotes::install_github(repo = "JesseAlderliesten/checkrpkgs",
                        dependencies = NA, upgrade = FALSE, force = FALSE,
                        quiet = FALSE, build_vignettes = TRUE, lib = NULL,
                        verbose = getOption("verbose"))
```

## Content

The main content of `checkrpkgs` are its vignettes:

- [Installing R, Rtools and
  RStudio](https://jessealderliesten.github.io/checkrpkgs/articles/install_r.html):
  `vignette("install_r", package = "checkrpkgs")`, explaining how to
  install and configure [R](https://www.r-project.org/),
  [RStudio](https://posit.co/products/open-source/rstudio/?sid=1), and
  [Rtools](https://cran.r-project.org/bin/windows/Rtools/).
- [R
  packages](https://jessealderliesten.github.io/checkrpkgs/articles/r_pkgs.html):
  `vignette("r_pkgs", package = "checkrpkgs")`, explaining how to get
  information about to-be-installed and already-installed package and
  how to get the source code of R functions.
- [Using Git and
  GitHub](https://jessealderliesten.github.io/checkrpkgs/articles/git_github.html):
  `vignette("git_github", package = "checkrpkgs")`, explaining how to
  set up and use Git and [GitHub](https://github.com/) with RStudio.

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
#>            Package      Version  MD5sum
#> checkrpkgs "checkrpkgs" "0.10.0" NA    
#> utils      "utils"      "4.6.0"  NA    
#>            Built                                                          
#> checkrpkgs "R 4.6.0; ; 2026-06-04 21:09:09 UTC; windows"                  
#> utils      "R 4.6.0; x86_64-w64-mingw32; 2026-04-24 08:04:59 UTC; windows"
#>            Priority LibPath                                            
#> checkrpkgs NA       "C:/Users/Eigenaar/AppData/Local/R/win-library/4.6"
#> utils      "base"   "C:/Program Files/R/R-4.6.0/library"               
#>            Repository Additional_repositories
#> checkrpkgs "Github"   NA                     
#> utils      NA         NA                     
#>            URL                                                                                                
#> checkrpkgs "https://github.com/JesseAlderliesten/checkrpkgs,\nhttps://jessealderliesten.github.io/checkrpkgs/"
#> utils      NA                                                                                                 
#>            GithubRepo   GithubUsername      SystemRequirements NeedsCompilation
#> checkrpkgs "checkrpkgs" "JesseAlderliesten" NA                 "no"            
#> utils      NA           NA                  NA                 "yes"           
#>            OS_type Depends
#> checkrpkgs NA      NA     
#> utils      NA      NA     
#>            Imports                                               LinkingTo
#> checkrpkgs "checkinput (>= 0.11.0), progutils (>= 0.6.0), utils" NA       
#> utils      NA                                                    NA       
#>            Suggests                                                                                                                                                                            
#> checkrpkgs "BiocManager (>= 1.30.5), conflicted, ctv (>= 0.4-0), knitr,\nMatrix, methods, pkgbuild, remotes (>= 2.0.0), rmarkdown,\nsessioninfo (>= 1.2.0), strict, tinytest (>= 1.4.1), tools"
#> utils      "methods, xml2, commonmark, knitr, jsonlite"
```

# Similar resources

- The book [What They Forgot to Teach You About R](https://rstats.wtf/)
  by Jennifer Bryan, Jim Hester, Shannon Pileggi, and E. David Aja
- The book [An introduction to R](https://intro2r.com/) by Alex Douglas,
  Deon Roos, Francesca Mancini, Ana Couto and David Lusseau

Developers might be interested in my package
[develcoder](https://jessealderliesten.github.io/develcoder/) with code
to develop R packages.
