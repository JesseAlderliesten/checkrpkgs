#' Find non-functional packages
#'
#' Function to check for non-installed or non-functional packages.
#'
#' @param pkgs A character vector with names of packages to be checked or file
#' paths to their directories, see `Details`.
#' @param quietly `TRUE` or `FALSE`: suppress printing warnings when loading
#' installed non-functional packages?
#'
#' @details
#' The part after the last forward or backward slash is considered to be the
#' package name if names contain such slashes. Therefore the file path to
#' packages can be used as input to `pkgs`, and packages from
#' [GitHub](https://github.com/) can be in the format `username/repository` or
#' `repository`, where `repository` is the package name.
#'
#' Packages are looked for in the library paths given by [.libPaths()].
#'
#' @returns
#' `character(0)` if all packages in `pkgs` are installed and functional, or a
#' character vector containing the names of packages in `pkgs` that are not
#' installed or are installed but non-functional (with a warning), returned
#' [invisibly][invisible].
#'
#' @section Side effects:
#' Packages are [loaded][loadNamespace()], such that [updating][update.packages()]
#' packages might fail if they are not unloaded first. A message is emitted
#' urging to restart \R to prevent this.
#'
#' @section Notes:
#' This function uses [find.package()] and [requireNamespace()] instead of
#' [installed.packages()], because `installed.packages()` does not check if
#' packages are functional, nor if all needed [dependencies][list_dependencies()]
#' are installed and functional. In addition, `installed.packages()` can be slow
#' such that its [help page][installed.packages()] states that
#' [requireNamespace()] or [require()] should be used instead.
#'
#' @section Programming notes:
#' Setting environment variable `_R_TRACE_LOADNAMESPACE_` to a numerical value
#' (e.g., `Sys.setenv("_R_TRACE_LOADNAMESPACE_" = 4)`) will generate additional
#' messages on progress for non-standard packages, see section `Tracing` in
#' [requireNamespace()].
#'
#' [requireNamespace()] does not have an effect for a package that is already
#' loaded.
#'
#' @section To do:
#' Use shorter function name?
#'
#' Run R CMD check
#'
#' @seealso
#' `options("defaultPackages")` for a list with the names of packages are
#' attached by default when \R starts up; `tools::standard_package_names()`
#' (present since \R 4.4.0) for a list with the names of the base and
#' recommended packages.
#'
#' The vignette *Instructions about R packages*:
#' `vignette("r_pkgs", package = "checkrpkgs")`.
#'
#' @family
#' functions to get information about packages
#'
#' @examples
#' find_nonfunc_pkgs(pkgs = c("base", "grid"), quietly = FALSE)
#' find_nonfunc_pkgs(pkgs = list("methods", "stats4"), quietly = TRUE)
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
    bool_nonfunc <- !bool_absent # Special case where all are absent: all FALSE
    names_problem <- names_absent
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
    names_problem <- pkgs_input[bool_absent | bool_nonfunc]
  }

  names_nonfunc <- (pkgs_input[!bool_absent])[bool_nonfunc]
  if(length(names_problem) > 0L) {
    warn_text <- character(0)
    if(length(names_absent) > 0L) {
      warn_text <- c(warn_text, paste0("non-installed packages: ",
                                       progutils::paste_quoted(names_absent)))
    }
    if(length(names_nonfunc) > 0L) {
      warn_text <- c(warn_text, paste0("installed non-functional packages: ",
                                       progutils::paste_quoted(names_nonfunc)))
    }
    warning(progutils::wrap_text(paste0(warn_text, collapse = "; ")))
  }

  message("Restart R to prevent problems arising from updating loaded packages!")
  invisible(names_problem)
}
