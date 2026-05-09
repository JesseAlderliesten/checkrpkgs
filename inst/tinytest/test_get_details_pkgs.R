#### Create objects to use in tests ####
fields_add <- c("Title", "SomeField")
fields_discard <- c("Priority", "Depends")
fields_req <- c("Package", "Version", "MD5sum", "Built", "Priority",
                "LibPath", "Repository", "Additional_repositories", "URL",
                "GithubRepo", "GithubUsername", "SystemRequirements",
                "NeedsCompilation", "OS_type", "Depends", "Imports",
                "LinkingTo", "Suggests")
obj_zero_row <- matrix(data = "", ncol = length(fields_req),
                       dimnames = list(NULL, fields_req))[0, ]

# not working in r cmd check if examples of create_fake_pkg() are kept
dir_test_pkg <- progutils::create_tempdir(subdir = "pkg_tests")
pkgA <- matrix(data = NA, ncol = length(fields_req),
               dimnames = list(NULL, fields_req))
pkgA[, c("Package", "Version", "LibPath")] <- c("pkgA", "1.0", dir_test_pkg)
rownames(pkgA) <- "pkgA"

pkgs_absent <- c("missing_package", "missing_package_also")
pkgs_div <- c("utils", "Matrix", "tinytest", "JesseAlderliesten/checkrpkgs",
              "checkinput")
pkgs_present <- c("utils", "Matrix", "tinytest")
warn_zero <- "Returning a zero-row matrix because none of the packages were found"

# Set up a small package for testing
create_fake_pkg(name = "pkgA", path = dir_test_pkg)

# Correct, full database of packages to use
db_OK <- utils::installed.packages(
  fields = c(fields_req, fields_add))[, fields_req]

# Selection used later on
NULL_fields_req <- checkrpkgs::get_details_pkgs(
  fields = fields_req[3:1], db = NULL)
OK_fields_req <- checkrpkgs::get_details_pkgs(
  fields = fields_req[3:1], db = db_OK)


#### Argument 'pkgs' ####
NULL_pkgs_select <- get_details_pkgs(pkgs = pkgs_present, db = NULL)
OK_pkgs_select <- get_details_pkgs(pkgs = pkgs_present, db = db_OK)
expect_identical(NULL_pkgs_select, OK_pkgs_select)
expect_true(all(rownames(NULL_pkgs_select) %in% basename(pkgs_present)))
expect_true(all(basename(pkgs_present) %in% rownames(NULL_pkgs_select)))
expect_identical(nrow(get_details_pkgs(pkgs = "checkinput", db = NULL)), 1L)

##### Some packages not found #####
expect_warning(
  NULL_pkgs_absent_part <- get_details_pkgs(
    pkgs = c("base", pkgs_absent), db = NULL),
  pattern = paste0("Some packages were not found at 'lib.loc'.+",
                   progutils::paste_quoted(pkgs_absent)),
  strict = TRUE, fixed = FALSE)
expect_true(all(rownames(NULL_pkgs_absent_part) == "base"))
expect_true(all(fields_req %in% colnames(NULL_pkgs_absent_part)))

expect_warning(
  OK_pkgs_absent_part <- get_details_pkgs(
    pkgs = c("base", pkgs_absent), db = db_OK),
  pattern = paste0("Some packages were not found in 'db'.+",
                   progutils::paste_quoted(pkgs_absent)),
  strict = TRUE, fixed = FALSE)
expect_identical(NULL_pkgs_absent_part, OK_pkgs_absent_part)

##### None of the packages found #####
expect_warning(
  NULL_pkgs_absent <- get_details_pkgs(pkgs = pkgs_absent, db = NULL),
  pattern = paste0(warn_zero, " at 'lib.loc'.+",
                   progutils::paste_quoted(pkgs_absent)),
  strict = TRUE, fixed = FALSE)
expect_identical(NULL_pkgs_absent, obj_zero_row)

expect_warning(
  OK_pkgs_absent <- get_details_pkgs(pkgs = pkgs_absent, db = db_OK),
  pattern = paste0(warn_zero, " in 'db' (db_OK):\n",
                   progutils::paste_quoted(pkgs_absent)),
  strict = TRUE, fixed = TRUE)
expect_identical(OK_pkgs_absent, obj_zero_row)

expect_silent(
  expect_identical(
    # Ignore the 'Built' field that contains a timestamp
    get_details_pkgs(lib.loc = dir_test_pkg)[, colnames(pkgA) != "Built",
                                             drop = FALSE],
    pkgA[, colnames(pkgA) != "Built", drop = FALSE])
)

# Look in a directory for a package that is not present
expect_warning(
  expect_identical(
    get_details_pkgs(pkgs = "pkgB", lib.loc = dir_test_pkg),
    obj_zero_row),
  pattern = "Returning a zero-row matrix", fixed = TRUE, strict = TRUE)

# Look in a directory where no package is present
expect_warning(
  expect_identical(
    get_details_pkgs(lib.loc = dirname(dir_test_pkg)),
    obj_zero_row),
  pattern = "Returning a zero-row matrix", fixed = TRUE, strict = TRUE)

#### Argument 'fields' ####
##### Return required fields #####
expect_true(all(fields_req %in% colnames(NULL_fields_req)))

##### Return additional fields #####
NULL_fields_add <- checkrpkgs::get_details_pkgs(fields = fields_add, db = NULL)
expect_warning(
  OK_fields_add <- checkrpkgs::get_details_pkgs(fields = fields_add, db = db_OK),
  pattern = "Trying to retrieve required field(s) missing from matrix 'db'",
  strict = TRUE, fixed  = TRUE)
expect_identical(NULL_fields_add, OK_fields_add)
expect_true(all(c(fields_req, fields_add) %in% colnames(NULL_fields_add)))
expect_true(all(is.na(NULL_fields_add[, "SomeField", drop = FALSE])))

##### Do not duplicate fields #####
NULL_fields_dupl <- get_details_pkgs(
  pkgs = pkgs_present, fields = rep(c("LibPath", fields_add), 2L), db = NULL)
expect_warning(
  OK_fields_dupl <- get_details_pkgs(
    pkgs = pkgs_present, fields = rep(c("LibPath", fields_add), 2L), db = db_OK))
OK_fields_dupl_v2 <- get_details_pkgs(
  pkgs = pkgs_present, fields = rep("LibPath", 2L), db = db_OK)

expect_identical(NULL_fields_dupl, OK_fields_dupl)
expect_identical(anyDuplicated(colnames(NULL_fields_dupl)), 0L)
expect_true(all(c(fields_req, "LibPath", fields_add) %in%
                  colnames(NULL_fields_dupl)))
expect_identical(anyDuplicated(colnames(OK_fields_dupl_v2)), 0L)
expect_true(all(c(fields_req, "LibPath") %in% colnames(OK_fields_dupl_v2)))

##### Do not return non-requested non-default fields #####
expect_identical(get_details_pkgs(db = NULL_fields_add), OK_fields_req)
expect_identical(
  get_details_pkgs(fields = fields_add[2], db = NULL_fields_add),
  NULL_fields_add[, colnames(NULL_fields_add) != "Title"])

##### Adjust field 'Repository' #####
NULL_pkgs_div <- get_details_pkgs(pkgs = pkgs_div, db = NULL)
OK_pkgs_div <- get_details_pkgs(pkgs = pkgs_div, db = db_OK)
expect_identical(NULL_pkgs_div, OK_pkgs_div)
expect_true(all(c("CRAN", "Github", NA_character_) %in%
                  NULL_pkgs_div[basename(pkgs_div), "Repository"]))


#### Argument 'priority' ####
##### Priority 'base' #####
expect_message(
  NULL_pkgs_base <- get_details_pkgs(priority = "base", db = NULL),
  pattern = "Selecting packages with priority 'base'",
  strict = TRUE, fixed = TRUE)
expect_message(
  OK_pkgs_base <- get_details_pkgs(priority = "base", db = db_OK),
  pattern = "Selecting packages with priority 'base'",
  strict = TRUE, fixed = TRUE)
expect_identical(NULL_pkgs_base, OK_pkgs_base)
expect_true(nrow(NULL_pkgs_base) > 0L)
expect_true(all(fields_req %in% colnames(NULL_pkgs_base)))
expect_true(all(NULL_pkgs_base[, "Priority"] == "base"))

##### Priority 'recommended' #####
expect_message(
  NULL_pkgs_rec <- get_details_pkgs(priority = "recommended", db = NULL),
  pattern = "Selecting packages with priority 'recommended'",
  strict = TRUE, fixed = TRUE)
expect_message(
  OK_pkgs_rec <- get_details_pkgs(priority = "recommended", db = db_OK),
  pattern = "Selecting packages with priority 'recommended'",
  strict = TRUE, fixed = TRUE)
expect_identical(NULL_pkgs_rec, OK_pkgs_rec)
expect_true(nrow(NULL_pkgs_rec) > 0L)
expect_true(all(fields_req %in% colnames(NULL_pkgs_rec)))
expect_true(all(NULL_pkgs_rec[, "Priority"] == "recommended"))

##### Priority 'high' #####
expect_message(
  NULL_pkgs_high <- get_details_pkgs(priority = "high", db = NULL),
  pattern = "Selecting packages with priority 'high'",
  strict = TRUE, fixed = TRUE)
expect_message(
  OK_pkgs_high <- get_details_pkgs(priority = "high", db = db_OK),
  pattern = "Selecting packages with priority 'high'",
  strict = TRUE, fixed = TRUE)
expect_identical(NULL_pkgs_high, OK_pkgs_high)
expect_true(nrow(NULL_pkgs_high) > 0L)
expect_true(all(fields_req %in% colnames(NULL_pkgs_high)))
expect_true(all(NULL_pkgs_high[, "Priority"] %in% c("base", "recommended")))
expect_identical(nrow(NULL_pkgs_base) + nrow(OK_pkgs_rec), nrow(OK_pkgs_high))

##### Priority mixed #####
expect_message(
  NULL_pkgs_rec_base <- get_details_pkgs(
    priority = c("recommended", "base"), db = NULL),
  pattern = "Selecting packages with priority 'recommended', 'base'",
  strict = TRUE, fixed = TRUE)
expect_message(
  OK_pkgs_rec_base <- get_details_pkgs(
    priority = c("recommended", "base"), db = db_OK),
  pattern = "Selecting packages with priority 'recommended', 'base'",
  strict = TRUE, fixed = TRUE)
expect_identical(NULL_pkgs_rec_base, OK_pkgs_rec_base)
expect_identical(NULL_pkgs_rec_base, NULL_pkgs_high)

##### Priority 'NA_character_' #####
expect_message(
  NULL_pkgs_NA <- get_details_pkgs(priority = NA_character_, db = NULL),
  pattern = "Selecting packages with priority 'NA_character_'",
  strict = TRUE, fixed = TRUE)
expect_message(
  OK_pkgs_NA <- get_details_pkgs(priority = NA_character_, db = db_OK),
  pattern = "Selecting packages with priority 'NA_character_'",
  strict = TRUE, fixed = TRUE)
expect_identical(NULL_pkgs_NA, OK_pkgs_NA)
expect_true(all(is.na(OK_pkgs_NA[, "Priority"])))

##### Priority mismatch #####
expect_warning(
  expect_identical(
    get_details_pkgs(
      pkgs = "checkinput", priority = "high", db = NULL),
    obj_zero_row),
  pattern = warn_zero, strict = TRUE, fixed = TRUE)

expect_warning(
  expect_identical(
    get_details_pkgs(
      pkgs = "checkinput", priority = "high", db = db_OK),
    obj_zero_row),
  pattern = warn_zero, strict = TRUE, fixed = TRUE)


#### Argument 'db' ####
expect_identical(NULL_fields_req, OK_fields_req)

##### rownames as package names #####
expect_message(
  expect_identical(
    get_details_pkgs(db = db_OK[, colnames(db_OK) != "Package"]),
    NULL_fields_req),
  pattern = "Using rownames of 'db' as package names",
  strict = TRUE, fixed = TRUE)

##### Missing 'priority' from 'db' #####
expect_warning(
  expect_identical(
    get_details_pkgs(db = db_OK[, !(colnames(db_OK) %in% fields_discard)]),
    NULL_fields_req
  ),
  pattern = paste0(
    "Trying to retrieve required field.s. missing from matrix 'db'.+",
    progutils::paste_quoted(fields_discard)),
  strict = TRUE, fixed = FALSE)


#### Arguments that should result in an error ####
expect_error(
  get_details_pkgs(pkgs = 3),
  pattern = "checkinput::all_characters(x = pkgs, allow_zero = TRUE)",
  fixed = TRUE)

expect_error(
  get_details_pkgs(fields = 3),
  pattern = "is.null(fields) || checkinput::all_characters(x = fields)",
  fixed = TRUE)

expect_error(
  get_details_pkgs(priority = 3),
  pattern = "is.null(priority) || checkinput::all_characters(x = priority, ",
  fixed = TRUE)

expect_error(
  get_details_pkgs(lib.loc = 3),
  pattern = "is.null(lib.loc) || checkinput::all_characters(x = lib.loc)",
  fixed = TRUE)

warn_db <- paste0("'db' should be 'NULL' or a matrix with the results of a",
                  " call to\n'utils::installed.packages()' containing column",
                  " 'Package' (or rownames")
expect_error(
  get_details_pkgs(db = 3),
  pattern = warn_db, fixed = TRUE)

expect_error(
  get_details_pkgs(db = matrix(data = 1, nrow = 1)),
  pattern = warn_db, fixed = TRUE)


#### Delete the created temporary files ####
unlink(dir_test_pkg, recursive = TRUE)


#### Remove objects used in tests ####
rm(db_OK, dir_test_pkg, fields_add, fields_discard, fields_req,
   NULL_fields_add, NULL_fields_dupl,
   NULL_fields_req, NULL_pkgs_absent, NULL_pkgs_absent_part, NULL_pkgs_base,
   NULL_pkgs_div, NULL_pkgs_high, NULL_pkgs_NA, NULL_pkgs_rec, NULL_pkgs_rec_base,
   NULL_pkgs_select, obj_zero_row, OK_fields_add, OK_fields_dupl,
   OK_fields_dupl_v2, OK_fields_req, OK_pkgs_absent, OK_pkgs_absent_part,
   OK_pkgs_base, OK_pkgs_div, OK_pkgs_high, OK_pkgs_NA, OK_pkgs_rec,
   OK_pkgs_rec_base, OK_pkgs_select, pkgA, pkgs_absent, pkgs_div, pkgs_present,
   warn_db, warn_zero)
