# checkrpkgs 0.10.0

### Breaking changes
- Add dependency `sessioninfo (>= 1.2.0)` to `Suggests` because it mentioned in
  the documentation of `get_details_pkgs()` and in the vignettes.
- Dependency `checkinput`: increase minimum version from `0.8.0` to `0.11.0` to
  incorporate change of argument name `allow_zero_length()` to
  `allow_zerolength()`.
- Dependency `progutils`: increase minimum version from `0.2.0` to `0.6.0` to
  incorporate change of argument name `allow_zero_length()` to
  `allow_zerolength()`.
- `check_pkgs()`: argument `quietly` renamed to `silently` because it silences
  warnings.

### Documentation
- Refer to package `sessioninfo`.
- Vignette `Installing R`: restructure and expand various sections.


# checkrpkgs 0.9.0

### Breaking changes
- Dependency `checkinput`: increase minimum version from `0.6.0` to `0.8.0` to
  update argument name `allow_zero` to `allow_zero_length`.
- Dependency `progutils`: increase minimum version from `0.0.9` to `0.2.0` to
  update argument name `allow_zero` to `allow_zero_length`.

### Documentation
- Vignette `Installing R, Rtools and RStudio`: rename and restructure section on
  configuring R. Move documentation for developers to my package `develcoder`.
  Expanded section 'Documentation and help'.


# checkrpkgs 0.8.3

### Documentation
- Move information from documentation of `check_pkgs()` and `get_details_pkgs()`
  to the vignette `R packages`.


# checkrpkgs 0.8.1

### Documentation
- Vignette `Instructions about R packages`: shorten name to `R packages`.
- Vignette `Using Git and GitHub`: add section on GitHub Actions.


# checkrpkgs 0.7.1

### Added functions
- Add function `create_pkg_stub()`.


# checkrpkgs 0.7.0

### Breaking changes
- Dependency `checkinput`: increase from `>= 0.5.0` to `>= 0.6.0`, needed to use
  `paste_quoted()` that is re-exported from `checkinput` to `progutils`.
- Dependency `progutils`: increase from `>= 0.0.7` to `>= 0.0.9` to use function
  `create_tempdir()` to create a temporary directory that can safely be removed.
- Use `roxygen2` version 8.0.0.

### Bug fixes
- `get_details_pkgs()` would attempt to use a non-created index if no package
  was found, leading to an error.


# checkrpkgs 0.6.0

### Breaking changes
- Dependency `progutils`: increase from `>= 0.0.6` to `>= 0.0.7` to ensure
  uniform handling of empty quotes and `NA`s through `progutils::paste_quoted()`.


# checkrpkgs 0.5.2

### Documentation
- Vignette `Installing R, Rtools and RStudio`: additional explanation about
  possible options. Stylistic updates.
- Vignette `Instructions about R packages`: add argument `build_vignettes` and
  update to version 3.23 in example code of `BiocManager::install()`.
- Vignette `Using Git and GitHub`: explain what Git and GitHub are. Explain
  'local' vs. 'remote'. Use terminology more consistently.


# checkrpkgs 0.5.0

### Breaking changes
- `get_details_pkgs()`: add argument `db`, add checks on input, and update
  documentation.


# checkrpkgs 0.4.0

### Breaking changes
- Update dependencies: add dependency `Matrix` to `Suggests` because it is used
  in vignettes. Remove dependency `stats` from `Suggests` after updating an
  example in the vignettes to use `methods` instead of `stats`.

### Bugfixes ###
- `get_details_pkgs()`: if `pkgs` has length larger than zero, warn only about
  duplicated packages that are in `pkgs`.

### Documentation
- Updated vignettes: some corrections in text. Changed order of some sections to
  be more logical. Explain notation for text to be filled in (e.g., `<funcname>`)
  and use that more consistently.
- Vignette `Installing R, Rtools and RStudio`: Add examples to section
  'Configuring R'.
- Vignette `Instructions about R packages`: some bugfixes in example code. More
  consistent code to install or update packages. Add example how to install from
  other repositories. Use evaluation of R code instead of hardcoding output in
  examples.
- Vignette `Using Git and GitHub`: add section on installing packages from
  `GitHub`.


# checkrpkgs 0.3.0

### Breaking changes
- Dependencies: require `BiocManager >= 1.30.5`, `ctv >= 0.4-0` and
  `remotes >= 2.0.0` to be able to run code in vignettes.
- `get_details_pkgs()`: also extract fields `"GithubRepo"` and `"GithubUsername"`.
  No need to use the hardcoded fields in the default argument. Set field
  `Repository` to `Github` if appropriate. Adjust warnings.


# checkrpkgs 0.2.0

### Breaking changes
- Dependency `checkinput`: increase from `>= 0.0.6` to `>= 0.5.0`.
  This implicitly increases the minimum version of `R` to `>= 4.1.0` but removes
  the dependency on `vctrs`.
- Dependency `progutils`: increase from `>= 0.0.3` to `>= 0.0.6` to be able to
  use functions added to `progutils`.
- Dependency `tinytest`: declare version `>= 1.4.1` because I use argument
  `strict` in `expect_message()` and `expect_warning()`.


# checkrpkgs 0.1.2

### Breaking changes
- Dependencies: no need to import `knit()` from `knitr` or `render()` from
  `rmarkdown`, so move `knitr` and `rmarkdown` back from `Imports` to `Suggests`.

### Documentation
- Vignette `Instructions about R packages`: updates, especially the section
  `Getting the source code`. Explain how to point to GitHub repositories.


# checkrpkgs 0.1.0

### Breaking changes
- `get_details_pkgs()`: move argument `pkgs` to be the first argument. Warn if a
  package is found more than once. Always return information from fields
  `Repository` and `URL`.
- `find_nonfunc_pkgs()`: rename to `check_pkgs()`. Warn if a package is found
  more than once.

### Documentation
- Vignette `Instructions about R packages`: first mention BioConductor releases,
  explaining their advantage. Expand information on mirror websites into a
  separate section. Use internal links when referring to section headings. Use
  hyper links to refer to help pages.
- Vignette `Using Git and GitHub`: add info about comparing files using GitHub.
  Restructure and expand section 'Documentation'. Use internal links when
  referring to section headings.


# checkrpkgs 0.0.1

### Breaking changes
- Add dependencies `checkinput (>= 0.0.6)`, `knitr`, `progutils (>= 0.0.3)`,
  `rmarkdown`, and `utils` to `Depends`. Using `knitr` and `rmarkdown` in
  `Depends` because the vignettes are the main part of the package.
- Add dependencies `BiocManager`, `conflicted`, `ctv`, `methods`, `pkgbuild`,
  `remotes`, `stats`, `strict`, `tools` to `Suggests` to be able to run all code
  in the vignettes and documentation.

### Added functions
- `find_nonfunc_pkgs()`: find non-installed or non-functional packages.
- `get_details_pkgs()`: get details of installed packages.

### Documentation
- Updated `README`.
- Added vignette `Installing R, Rtools and RStudio`.
- Added vignette `Instructions about R packages`.
- Added vignette `Using Git and GitHub`.
