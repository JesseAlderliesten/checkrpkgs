#' Get details about installed packages
#'
#' Wrapper around [utils::installed.packages()] to get more information about
#' the origin of installed packages and select the packages for which to return
#' information.
#'
#' @inheritParams utils::installed.packages
#' @inheritParams check_pkgs
#' @param db `NULL` (default) or a matrix with the results of a call to
#' [utils::installed.packages()] containing column `Package` (or rownames that
#' are package names). To prevent a call to [utils::installed.packages()], the
#' matrix should contain the columns listed in section `Details` below and any
#' requested columns.
#'
#' @details
#' The returned matrix will contain columns `"Package"`, `"Version"`,
#' `"MD5sum"`, `"Built"`, `"Priority"`, `"LibPath"`, `"Repository"`,
#' `"Additional_repositories"`, `"URL"`, `"GithubRepo"`, `"GithubUsername"`,
#' `"SystemRequirements"`, `"NeedsCompilation"`, `"OS_type"`, `"Depends"`,
#' `"Imports"`, `"LinkingTo"`, `"Suggests"` and any columns requested through
#' argument `fields`.
#'
#' @returns
#' A matrix containing details of the installed packages, see `Details`.
#'
#' `Repository` fields in the returned matrix that are `NA` or `""` are changed
#' to `Github` if fields `"GithubRepo"` or `"GithubUsername"` are not `NA` or
#' field `URL` matches `"github"`.
#'
#' If `pkgs` has a length larger than zero, only information about the packages
#' in `pkgs` is returned (but the rows are *not* ordered on `pkgs`), with a
#' warning if a package is not found.
#'
#' If a package occurs more than once in the searched \R library trees, all
#' instances are returned, with a warning reporting their version, library path
#' and origin. Information about a package is not duplicated in the returned
#' matrix if multiple entries in `pkgs` refer to the same package.
#'
#' If no packages were found, a zero-row matrix is returned, with a warning.
#'
#' @inheritSection check_pkgs Package names
#'
#' @family
#' functions to get information about packages
#'
#' @seealso
#' [utils::installed.packages()] that is used by `get_details_pkgs()`.
#'
#' [tools::CRAN_package_db()] for information about packages available from
#' [CRAN](https://cran.r-project.org/web/packages/index.html), including the
#' `Description` and `Maintainer` fields not returned by
#' [utils::available.packages()]. [tools::CRAN_check_results()],
#' [tools::CRAN_check_details()] and [tools::CRAN_check_issues()] on the current
#' check status of CRAN packages.
#'
#' [utils::available.packages]`(fields = NULL, repos = BiocManager::repositories())`
#' for information about packages available from
#' [BioConductor](https://bioconductor.org/packages/release/BiocViews.html), and
#' `BiocManager::available()` for their names.
#'
#' [check_pkgs], with information on obtaining dependencies in its help-page.
#'
#' The vignette *Instructions about R packages*:
#' `vignette("r_pkgs", package = "checkrpkgs")`.
#'
#' @examples
#' get_details_pkgs(priority = "base")
#'
#' # Returns all default fields and requested fields, warns about packages that
#' # are not found
#' get_details_pkgs(pkgs = c("JesseAlderliesten/checkinput", "missing_package",
#'                           "JesseAlderliesten/checkrpkgs"),
#'                  fields = "SomeField")
#'
#' @export
get_details_pkgs <- function(pkgs = character(0), fields = NULL, priority = NULL,
                             lib.loc = NULL, db = NULL) {
  stopifnot(checkinput::all_characters(x = pkgs, allow_zero = TRUE),
            is.null(fields) || checkinput::all_characters(x = fields),
            is.null(priority) ||
              checkinput::all_characters(x = priority, allow_NA = TRUE),
            is.null(lib.loc) || checkinput::all_characters(x = lib.loc))

  if(!is.null(priority)) {
    priority_string <- progutils::paste_quoted(priority)
    message("Selecting packages with priority ", priority_string)
    bool_high_prio <- priority %in% "high"
    if(any(bool_high_prio)) {
      priority <- c(priority[!bool_high_prio], "recommended", "base")
    }
  }

  if(is.null(lib.loc)) {
    lib.loc_string <- progutils::paste_quoted(.libPaths())
  } else {
    lib.loc_string <- progutils::paste_quoted(lib.loc)
  }

  if(is.null(db)) {
    location_string <- paste0("at 'lib.loc'\n(", lib.loc_string, ")")
  } else {
    if(!is.matrix(db) || (!("Package" %in% colnames(db)) && is.null(rownames(db)))) {
      stop("'db' should be 'NULL' or a matrix with the results of a call to",
           "\n'utils::installed.packages()' containing column 'Package' (or",
           " rownames that are\npackage names): ", deparse(substitute(db)))
    }
    bool_dupl_cols <- duplicated(colnames(db))
    if(any(bool_dupl_cols)) {
      stop("Column names of 'db' should be unique: ",
           progutils::paste_quoted(colnames(db)[bool_dupl_cols]))
    }
    location_string <- paste0("in 'db' (", deparse(substitute(db)), ")")
  }

  # Notes:
  # - Fields "Package", "Version", "Priority", "LibPath", "Repository", "URL",
  #   "GithubRepo", and "GithubUsername" are used by this function, for example
  #   to determine the repository or to report on duplicated packages.
  # - See colnames(tools::CRAN_package_db()) for a list of possible fields.
  required_fields <- c("Package", "Version", "MD5sum", "Built", "Priority",
                       "LibPath", "Repository", "Additional_repositories", "URL",
                       "GithubRepo", "GithubUsername", "SystemRequirements",
                       "NeedsCompilation", "OS_type", "Depends", "Imports",
                       "LinkingTo", "Suggests")
  fields <- unique(c(required_fields, fields))

  # Argument 'fields' gives fields that are additional to the fields that
  # utils::installed.packages() returns by default.
  if(is.null(db)) {
    db <- utils::installed.packages(lib.loc = lib.loc, priority = priority,
                                    fields = fields)
  } else {
    if(!("Package" %in% colnames(db))) {
      message("Using rownames of 'db' as package names.")
      db <- cbind("Package" = rownames(db), db)
    }

    if(!is.null(priority)) {
      db <- db[db[, "Priority"] %in% priority, , drop = FALSE]
    }

    bool_fields_missing <- !(fields %in% colnames(db))
    if(any(bool_fields_missing)) {
      warning("Trying to retrieve required field(s) missing from matrix 'db'",
              " through\n'utils::installed.packages(...)': ",
              progutils::paste_quoted(fields[bool_fields_missing]))
      db_upd <- utils::installed.packages(lib.loc = lib.loc, priority = priority,
                                          fields = fields[bool_fields_missing])
      bool_pkgs_missing <- !(db[, "Package"] %in% db_upd[, "Package"])
      if(any(bool_pkgs_missing)) {
        warning("Could not retrieve package(s) ",
                progutils::paste_quoted(db[bool_pkgs_missing, "Package"]),
                ": fields ", progutils::paste_quoted(fields[bool_fields_missing]),
                " for those packages will be set to 'NA'!")

        data_missing_pkgs <- matrix(data = NA,
                                    nrow = length(which(bool_pkgs_missing)),
                                    ncol = ncol(db_upd),
                                    dimnames = list(NULL, colnames(db_upd)))
        data_missing_pkgs[, "Package"] <- db[bool_pkgs_missing, "Package"]
        db_upd <- rbind(db_upd, data_missing_pkgs)
      }

      # Match order of packages in 'db_upd' to the order of packages in 'db'
      db_upd <- db_upd[match(db[, "Package"], db_upd[, "Package"]), , drop = FALSE]

      # Add missing fields
      db <- cbind(db, db_upd[, fields[bool_fields_missing], drop = FALSE])
    }
  }

  db <- db[, fields, drop = FALSE]
  pkg_names <- db[, "Package"]

  if(length(pkgs) > 0L) {
    # Remove the last forward or backward slash and everything before it, because
    # the package name is the part after the last slash in GitHub repository names.
    bool_absent <- !(basename(path = pkgs) %in% pkg_names)
    if(any(bool_absent) && !all(bool_absent)) {
      warning("Some packages were not found ", location_string, ":\n",
              progutils::paste_quoted(pkgs[bool_absent]))
    }
    db <- db[pkg_names %in% basename(path = pkgs), , drop = FALSE]
    pkg_names <- db[, "Package"]
  }

  if(nrow(db) == 0L) {
    warning("Returning a zero-row matrix because none of the packages were found ",
            location_string,
            if(!is.null(priority)) {
              paste0(" with priority ", priority_string)
              },
            ":\n", progutils::paste_quoted(pkgs))
  }

  bool_no_repos_info <- is.na(db[, "Repository"]) | db[, "Repository"] == ""
  if(any(bool_no_repos_info)) {
    bool_suggests_GitHub <- !is.na(db[, "GithubRepo"]) |
      !is.na(db[, "GithubUsername"]) |
      grepl(pattern = "github", x = db[, "URL"], fixed = TRUE)
    bool_add_github_info <- bool_no_repos_info & bool_suggests_GitHub
    if(any(bool_add_github_info)) {
      db[bool_add_github_info, "Repository"] <- "Github"
    }
  }

  bool_dupl <- duplicated(pkg_names)
  if(any(bool_dupl)) {
    ind_dupl <- which(bool_dupl)
    LibPaths <- rep(NA_character_, times = length(ind_dupl))
    for(ind_msg in seq_along(ind_dupl)) {
      pkg <- db[ind_dupl[ind_msg], "Package"]
      row_ind_match <- which(pkg_names == pkg)
      LibPaths[ind_msg] <- paste(
        pkg,
        paste0("version ", db[row_ind_match, "Version"],
               " at ", db[row_ind_match, "LibPath"],
               " from ", db[row_ind_match, "Repository"],
               ": ", db[row_ind_match, "URL"],
               collapse = "\n- "),
        sep = ":\n- ")
    }
    warning("Packages found more than once:\n* ",
            paste0(LibPaths, collapse = "\n* "),
            call. = FALSE)
  }

  db
}
