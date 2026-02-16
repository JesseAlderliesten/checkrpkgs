# checkrpkgs (development version)

The development-branch of `checkrpkgs` is *work in progress*: no version has
been released yet.

### To do
- Nothing.

### Breaking changes
- Added dependencies `checkinput` (version 0.0.6 or higher) and `progutils`
  (version 0.0.2 or higher) in `Depends`, and `BiocManager` in `Suggests`.
- Imported `utils::installed.packages`.
- Renamed `find_nonfunctional_pkgs()` to `find_nonfunc_pkgs()` and changed its
  return to a list of length two, giving the absent and nonfunctional packages
  separately.

### Bug fixes
- None.

### Added functions
- `find_nonfunctional_pkgs()` to find non-functional packages.
- `get_details_pkgs()` to get details of installed packages.

### Minor improvements
- None.

### Updated documentation
- Added vignette `Installing R, Rtools and RStudio`.
- Added vignette `Instructions about R packages`.

### Updated tests
- None.
