#' List package dependencies
#'
#' Function to list package dependencies and the number of dependencies.
#' Information about dependencies for non-CRAN packages is currently *not*
#' correctly handled.
#'
#' @param pkgs Character vector of package names. Names of packages from
#' [GitHub](https://github.com/) can be in the format `username/repository` or
#' only the `repository` name.
#' @param deps_type Character vector indicating the type of dependencies, used
#' as argument `which` of [tools::package_dependencies].
#' @param recursive `TRUE` or `FALSE`: include recursive dependencies?
#' @param name_per_pkg `TRUE` or `FALSE`: give the names of dependencies
#' separately for each package in `pkgs`?
#' @param number_per_pkg `TRUE` or `FALSE`: give the number of dependencies
#' separately for each package in `pkgs`?
#' @param name_total `TRUE` or `FALSE`: give the names of the total set of
#' dependencies?
#' @param add_pkgs_to_total `TRUE` or `FALSE`: add names of the packages for
#' which the dependencies are requested themselves to the list and number of
#' total dependencies?
#' @param exclude_high_prio `TRUE` or `FALSE`: exclude high priority packages
#' from the total counts and names of dependencies?
#' @param exclude_pkgs `NULL` or a character vector with package names to be
#' omitted from the listed dependencies. Note that dependencies of those
#' packages will *not* be omitted.
#' @param sort_ndeps_by Character vector indicating if the number of
#' dependencies per package should be sorted on package names (`"names"`) or on
#' their number of dependencies (`"ndeps"`). The other elements of the returned
#' list are are sorted on package names irrespective of the value of this
#' argument.
#'
#' @returns
#' A list with for each package in `pkgs` the names and number of dependencies,
#' the names and number of all dependencies, and the number of unique packages
#' supplied in the arguments `exclude_pkgs` and `exclude_high_prio`. Note that
#' the latter does *not* indicate the number of packages that were actually
#' excluded.
#'
#' @section To do:
#' Information about dependencies for packages from non-CRAN repositories (e.g.,
#' Bioconductor, GitHub) is currently *not* correctly handled. According to
#' `tools::package_dependencies()`, `NULL` is given as dependency if a package
#' is not found in the database, whereas `character(0)` indicates the package
#' does not have any dependencies. However, this distinction seems not to be
#' retained by `list_dependencies()`. A warning is issued if the number of
#' dependencies has zero length to indicate this. Can that be adressed by using
#' [utils::packageDescription()] or [utils::installed.packages()]?
#'
#' See https://pak.r-lib.org/reference/pkg_deps_explain.html which gives
#' details about which function creates the dependency;
#' https://github.com/yihui/xfun/blob/main/R/revcheck.R; `pkg_depend()` at
#' https://github.com/psychbruce/bruceR/blob/main/R/bruceR_utils.R, and
#' https://github.com/jokergoo/pkgndep for other implementations.
#'
#' [tools::package_dependencies()] requires internet access? Rewrite to use info
#' from local package versions instead? See also `tools:url()`,
#' `datacleanr::can_internet()`, https://r-pkgs.org/testing-advanced.html#mocking,
#' and [BiocManager::valid()] which returns an empty list if internet access is
#' unavailable.
#'
#' Currently, `length_excl` gives the total number of excluded packages. Add
#' `n_excl` with  the number of excluded packages that are reverse dependencies
#' of `pkgs`?
#'
#' Also list the number of system requirements? `SystemRequirements` is a messy
#' column that makes it difficult to convert csv-files to a neat table, see
#' the code of [get_details_pkgs()] and of `count_syst_req()` in
#' `checkrpkgs_knip::count_syst_req.R`.
#'
#' @section Programming notes:
#' [loadedNamespaces()] can be used to see which packages are loaded.
#'
#' For reverse dependencies, see [tools::dependsOnPkgs()].
#'
#' @seealso
#' `tools::standard_package_names()` (present since \R 4.4.0) for a list with
#' the names of the base and recommended packages.
#'
#' The vignette *Instructions about R packages*:
#' `vignette("r_pkgs", package = "checkrpkgs")`.
#'
#' @family
#' functions to get information about packages
#'
#' @examples
#'
#' @export
list_dependencies <- function(pkgs, deps_type = "strong", recursive = TRUE,
                              name_per_pkg = FALSE, number_per_pkg = TRUE,
                              name_total = TRUE, add_pkgs_to_total = FALSE,
                              exclude_high_prio = FALSE, exclude_pkgs = NULL,
                              sort_ndeps_by = c("ndeps", "names")) {
  sort_ndeps_by <- match.arg(sort_ndeps_by, several.ok = FALSE)
  stopifnot(
    checkinput::all_characters(pkgs), checkinput::all_characters(deps_type),
    checkinput::is_logical(recursive), checkinput::is_logical(name_per_pkg),
    checkinput::is_logical(number_per_pkg), checkinput::is_logical(name_total),
    checkinput::is_logical(add_pkgs_to_total),
    checkinput::is_logical(exclude_high_prio),
    is.null(exclude_pkgs) || checkinput::all_characters(exclude_pkgs))

  # Remove the last forward slash and everything before it, because the package
  # name is the part after the last forward slash in GitHub repository names.
  pkgs <- basename(path = pkgs)

  if(sort_ndeps_by == "names") {
    pkgs <- sort(pkgs)
  }

  if(exclude_high_prio) {
    if(utils::packageVersion("base") >= "4.4") {
      high_prio_pkgs <- unlist(tools::standard_package_names(), use.names = FALSE)
    } else {
      message("Collecting names of installed high priority packages because ",
              "the set 'high_prio_pkgs' was not loaded.\nNames of high ",
              "priority packages that are not installed will not be excluded ",
              "from the dependencies.")
      high_prio_pkgs <- unname(installed.packages(priority = "high")[, "Package"])
    }
    exclude_pkgs <- unique(c(high_prio_pkgs, exclude_pkgs))
  } else {
    exclude_pkgs <- unique(exclude_pkgs)
  }

  deps_per_pkgs <- tools::package_dependencies(pkgs, which = deps_type,
                                               recursive = recursive)
  bool_zero_deps <- lengths(deps_per_pkgs) == 0L
  if(any(bool_zero_deps)) {
    warning("Package(s) ",
            paste0(names(deps_per_pkgs[bool_zero_deps]), collapse = ", "),
            " apparently have zero dependencies. However, for non-CRAN",
            " packages this migth mean that these packages were not found in",
            " the package database.")
  }

  pkgs_not_found <- NULL
  for(index_pkgs in seq_along(deps_per_pkgs)) {
    # According to help(tools::package_dependencies()), 'NULL' indicates the
    # package was not found in the database such that no information about
    # dependencies is obtained, whereas 'character(0)' indicates the package
    # does not have any dependencies.
    pkg_deps <- unlist(deps_per_pkgs[index_pkgs], use.names = FALSE)
    if(length(pkg_deps) > 0L) {
      deps_per_pkgs[index_pkgs][[1]] <- sort(pkg_deps[!(pkg_deps %in%
                                                          exclude_pkgs)])
    }
  }

  deps_total <- unlist(deps_per_pkgs, use.names = FALSE)
  if(add_pkgs_to_total) {
    deps_total <- c(deps_total, pkgs)
  }
  deps_total <- unique(deps_total)
  deps_total <- sort(deps_total[!(deps_total %in% exclude_pkgs)])

  out <- NULL
  if(name_per_pkg) {
    out <- c(out, deps_per_pkgs)
  }

  if(number_per_pkg) {
    ndeps_per_pkgs <- lengths(deps_per_pkgs)
    if(sort_ndeps_by == "ndeps") {
      ndeps_per_pkgs <- sort(ndeps_per_pkgs)
    }
    out <- c(out, list(ndeps_per_pkgs = ndeps_per_pkgs))
  }

  if(name_total) {
    out <- c(out, list(deps_total = sort(deps_total)))
  }

  c(out, list(ndeps_total = length(deps_total),
              length_excl = length(exclude_pkgs)))
}
