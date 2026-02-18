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
