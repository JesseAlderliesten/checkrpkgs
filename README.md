
# checkrpkgs

`checkrpkgs` provides information on installing and configuring
[R](https://www.r-project.org/),
[RStudio](https://posit.co/products/open-source/rstudio/?sid=1), and
[Rtools](https://cran.r-project.org/bin/windows/Rtools/); obtaining
information about to-be-installed and already-installed packages; how to
get the source code of R-functions; setting up and using Git and
[GitHub](https://github.com/);

## Installation

You can install `checkrpkgs` from
[GitHub](https://github.com/JesseAlderliesten/checkrpkgs) with:

``` r
if(!requireNamespace("remotes", quietly = TRUE)) {
  install.packages(pkgs = "remotes", quiet = FALSE)
}
remotes::install_github(repo = "JesseAlderliesten/checkrpkgs", dependencies = TRUE,
                        upgrade = FALSE, force = FALSE, quiet = FALSE,
                        build_vignettes = TRUE, lib = .libPaths(),
                        verbose = getOption("verbose"))
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(checkrpkgs)
## basic example code
```
