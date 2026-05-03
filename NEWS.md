# checkrpkgs 0.6.0

### Breaking changes
- Dependency `progutils`: increase from `>= 0.0.6` to `>= 0.0.7` to ensure
  uniform handling of empty quotes and `NA`s through `progutils::paste_quoted()`.


# checkrpkgs 0.5.2

### Miscellaneous
- Vignette `Installing R, Rtools and RStudio`: additional explanation about
  possible options. Stylistic updates.
- Vignette `Instructions about R packages`: add argument `build_vignettes` and
  update to version 3.23 in `BiocManager::install()`. Rearrange section
  'Troubleshooting'. Add subheadings. Smooth text.
- Vignette `Using Git and GitHub`: Explain what Git and GitHub are. Explain
  'local' vs. 'remote'. Use terminology more consistently.


# checkrpkgs 0.5.1
- Use pkgdown, see https://r-pkgs.org/website.html and https://pkgdown.r-lib.org/.


# checkrpkgs 0.5.0

### Breaking changes
- Updated `get_details_pkgs()`: added argument `db`, additional checks on input,
  and updated documentation.


# checkrpkgs 0.4.0

### Breaking changes
- Updated dependencies: add suggested dependency `Matrix` that is used in
  vignettes. Remove suggested dependency `stats` after updating an example in
  the vignettes to use `methods` instead of `stats`.

### Bugfixes ###
- `get_details_pkgs()`: if `pkgs` has length larger than zero, warn only about
  duplicated packages that are in `pkgs`.

### Miscellaneous
- Updated vignettes: some corrections in text, various updates. Changed order of
  some sections to be more logical. Explain notation for text to be filled in
  (e.g., `<funcname>`) and use that more consistently.
  `Installing R, Rtools and RStudio`: Adjusted newlines to have shorter lines.
  Add examples to section 'Configuring R'. `Instructions about R packages`: some
  bugfixes in example code. More consistent code to install or update packages.
  Add example how to install from other repositories. Use evaluation of R code
  instead of hardcoding output in examples. `Using Git and GitHub`: added
  section on installing packages from `GitHub`.


# checkrpkgs 0.3.0

### Breaking changes
- Dependency `BiocManager` (in `Suggests`): require version `>= 1.30.5` to be
  able to run code in vignettes.
- Dependency `ctv` (in `Suggests`): require version `>= 0.4-0` to be able to run
  code in vignettes.
- Dependency `remotes` (in `Suggests`): require version `>= 2.0.0` to be able to
  run code in vignettes.
- `get_details_pkgs()`: also extract fields `"GithubRepo"` and `"GithubUsername"`.
  No need to use the hardcoded fields in the default argument. Set field
  `Repository` to `Github` if appropriate. Adjusted warnings.


# checkrpkgs 0.2.0

### Breaking changes
- Dependency `checkinput`: increase from `>= 0.0.6` to `>= 0.5.0`.
  This implicitly increases the minimum version of `R` to `>= 4.1.0` but removes
  the dependency on `vctrs`.
- Dependency `progutils`: increase from `>= 0.0.3` to `>= 0.0.6` to be able to
  use functions added to `progutils`.
- Dependency `tinytest`: declare version `>= 1.4.1` because I use argument
  `strict` in `expect_message()` and `expect_warning()`.

### Miscellaneous
- Make the location of newlines more predictable by hardcoding newlines using
  `\n` instead of using `wrap_text()` in warnings.


# checkrpkgs 0.1.3

### Miscellaneous
- Adjusted GitHub action `check-standard` to run without the dependencies listed
  in `Suggests` which I use for documentation. The GitHub action runs on the
  released `R` version and on `R` 4.1.0 on macOS, Windows, and Ubuntu. It runs
  every Saturday on 04:23 UTC, and can be run manually (trigger it once manually
  on the main branch to be able to trigger it manually on other branches).
- Including GitHub actions against `R` 4.1.0 because `R` 4.1.0 is required to
  pass the R CMD check on ubuntu-latest: `github::hadley/strict` needs `R` >=
  4.1.0. Because `strict` is in `suggests` it is *not* necessary to add the
  dependency `R` >= 4.1.0.
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
  fields `Repository` and `URL`.
- `find_nonfunc_pkgs()`: renamed to `check_pkgs()`. Now warns if a package is
  found more than once.

### Updated documentation
- Vignette `Instructions about R packages`: first mention BioConductor releases,
  explaining their advantage. Expanded information on mirror websites into a
  separate section. Use internal links when referring to section headings. Use
  hyperlinks to refer to help pages.
- Vignette `Using Git and GitHub`: add info about comparing files using GitHub.
  Restructure and expand section 'Documentation'. Use internal links when
  referring to section headings.


# checkrpkgs 0.0.1

### Breaking changes
- Added dependencies `checkinput (>= 0.0.6)`, `knitr`, `progutils (>= 0.0.3)`,
  `rmarkdown`, and `utils` in `Depends`. Using `knitr` and `rmarkdown` in
  `Depends` because the vignettes are the main part of the package.
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
