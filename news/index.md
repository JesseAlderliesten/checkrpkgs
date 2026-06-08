# Changelog

## checkrpkgs 0.12.1

#### Documentation

- Describe how to make R stricter with respect to conflict resolution
  using base
  18. 
- Describe and mention Rtools before RStudio.

## checkrpkgs 0.12.0

#### Breaking changes

- Dependency `checkinput`: increase minimum version from `0.11.0` to
  `1.0.0` to depend on a stable version.

#### Documentation

- Remove old `NEWS`.

## checkrpkgs 0.11.0

#### Breaking changes

- Remove functions `check_pkgs()` and `get_details_pkgs()`, move the
  relevant information to vignette `R packages`.
- Remove unused function `create_pkg_stub()`.
- Remove dependency `progutils` because it is no longer used.
- Move dependencies `checkinput` and `utils` from `Imports` to
  `Suggests` because they are used in vignettes but not anymore in code.

## checkrpkgs 0.10.0

#### Breaking changes

- Add dependency `sessioninfo (>= 1.2.0)` to `Suggests` because it
  mentioned in the documentation of `get_details_pkgs()` and in the
  vignettes.
- Dependency `checkinput`: increase minimum version from `0.8.0` to
  `0.11.0` to incorporate change of argument name `allow_zero_length()`
  to `allow_zerolength()`.
- Dependency `progutils`: increase minimum version from `0.2.0` to
  `0.6.0` to incorporate change of argument name `allow_zero_length()`
  to `allow_zerolength()`.
- `check_pkgs()`: argument `quietly` renamed to `silently` because it
  silences warnings.

## checkrpkgs 0.9.0

#### Breaking changes

- Dependency `checkinput`: increase minimum version from `0.6.0` to
  `0.8.0` to update argument name `allow_zero` to `allow_zero_length`.
- Dependency `progutils`: increase minimum version from `0.0.9` to
  `0.2.0` to update argument name `allow_zero` to `allow_zero_length`.

#### Documentation

- Vignette `Installing R, Rtools and RStudio`: rename and restructure
  section on configuring R. Move documentation for developers to my
  package `develcoder`. Expanded section ‘Documentation and help’.

## checkrpkgs 0.7.1

#### Added functions

- Add function `create_pkg_stub()`.

## checkrpkgs 0.7.0

#### Breaking changes

- Dependency `checkinput`: increase from `>= 0.5.0` to `>= 0.6.0`,
  needed to use `paste_quoted()` that is re-exported from `checkinput`
  to `progutils`.
- Dependency `progutils`: increase from `>= 0.0.7` to `>= 0.0.9` to use
  function `create_tempdir()` to create a temporary directory that can
  safely be removed.
- Use `roxygen2` version 8.0.0.

#### Bug fixes

- `get_details_pkgs()` would attempt to use a non-created index if no
  package was found, leading to an error.

## checkrpkgs 0.6.0

#### Breaking changes

- Dependency `progutils`: increase from `>= 0.0.6` to `>= 0.0.7` to
  ensure uniform handling of empty quotes and `NA`s through
  [`progutils::paste_quoted()`](https://jessealderliesten.github.io/checkinput/reference/paste_quoted.html).

## checkrpkgs 0.5.0

#### Breaking changes

- `get_details_pkgs()`: add argument `db`, add checks on input, and
  update documentation.

## checkrpkgs 0.4.0

#### Breaking changes

- Update dependencies: add dependency `Matrix` to `Suggests` because it
  is used in vignettes. Remove dependency `stats` from `Suggests` after
  updating an example in the vignettes to use `methods` instead of
  `stats`.

#### Bugfixes

- `get_details_pkgs()`: if `pkgs` has length larger than zero, warn only
  about duplicated packages that are in `pkgs`.

## checkrpkgs 0.3.0

#### Breaking changes

- Dependencies: require `BiocManager >= 1.30.5`, `ctv >= 0.4-0` and
  `remotes >= 2.0.0` to be able to run code in vignettes.
- `get_details_pkgs()`: also extract fields `"GithubRepo"` and
  `"GithubUsername"`. No need to use the hardcoded fields in the default
  argument. Set field `Repository` to `Github` if appropriate. Adjust
  warnings.

## checkrpkgs 0.2.0

#### Breaking changes

- Dependency `checkinput`: increase from `>= 0.0.6` to `>= 0.5.0`. This
  implicitly increases the minimum version of `R` to `>= 4.1.0` but
  removes the dependency on `vctrs`.
- Dependency `progutils`: increase from `>= 0.0.3` to `>= 0.0.6` to be
  able to use functions added to `progutils`.
- Dependency `tinytest`: declare version `>= 1.4.1` because I use
  argument `strict` in `expect_message()` and `expect_warning()`.
