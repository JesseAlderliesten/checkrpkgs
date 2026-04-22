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
#' A matrix containing the details of the installed packages. The matrix
#' contains columns `"Repository"`, `"URL"`, `"GithubRepo"`, `"GithubUsername"`,
#' and any columns requested through argument `fields` in addition to the
#' default columns returned by [installed.packages()]. `Repository` field that
#' are `NA` or `""` are changed to `Github` if fields `"GithubRepo"` or
#' `"GithubUsername"` are not `NA` or field `URL` contains `github`.
#'
#' If `pkgs` has a length larger than zero, only information about the packages
#' in `pkgs` is returned but the rows are *not* ordered on `pkgs`. A zero-row
#' matrix is returned if no packages were found, with a warning.
#'
#' @section Notes:
#' If a package occurs more than once, all instances are returned, with a
#' warning reporting their version, library path and origin.
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
#'                           "JesseAlderliesten/checkrpkgs"),
#'                  fields = c("SystemRequirements", "AnotherField"))
#' get_details_pkgs(pkgs = c("base", "package_one_is_not_there",
#'                           "package_two_is_not_there"))
#'
#' @export
get_details_pkgs <- function(pkgs = character(0), lib.loc = NULL, priority = NULL,
                             fields = c("Additional_repositories",
                                        "SystemRequirements")) {
  stopifnot(checkinput::all_characters(x = pkgs, allow_zero = TRUE))

  # Argument 'fields' gives fields that are additional to the fields that
  # utils::installed.packages() returns by default. The hardcoded fields are
  # used to determine the repository or to report on duplicated packages.
  res <- utils::installed.packages(lib.loc = lib.loc, priority = priority,
                                   fields = c("Repository", "URL", "GithubRepo",
                                              "GithubUsername", fields))

  bool_repos_GitHub <- (is.na(res[, "Repository"]) | res[, "Repository"] == "") &
    (!is.na(res[, "GithubRepo"]) | !is.na(res[, "GithubUsername"]) |
       grepl(pattern = "github", x = res[, "URL"], fixed = TRUE))
  if(any(bool_repos_GitHub)) {
    res[bool_repos_GitHub, "Repository"] <- "Github"
  }

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
            paste0(LibPaths, collapse = "\n* "),
            call. = FALSE)
  }

  if(is.null(lib.loc)) {
    lib.loc_string <- progutils::paste_quoted(.libPaths())
  } else {
    lib.loc_string <- progutils::paste_quoted(lib.loc)
  }

  if(length(pkgs) > 0L) {
    bool_absent <- !(basename(path = pkgs) %in% res[, "Package"])
    if(any(bool_absent) && !all(bool_absent)) {
      warning("Some packages were not found at 'lib.loc' (", lib.loc_string, "):\n",
              progutils::paste_quoted(pkgs[bool_absent]))
    }
    res <- res[res[, "Package"] %in% basename(path = pkgs), , drop = FALSE]
  }

  if(nrow(res) == 0L) {
    warning("Returning a zero-row matrix because none of the packages were",
            " found at 'lib.loc' (", lib.loc_string,
            "): ", progutils::paste_quoted(pkgs[bool_absent]))
  }

  res
}
