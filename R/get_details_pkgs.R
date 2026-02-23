#' Get details about installed packages
#'
#' Wrapper around [utils::installed.packages()] to get more information about
#' the origin of packages and select the packages for which to return
#' information.
#'
#' @inheritParams utils::installed.packages
#' @inheritParams check_pkgs
#'
#' @inherit check_pkgs details
#'
#' @returns
#' A matrix containing the details of the installed packages. If `pkgs` has a
#' length larger than zero, only information about the packages in `pkgs` is
#' returned. A zero-row matrix is returned if no packages were found, with a
#' warning.
#'
#' @section Notes:
#' All instances are returned if a package occurs more than once, with a
#' warning reporting their version, library path and origin.
#'
#' @section Programming notes:
#' Could improve speed by using [find.package()] if `pkgs` is not `NULL`? See
#' the `Programming notes` of [check_pkgs()].
#'
#' @family
#' functions to get information about packages
#'
#' @seealso
#' [tools::CRAN_package_db()] for information about packages available from
#' [CRAN](https://cran.r-project.org/web/packages/index.html);
#' [BiocManager::available()] for the names of packages available from
#' [BioConductor](https://bioconductor.org/packages/release/BiocViews.html).
#'
#' The vignette *Instructions about R packages*:
#' `vignette("r_pkgs", package = "checkrpkgs")`.
#'
#' @examples
#' get_details_pkgs(priority = "base")
#' get_details_pkgs(pkgs = c("JesseAlderliesten/checkinput",
#'                           "JesseAlderliesten/checkrpkgs"))
#'
#' @export
get_details_pkgs <- function(pkgs = character(0), lib.loc = NULL, priority = NULL,
                             fields = c("Repository", "Additional_repositories",
                                        "URL", "SystemRequirements")) {
  stopifnot(checkinput::all_characters(x = pkgs, allow_zero = TRUE))

  # Argument 'fields' lists fields that are additional to the default fields.
  # Hardcoded fields 'Repository' and 'URL' because those are used to report on
  # duplicated packages.
  res <- utils::installed.packages(lib.loc = lib.loc, priority = priority,
                                   fields = c(fields, "Repository", "URL"))

  pkg_names <- res[, "Package"]
  bool_dupl <- duplicated(pkg_names)
  if(any(bool_dupl)) {
    ind_bool <- which(bool_dupl)
    LibPaths <- rep(NA_character_, times = length(ind_bool))
    for(ind_msg in seq_along(ind_bool)) {
      pkg <- res[ind_bool[ind_msg], "Package"]
      row_ind_match <- which(res[, "Package"] == pkg)
      LibPaths[ind_msg] <- paste(
        pkg,
        paste0("version ", res[row_ind_match, "Version"],
               " at ", res[row_ind_match, "LibPath"],
               " from ", res[row_ind_match, "Repository"],
               ": ", res[row_ind_match, "URL"],
               collapse = "\n- "),
        sep = ":\n- ")
    }
    warning("Packages found more than once:\n* ",
            progutils::wrap_text(paste0(LibPaths, collapse = "\n* "),
                                 ignore_newlines = FALSE),
            call. = FALSE)
  }

  if(is.null(lib.loc)) {
    lib.loc_string <- progutils::paste_quoted(.libPaths())
  } else {
    lib.loc_string <- progutils::paste_quoted(lib.loc)
  }

  if(length(pkgs) > 0L) {
    bool_absent <- !(basename(path = pkgs) %in% res[, "Package"])
    if(any(bool_absent)) {
      warning(progutils::wrap_text(paste0(
        "Package(s) not found at 'lib.loc' (", lib.loc_string, "): ",
        progutils::paste_quoted(pkgs[bool_absent]))))
    }
    res <- res[res[, "Package"] %in% basename(path = pkgs), , drop = FALSE]
  }

  if(nrow(res) == 0L) {
    warning(progutils::wrap_text(paste0(
      "No packages found at ", lib.loc_string, ": returning a zero-row matrix."
    )))
  }

  res
}
