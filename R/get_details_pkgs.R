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

  if(is.null(lib.loc)) {
    lib.loc_string <- progutils::paste_quoted(.libPaths())
  } else {
    lib.loc_string <- progutils::paste_quoted(lib.loc)
  }

  # Argument 'fields' gives fields that are additional to the fields that
  # utils::installed.packages() returns by default. The hardcoded fields are
  # used to determine the repository or to report on duplicated packages.
  res <- utils::installed.packages(lib.loc = lib.loc, priority = priority,
                                   fields = c("Repository", "URL", "GithubRepo",
                                              "GithubUsername", fields))
  pkg_names <- res[, "Package"]

  if(length(pkgs) > 0L) {
    bool_absent <- !(basename(path = pkgs) %in% pkg_names)
    if(any(bool_absent) && !all(bool_absent)) {
      warning("Some packages were not found at 'lib.loc' (", lib.loc_string, "):\n",
              progutils::paste_quoted(pkgs[bool_absent]))
    }
    res <- res[pkg_names %in% basename(path = pkgs), , drop = FALSE]
    pkg_names <- res[, "Package"]
  }

  if(nrow(res) == 0L) {
    warning("Returning a zero-row matrix because none of the packages were",
            " found at 'lib.loc' (", lib.loc_string,
            "): ", progutils::paste_quoted(pkgs[bool_absent]))
  }

  bool_no_repos_info <- is.na(res[, "Repository"]) | res[, "Repository"] == ""
  if(any(bool_no_repos_info)) {
    bool_suggests_GitHub <- !is.na(res[, "GithubRepo"]) |
      !is.na(res[, "GithubUsername"]) |
      grepl(pattern = "github", x = res[, "URL"], fixed = TRUE)
    bool_add_github_info <- bool_no_repos_info & bool_suggests_GitHub
    if(any(bool_add_github_info)) {
      res[bool_add_github_info, "Repository"] <- "Github"
    }
  }

  bool_dupl <- duplicated(pkg_names)
  if(any(bool_dupl)) {
    ind_dupl <- which(bool_dupl)
    LibPaths <- rep(NA_character_, times = length(ind_dupl))
    for(ind_msg in seq_along(ind_dupl)) {
      pkg <- res[ind_dupl[ind_msg], "Package"]
      row_ind_match <- which(pkg_names == pkg)
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

  res
}
