
<!-- badges: start -->

![](https://img.shields.io/github/r-package/v/JesseAlderliesten/checkrpkgs?color=blue)
[![R-CMD-check](https://github.com/JesseAlderliesten/checkrpkgs/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/JesseAlderliesten/checkrpkgs/actions/workflows/check-standard.yaml)
[![R-CMD-check-no-suggests](https://github.com/JesseAlderliesten/checkrpkgs/actions/workflows/check-no-suggests.yaml/badge.svg)](https://github.com/JesseAlderliesten/checkrpkgs/actions/workflows/check-no-suggests.yaml)
<!-- badges: end -->

# checkrpkgs

`checkrpkgs` explains how to install and configure
[R](https://www.r-project.org/),
[Rtools](https://cran.r-project.org/bin/windows/Rtools/), and
[RStudio](https://posit.co/products/open-source/rstudio?sid=1); how to
install R packages and get information about to-be-installed and
already-installed packages; how to get the source code of R functions;
and how to set up and use Git and GitHub with RStudio.

## Installation

Visit the [checkrpkgs
website](https://jessealderliesten.github.io/checkrpkgs/) to explore the
package, or install `checkrpkgs` from
[GitHub](https://github.com/JesseAlderliesten/checkrpkgs) using the
following R code:

``` r
if(!requireNamespace("remotes")) {
  install.packages(pkgs = "remotes")
}
remotes::install_github(repo = "JesseAlderliesten/checkrpkgs",
                        upgrade = FALSE, build_vignettes = TRUE, lib = NULL)
```

## Content

`checkrpkgs` consists of three vignettes:

- [Installing R, Rtools and
  RStudio](https://jessealderliesten.github.io/checkrpkgs/articles/install_r.html):
  `vignette("install_r", package = "checkrpkgs")`, explaining how to
  install and configure [R](https://www.r-project.org/),
  [Rtools](https://cran.r-project.org/bin/windows/Rtools/), and
  [RStudio](https://posit.co/products/open-source/rstudio?sid=1).
- [R
  packages](https://jessealderliesten.github.io/checkrpkgs/articles/r_pkgs.html):
  `vignette("r_pkgs", package = "checkrpkgs")`, explaining how to
  install R packages; how to get information about to-be-installed and
  already-installed R packages; and how to get the source code of R
  functions.
- [Using Git and
  GitHub](https://jessealderliesten.github.io/checkrpkgs/articles/git_github.html):
  `vignette("git_github", package = "checkrpkgs")`, explaining how to
  set up and use Git and [GitHub](https://github.com/) with RStudio.

## License

This project is licensed under the terms of the [MIT
License](LICENSE.md).

## Citation

    To cite package 'checkrpkgs' in publications use:

      Alderliesten J (2026). _checkrpkgs: Installing and Using R, Rtools,
      RStudio, R Packages, Git and GitHub_. R package version 1.1.0, commit
      efcdfe34b621b2dd1e85dd77f0fcd94d9c84e0cc,
      <https://github.com/JesseAlderliesten/checkrpkgs>.

    A BibTeX entry for LaTeX users is

      @Manual{,
        title = {checkrpkgs: Installing and Using R, Rtools, RStudio, R Packages, Git and
    GitHub},
        author = {Jesse Alderliesten},
        year = {2026},
        note = {R package version 1.1.0, commit efcdfe34b621b2dd1e85dd77f0fcd94d9c84e0cc},
        url = {https://github.com/JesseAlderliesten/checkrpkgs},
      }

## Similar resources

- The book [What They Forgot to Teach You About R](https://rstats.wtf/)
  by J. Bryan, J. Hester, S. Pileggi, and E. D. Aja
- The book [An introduction to R](https://intro2r.com/) by A.
  Douglas, D. Roos, F. Mancini, A. Couto and D. Lusseau
- Section
  [`Prerequisites`](https://rstudio-conf-2022.github.io/build-tidy-tools/pre-reqs.html)
  from the workshop [Building tidy
  tools](https://rstudio-conf-2022.github.io/build-tidy-tools/) by E.
  Rand and I. Lyttle
- Developers might be interested in my package
  [`develcoder`](https://jessealderliesten.github.io/develcoder/) with
  code and templates to develop R packages.
