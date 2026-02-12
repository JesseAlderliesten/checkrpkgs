# checkrpkgs (development version)

The development-branch of `checkrpkgs` is *work in progress*: no version has
been released yet.

### To do
- Nothing.

### Breaking changes
- Added dependencies on `checkinput` (version 0.0.6 or higher) and `progutils`
  (version 0.0.2 or higher).
- Imported `utils::installed.packages`.
- Renamed `find_nonfunctional_pkgs()` to `find_nonfunc_pkgs()`.

### Bug fixes
- None.

### Added functions
- `find_nonfunctional_pkgs()` to find non-functional packages.
- `get_details_pkgs()` to get details of installed packages.
- `list_dependencies()` to list dependencies of packages.

### Minor improvements
- None.

### Updated documentation
- Added vignette `Installing R, Rtools and RStudio`.
- Added vignette `Instructions about R packages`.

### Updated tests
- None.
