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
#' [tools::CRAN_package_db()] for information about current and archived packages
#' in the CRAN package repository; `BiocManager::available()` for information
#' about current packages in the Bioconductor and CRAN package repositories.
#'
#' The vignette *Instructions about R packages*:
#' `vignette("r_pkgs", package = "checkrpkgs")`.
#'
#' @section Programming notes:
#' `SystemRequirements` is a messy column that makes it difficult to convert the
#' data to a neat csv-file, see the code of `count_syst_req()` in
#' `checkrpkgs_knip::count_syst_req.R` for a stub to address that.
#'
#' @examples
#'
#' @export
get_details_pkgs <- function(lib.loc = NULL, priority = NULL,
                             fields = c("Additional_repositories", "Repository",
                                        "SystemRequirements", "URL")) {
  # Argument 'fields' lists fields that are additional to the default fields.
  utils::installed.packages(lib.loc = lib.loc, priority = priority, fields = fields)
}
