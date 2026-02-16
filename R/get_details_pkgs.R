#' Get details about installed packages
#'
#' Wrapper around [utils::installed.packages()] to get slightly more information
#' about the origin of packages.
#'
#' @inheritParams utils::installed.packages
#'
#' @returns
#' A matrix containing the details of the installed packages.
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
#'
#' @export
get_details_pkgs <- function(lib.loc = NULL, priority = NULL,
                             fields = c("Additional_repositories", "Repository",
                                        "SystemRequirements", "URL")) {
  # Argument 'fields' lists fields that are additional to the default fields.
  utils::installed.packages(lib.loc = lib.loc, priority = priority, fields = fields)
}
