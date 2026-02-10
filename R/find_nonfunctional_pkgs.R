#' Find nonfunctional packages
#'
#' Function to check for non-functional packages.
#'
#' @param pkgs A character vector, or list of character vectors, of package
#' names to be checked. Names of packages from [GitHub](https://github.com/)
#' can be in the format `username/repository` or `repository`.
#' @param lib Character vector giving the [paths][.libPaths()] where the
#' packages of `pkgs` are installed.
#' @param quietly `TRUE` or `FALSE`: suppress printing the reason why packages
#' are not functioning?
#' @param verbose `TRUE` or `FALSE`: print other warnings issued when packages
#' are loaded?
#'
#' @returns
#' A character vector containing the sorted names of non-functional packages in
#' `pkgs`, `character(0)` if all packages in `pkgs` are functional, returned
#' [invisibly][invisible].
#'
#' @section Side effects:
#' Packages are [loaded][loadNamespace()], such that [updating][update.packages()]
#' packages might fail if they are not unloaded first. Restart \R before
#' continuing to prevent this.
#'
#' @section Notes:
#' This function uses [requireNamespace()] instead of [installed.packages()],
#' because `installed.packages()` does not check if packages are functional, nor
#' if all needed [dependencies][list_dependencies()] are installed and
#' functional. In addition, `installed.packages()` can be slow such that its
#' [help page][installed.packages()] states that [requireNamespace()] or
#' [require()] should be used instead.
#'
#' @section To do:
#' Replace calls to [sapply()] with calls to [vapply()].
#'
#' `pkgs <- sub(pattern = ".*/", replacement = "", x = pkgs)` can be replaced by
#' `pkgs <- basename(pkgs)`?
#'
#' When testing if packages are functioning correctly, differentiate between
#' missing and non-functioning packages: if package `<pkgname>` does not exist,
#' the error `There is no package called '<pkgname>'` is thrown if `quietly` is
#' `FALSE` (but *not* if `quietly` is `TRUE`).
#'
#' @family
#' get information about packages
#'
#' @examples
#' find_nonfunctional_pkgs(pkgs = c("base", "tools"), lib = .libPaths(),
#'                         quietly = FALSE, verbose = FALSE)
#' find_nonfunctional_pkgs("abcdef", quietly = FALSE)
#' find_nonfunctional_pkgs("abcdef", quietly = TRUE)
#'
#' @export
find_nonfunctional_pkgs <- function(pkgs, lib = .libPaths(), quietly = FALSE,
                                    verbose = FALSE) {
  if(is.list(pkgs)) {
    pkgs <- unlist(pkgs, use.names = FALSE)
  }

  stopifnot(checkinput::all_characters(pkgs), checkinput::all_characters(lib),
            checkinput::is_logical(quietly), checkinput::is_logical(verbose))

  pkgs <- unique(pkgs)
  pkgs_input <- pkgs

  # Remove the last forward slash and everything before it, because the package
  # name is the part after the last forward slash in GitHub repository names.
  pkgs <- sub(pattern = ".*/", replacement = "", x = pkgs)

  if(!verbose) {
    index_nonfunctional <- suppressWarnings(suppressPackageStartupMessages(
      which(!sapply(X = pkgs, FUN = requireNamespace, lib.loc = lib,
                    quietly = quietly, simplify = TRUE))
    ))
  } else {
    index_nonfunctional <- suppressPackageStartupMessages(
      which(!sapply(X = pkgs, FUN = requireNamespace, lib.loc = lib,
                    quietly = quietly, simplify = TRUE))
    )
  }

  nonfunctional_pkgs <- sort(pkgs_input[index_nonfunctional])

  warn_restart <- paste0("Restart R before continuing to prevent problems",
                         " arising from updating loaded packages!")

  if(length(nonfunctional_pkgs) == 0L) {
    warning(progutils::wrap_text(paste0(
      "All packages are functional. ", warn_restart)))
  } else {
    warning(progutils::wrap_text(paste0(
      warn_restart, " Names of non-functional packages: ",
      progutils::paste_quoted(nonfunctional_pkgs), ".")))
  }

  invisible(nonfunctional_pkgs)
}
