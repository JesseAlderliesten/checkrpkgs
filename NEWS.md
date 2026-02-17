# checkrpkgs 0.0.2_devel (development version)
The development-branch of `checkrpkgs` is *work in progress*: see below for the
released versions.

### To do
- Nothing.

### Breaking changes
- None.

### Bug fixes
- None.

### Added functions
- None.

### Minor improvements
- None.

### Updated documentation
- None.

### Updated tests
- None.


# checkrpkgs 0.0.1

### Breaking changes
- Added dependencies `checkinput` (version 0.0.6 or higher), `progutils`
  (version 0.0.2 or higher), `utils`, `knitr`, and `rmarkdown` in `Depends`.
  Using `knitr` and `rmarkdown` in `Depends` because the vignettes are the main
  part of the package.
- Added dependencies in `Suggests` to be able to run all code in the vignettes
  and documentation: `BiocManager`, `conflicted`, `ctv`, `methods`, `pkgbuild`,
  `remotes`, `strict`, `tools`, `stats`.

### Added functions
- `find_nonfunc_pkgs()` to find non-installed or non-functional packages.
- `get_details_pkgs()` to get details of installed packages.

### Updated documentation
- Updated README.
- Added vignette `Installing R, Rtools and RStudio`.
- Added vignette `Instructions about R packages`.
