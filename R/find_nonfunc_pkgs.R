#' Find non-functional packages
#'
#' Function to check for non-installed or non-functional packages.
#'
#' @param pkgs A character vector with names of packages to be checked, or
#' ending in such names, see `Details`.
#' @param quietly `TRUE` or `FALSE`: suppress warnings when loading
#' installed non-functional packages?
#'
#' @details
#' The part after the last forward or backward slash is considered to be the
#' package name if input to `pkgs` contains such slashes. Therefore the package
#' name, the file path to packages, and the full URL to packages from
#' [GitHub](https://github.com/) can all be used as input to `pkgs`.
#'
#' Packages are looked for in the library paths given by [.libPaths()].
#'
#' @returns
#' A list of length two, with elements 'absent' and 'nonfunc' containing
#' character vectors with the names of packages in `pkgs` that are not installed
#' or are installed but non-functional, with a warning. The elements are
#' `character(0)` if all packages in `pkgs` are present, and if all packages
#' are installed and functional, respectively.
#'
#' @section Side effects:
#' Packages are [loaded][loadNamespace()], such that [updating][update.packages()]
#' them might fail. Restart \R to prevent such problems.
#'
#' @section Programming notes:
#' This function uses [find.package()] and [requireNamespace()] instead of
#' [installed.packages()] because `installed.packages` does not check if
#' packages are functional, nor if all needed
#' [dependencies][tools::package_dependencies()] are installed and functional.
#' In addition, `installed.packages()` can be slow such that its
#' [help page][installed.packages()] states that [requireNamespace()] or
#' [require()] should be used instead.
#'
#' Setting environment variable `_R_TRACE_LOADNAMESPACE_` to a numerical value
#' (e.g., `Sys.setenv("_R_TRACE_LOADNAMESPACE_" = 4)`) will generate additional
#' messages on progress for non-standard packages, see the section `Tracing` in
#' [requireNamespace()].
#'
#' @seealso
#' [package_dependencies][tools::package_dependencies()]`(packages = "<pkgname>", recursive = TRUE)`
#' for dependencies and
#' [dependsOnPkgs][tools::dependsOnPkgs()]`(pkgs = "<pkgname>", recursive = TRUE)`
#' for reverse dependencies; `tools::standard_package_names()` (present since
#' \R 4.4.0) for names of the base and recommended packages.
#'
#' [old.packages()] and [BiocManager::valid()] to check for outdated or too new
#' packages, where the latter takes the currently used version of Bioconductor
#' into account.
#'
#' `options("defaultPackages")` for names of packages that are attached by
#' default when \R starts up; [loadedNamespaces()] and [utils::sessionInfo()]
#' for names of packages that are currently loaded.
#'
#' The vignette *Instructions about R packages*:
#' `vignette("r_pkgs", package = "checkrpkgs")`.
#'
#' @family
#' functions to get information about packages
#'
#' @examples
#' find_nonfunc_pkgs(pkgs = c("base", "grid"), quietly = FALSE)
#'
#' non_existent_pkgs <- c("yz/wx/abcdef4", "wx/abcdef3", "abcdef2", "abcdef1")
#' find_nonfunc_pkgs(non_existent_pkgs, quietly = FALSE)
#' find_nonfunc_pkgs(non_existent_pkgs, quietly = TRUE)
#' find_nonfunc_pkgs(pkgs = c(non_existent_pkgs, "utils"), quietly = FALSE)
#'
#' @export
find_nonfunc_pkgs <- function(pkgs, quietly = FALSE) {
  stopifnot(checkinput::all_characters(pkgs), checkinput::is_logical(quietly))

  pkgs_input <- pkgs

  # Remove the last forward slash and everything before it, because the package
  # name is the part after the last forward slash in GitHub repository names.
  pkgs <- basename(path = pkgs)

  # lib.loc = NULL looks at all libraries known to .libPaths()
  bool_absent <- vapply(X = pkgs, FUN = function(x) {
    # Using 'quiet = TRUE' to not get an error if the package is not found
    length(find.package(x, lib.loc = NULL, quiet = TRUE)) == 0L},
    FUN.VALUE = logical(1), USE.NAMES = FALSE)
  names_absent <- pkgs_input[bool_absent]

  if(all(bool_absent)) {
    # No need to look for non-functional packages if all are absent
    bool_nonfunc <- !bool_absent # Special case where all are absent: all FALSE
    names_nonfunc <- character(0)
  } else {
    if(quietly) {
      bool_nonfunc <- suppressWarnings(suppressPackageStartupMessages(
        !vapply(X = pkgs[!bool_absent], FUN = requireNamespace,
                FUN.VALUE = logical(1), lib.loc = NULL, quietly = quietly)
      ))
    } else {
      bool_nonfunc <- suppressPackageStartupMessages(
        !vapply(X = pkgs[!bool_absent], FUN = requireNamespace,
                FUN.VALUE = logical(1), lib.loc = NULL, quietly = quietly)
      )
    }
    names_nonfunc <- (pkgs[!bool_absent])[bool_nonfunc]
  }

  if(any(bool_absent) || any(bool_nonfunc)) {
    warn_text <- character(0)
    if(any(bool_absent)) {
      warn_text <- c(warn_text,
                     paste0("non-installed packages: ",
                            progutils::paste_quoted(names_absent)))
    }
    if(any(bool_nonfunc)) {
      warn_text <- c(warn_text,
                     paste0("installed non-functional packages: ",
                            progutils::paste_quoted(names_nonfunc)))
    }
    warning(progutils::wrap_text(paste0(warn_text, collapse = "; ")))
  }

  message("Restart R to prevent problems arising from updating loaded packages!")
  list(absent = names_absent, nonfunc = names_nonfunc)
}
