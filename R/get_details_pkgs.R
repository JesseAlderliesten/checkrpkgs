#' Get details about installed packages
#'
#' @returns
#' A matrix containing the details of the installed packages, returned
#' [invisibly][invisible()].
#'
#' @family
#' functions to get information about packages
#'
#' @seealso
#' [tools::CRAN_package_db()] for information about current and archived packages
#' in the CRAN package repository; [BiocManager::available()] for information
#' about current packages in the Bioconductor and CRAN package repositories.
#'
#' The vignette *Instructions about R packages*:
#' `vignette("r_pkgs", package = "checkrpkgs")`.
#'
#' @section Wishlist:
#' Re-check cleaning `SystemRequirements`: now still yields a separate column.
#'
#' See also `progutils_knip::check_status_DEFUNCT()`.
#'
#' Implement saving data as a csv-file using `progutils::save_file()`.
#'
#' @examples
#'
#' @export
get_details_pkgs <- function() {
  # Argument 'fields' lists fields that are additional to the default fields.
  # To do:
  # - Also get "ReposVer"? Returned by BiocManager::valid()
  installed_pkgs <- utils::installed.packages(
    fields = c("SystemRequirements", "Repository"))[
      , c("Package", "Version", "Built", "NeedsCompilation", "Priority",
          "LibPath", "SystemRequirements", "Repository")]
  rownames(installed_pkgs) <- NULL

  # Perform some cleaning of column 'SystemRequirements' to be able to
  # incorporate it neatly in a csv-file.
  syst_req <- installed_pkgs[, "SystemRequirements"]
  syst_req_cleaned <- gsub(pattern = "\\.[[:space:]]+|,[[:space:]]+|;[[:space:]]+",
                           replacement = "; ", x = syst_req)
  installed_pkgs[, "SystemRequirements"] <- gsub(
    pattern = "[[:space:]]+", replacement = " ", x = syst_req_cleaned)
  installed_pkgs
}
