# checkrpkgs 0.1.3

### Miscellaneous
- Adjusted GitHub action `check-standard` to run without the dependencies listed
  in `Suggests` which I use for documentation. The GitHub action runs on the
  released `R` version and on `R` 4.1.0 on macOS, Windows, and Ubuntu. It is run
  every Saturday on 04:23 UTC, and can be run manually (trigger it once manually
  on the main branch to be able to trigger it manually on other branches).
- Including GitHub actions against `R` 4.1.0 because `R` 4.1.0 is required to
  pass the R CMD check on ubuntu-latest: `github::hadley/strict` needs `R` >=
  4.1. Because `strict` is in `suggests` it is *not* needed to add dependency
  `R` >= 4.1.0.
- Show folder structure in `README`.


# checkrpkgs 0.1.2
- No need to import `knit()` from `knitr` or `render()` from `rmarkdown`, so
  moved `knitr` and `rmarkdown` back from `Imports` to `Suggests`.
- Updated the `Instructions about R packages` vignette, especially the section
  `Getting the source code`. Explained how to point to GitHub repositories.
- Updated vignettes: fixed some URLs.


# checkrpkgs 0.1.1
- `checkrpkgs` now uses GitHub action `check-standard` on all branches (see
  `?usethis::use_github_action()`).


# checkrpkgs 0.1.0

### Breaking changes
- `get_details_pkgs()`: argument `pkgs` moved to be the first argument. Now
  warns if a package is found more than once. Always return information from
  fields 'Repository' and 'URL'.
- `find_nonfunc_pkgs()`: renamed to `check_pkgs()`. Now warns if a package is
  found more than once.

### Updated documentation
- Vignette `Instructions about R packages`: first mention BioConductor releases,
  explaining their advantage. Expanded information on mirror websites into a
  separate section. Use internal links when referring to section headings. Use
  hyperlinks to refer to help pages.
- Vignette `Using Git and GitHub`: add info about comparing files using GitHub.
  Restructure and expand 'Documentation'. Use internal links when referring to
  section headings. 


# checkrpkgs 0.0.1

### Breaking changes
- Added dependencies `checkinput` (version 0.0.6 or higher), `knitr`, `progutils`
  (version 0.0.3 or higher), `rmarkdown`, and `utils` in `Depends`. Using
  `knitr` and `rmarkdown` in `Depends` because the vignettes are the main part
  of the package.
- Added dependencies in `Suggests` to be able to run all code in the vignettes
  and documentation: `BiocManager`, `conflicted`, `ctv`, `methods`, `pkgbuild`,
  `remotes`, `stats`, `strict`, `tools`.

### Added functions
- `find_nonfunc_pkgs()` to find non-installed or non-functional packages.
- `get_details_pkgs()` to get details of installed packages.

### Updated documentation
- Updated `README`.
- Added vignette `Installing R, Rtools and RStudio`.
- Added vignette `Instructions about R packages`.
- Added vignette `Using Git and GitHub`.
