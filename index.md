# checkrpkgs

`checkrpkgs` provides information on installing and configuring
[R](https://www.r-project.org/),
[RStudio](https://posit.co/products/open-source/rstudio/?sid=1), and
[Rtools](https://cran.r-project.org/bin/windows/Rtools/); obtaining
information about to-be-installed and already-installed packages; and
how to get the source code of R functions.

## Installation

Visit the [checkrpkgs
website](https://jessealderliesten.github.io/checkrpkgs/) to explore the
package., or install `checkrpkgs` from
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

## Example

The main content of `checkrpkgs` consists of vignettes:

- [Installing R, Rtools and
  RStudio](https://jessealderliesten.github.io/checkrpkgs/articles/install_r.html):
  [`vignette("install_r", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/install_r.md).
  This vignette contains instructions on installing and configuring
  [R](https://www.r-project.org/),
  [RStudio](https://posit.co/products/open-source/rstudio/?sid=1), and
  [Rtools](https://cran.r-project.org/bin/windows/Rtools/).
- [R
  packages](https://jessealderliesten.github.io/checkrpkgs/articles/r_pkgs.html):
  [`vignette("r_pkgs", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/r_pkgs.md).
  This vignette contains information on installing and getting
  information about R packages. It also explains how to obtain the
  source code of R functions.
- [Using Git and
  GitHub](https://jessealderliesten.github.io/checkrpkgs/articles/git_github.html):
  [`vignette("git_github", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/git_github.md).
  This vignette contains information about setting up and using Git and
  [GitHub](https://github.com/).

In addition, `checkrpkgs` contains the functions
[`check_pkgs()`](https://jessealderliesten.github.io/checkrpkgs/reference/check_pkgs.md)
and
[`get_details_pkgs()`](https://jessealderliesten.github.io/checkrpkgs/reference/get_details_pkgs.md):

``` r

library(checkrpkgs)
check_pkgs(pkgs = "abcdef1") # package is absent

get_details_pkgs(pkgs = c("utils", "checkrpkgs"))
```

# Similar resources

- The book [What They Forgot to Teach You About R](https://rstats.wtf/)
  by Jennifer Bryan, Jim Hester, Shannon Pileggi, and E. David Aja
- The book [An introduction to R](https://intro2r.com/) by Alex Douglas,
  Deon Roos, Francesca Mancini, Ana Couto and David Lusseau

Developers might be interested in my package
[develcoder](https://jessealderliesten.github.io/develcoder/) with code
to develop R packages.
