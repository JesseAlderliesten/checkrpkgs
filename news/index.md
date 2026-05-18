# Changelog

## checkrpkgs 0.8.2

#### Miscellaneous

- [`get_details_pkgs()`](https://jessealderliesten.github.io/checkrpkgs/reference/get_details_pkgs.md)
  includes the number of packages that occur more than once in the
  warning.
- Small additions and various stylistic updates to the vignettes.

## checkrpkgs 0.8.1

#### Miscellaneous

- Vignette `Instructions about R packages`: shorten name to
  `R packages`.
- Vignette `Using Git and GitHub`: add section on GitHub Actions.
- Website: show table of contents on homepage. Show more levels in the
  table of contents in Articles.

## checkrpkgs 0.8.0

#### Miscellaneous

- `README`: refer to website when appropriate. Stylistic update.
- `NEWS`: stylistic update.
- Vignettes: rely on `pkgdown` to create links to functions.

## checkrpkgs 0.7.2

#### Miscellaneous

- [`check_pkgs()`](https://jessealderliesten.github.io/checkrpkgs/reference/check_pkgs.md)
  and
  [`get_details_pkgs()`](https://jessealderliesten.github.io/checkrpkgs/reference/get_details_pkgs.md):
  replace link to `BioConductor` (a `suggested` package) documentation
  with text to get rid of a `Note` in `R cmd check` on `R 4.1.0`.
- `R-CMD-check.yaml`: also mention package `rcmdcheck` as needed
  package. Order packages alphabetically.

## checkrpkgs 0.7.1

#### Breaking changes

- Add function
  [`create_pkg_stub()`](https://jessealderliesten.github.io/checkrpkgs/reference/create_pkg_stub.md).

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

- [`get_details_pkgs()`](https://jessealderliesten.github.io/checkrpkgs/reference/get_details_pkgs.md)
  would attempt to use a non-created index if no package was found,
  leading to an error.

#### Miscellaneous

- Add light-switch to `pkgdown` page.
- Refer from the `README` to the `pkgdown` website.
- Stylistic changes to code and tests prompted by `goodpractice::gp()`.

## checkrpkgs 0.6.0

#### Breaking changes

- Dependency `progutils`: increase from `>= 0.0.6` to `>= 0.0.7` to
  ensure uniform handling of empty quotes and `NA`s through
  [`progutils::paste_quoted()`](https://jessealderliesten.github.io/checkinput/reference/paste_quoted.html).

## checkrpkgs 0.5.2

#### Miscellaneous

- Vignette `Installing R, Rtools and RStudio`: additional explanation
  about possible options. Stylistic updates.
- Vignette `Instructions about R packages`: add argument
  `build_vignettes` and update to version 3.23 in
  [`BiocManager::install()`](https://bioconductor.github.io/BiocManager/reference/install.html).
  Rearrange section ‘Troubleshooting’. Add subheadings. Smooth text.
- Vignette `Using Git and GitHub`: Explain what Git and GitHub are.
  Explain ‘local’ vs. ‘remote’. Use terminology more consistently.

## checkrpkgs 0.5.1

- Added `pkgdown` website:
  <https://jessealderliesten.github.io/checkrpkgs/>.

## checkrpkgs 0.5.0

#### Breaking changes

- [`get_details_pkgs()`](https://jessealderliesten.github.io/checkrpkgs/reference/get_details_pkgs.md):
  add argument `db`, add checks on input, and update documentation.

## checkrpkgs 0.4.0

#### Breaking changes

- Update dependencies: add suggested dependency `Matrix` that is used in
  vignettes. Remove suggested dependency `stats` after updating an
  example in the vignettes to use `methods` instead of `stats`.

#### Bugfixes

- [`get_details_pkgs()`](https://jessealderliesten.github.io/checkrpkgs/reference/get_details_pkgs.md):
  if `pkgs` has length larger than zero, warn only about duplicated
  packages that are in `pkgs`.

#### Miscellaneous

- Updated vignettes: some corrections in text, various updates. Changed
  order of some sections to be more logical. Explain notation for text
  to be filled in (e.g., `<funcname>`) and use that more consistently.
- Vignette `Installing R, Rtools and RStudio`: adjust newlines to have
  shorter lines. Add examples to section ‘Configuring R’.
- Vignette `Instructions about R packages`: some bugfixes in example
  code. More consistent code to install or update packages. Add example
  how to install from other repositories. Use evaluation of R code
  instead of hardcoding output in examples.
- Vignette `Using Git and GitHub`: add section on installing packages
  from `GitHub`.

## checkrpkgs 0.3.0

#### Breaking changes

- Dependency `BiocManager` (in `Suggests`): require version `>= 1.30.5`
  to be able to run code in vignettes.
- Dependency `ctv` (in `Suggests`): require version `>= 0.4-0` to be
  able to run code in vignettes.
- Dependency `remotes` (in `Suggests`): require version `>= 2.0.0` to be
  able to run code in vignettes.
- [`get_details_pkgs()`](https://jessealderliesten.github.io/checkrpkgs/reference/get_details_pkgs.md):
  also extract fields `"GithubRepo"` and `"GithubUsername"`. No need to
  use the hardcoded fields in the default argument. Set field
  `Repository` to `Github` if appropriate. Adjust warnings.

## checkrpkgs 0.2.0

#### Breaking changes

- Dependency `checkinput`: increase from `>= 0.0.6` to `>= 0.5.0`. This
  implicitly increases the minimum version of `R` to `>= 4.1.0` but
  removes the dependency on `vctrs`.
- Dependency `progutils`: increase from `>= 0.0.3` to `>= 0.0.6` to be
  able to use functions added to `progutils`.
- Dependency `tinytest`: declare version `>= 1.4.1` because I use
  argument `strict` in `expect_message()` and `expect_warning()`.

#### Miscellaneous

- Make the location of newlines more predictable by hardcoding newlines
  using `\n` instead of using `wrap_text()` in warnings.

## checkrpkgs 0.1.3

#### Miscellaneous

- Adjust GitHub action `check-standard` to run without the dependencies
  listed in `Suggests` which I use for documentation. The GitHub action
  runs on the released `R` version and on `R` 4.1.0 on macOS, Windows,
  and Ubuntu. It runs every Saturday on 04:23 UTC, and can be run
  manually (trigger it once manually on the main branch to be able to
  trigger it manually on other branches).
- Including GitHub actions against `R` 4.1.0 because `R` 4.1.0 is
  required to pass the R CMD check on ubuntu-latest:
  `github::hadley/strict` needs `R` \>= 4.1.0. Because `strict` is in
  `suggests` it is *not* necessary to add the dependency `R` \>= 4.1.0.
- Show folder structure in `README`.

## checkrpkgs 0.1.2

#### Breaking changes

- Dependencies: no need to import `knit()` from `knitr` or `render()`
  from `rmarkdown`, so move `knitr` and `rmarkdown` back from `Imports`
  to `Suggests`.

#### Miscellaneous

- Vignettes: fixe some URLs.
- Vignette `Instructions about R packages`: updates, especially the
  section `Getting the source code`. Explain how to point to GitHub
  repositories.

## checkrpkgs 0.1.1

#### Miscellaneous

- Use GitHub action `check-standard` on all branches (see
  `?usethis::use_github_action()`).

## checkrpkgs 0.1.0

#### Breaking changes

- [`get_details_pkgs()`](https://jessealderliesten.github.io/checkrpkgs/reference/get_details_pkgs.md):
  move argument `pkgs` to be the first argument. Warn if a package is
  found more than once. Always return information from fields
  `Repository` and `URL`.
- `find_nonfunc_pkgs()`: rename to
  [`check_pkgs()`](https://jessealderliesten.github.io/checkrpkgs/reference/check_pkgs.md).
  Warn if a package is found more than once.

#### Updated documentation

- Vignette `Instructions about R packages`: first mention BioConductor
  releases, explaining their advantage. Expand information on mirror
  websites into a separate section. Use internal links when referring to
  section headings. Use hyper links to refer to help pages.
- Vignette `Using Git and GitHub`: add info about comparing files using
  GitHub. Restructure and expand section ‘Documentation’. Use internal
  links when referring to section headings.

## checkrpkgs 0.0.1

#### Breaking changes

- Add dependencies `checkinput (>= 0.0.6)`, `knitr`,
  `progutils (>= 0.0.3)`, `rmarkdown`, and `utils` in `Depends`. Using
  `knitr` and `rmarkdown` in `Depends` because the vignettes are the
  main part of the package.
- Add dependencies in `Suggests` to be able to run all code in the
  vignettes and documentation: `BiocManager`, `conflicted`, `ctv`,
  `methods`, `pkgbuild`, `remotes`, `stats`, `strict`, `tools`.

#### Added functions

- `find_nonfunc_pkgs()`: find non-installed or non-functional packages.
- [`get_details_pkgs()`](https://jessealderliesten.github.io/checkrpkgs/reference/get_details_pkgs.md):
  get details of installed packages.

#### Updated documentation

- Updated `README`.
- Added vignette `Installing R, Rtools and RStudio`.
- Added vignette `Instructions about R packages`.
- Added vignette `Using Git and GitHub`.
