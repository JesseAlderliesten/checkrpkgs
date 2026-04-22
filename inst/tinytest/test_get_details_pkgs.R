#### Create objects to use in tests ####
fields_std <- c("Package", "LibPath", "Version", "Priority", "NeedsCompilation",
                "Built", "Repository", "URL", "GithubRepo", "GithubUsername")
pkgs_present <- c("JesseAlderliesten/checkinput", "JesseAlderliesten/checkrpkgs")
pkgs_absent <- c("package_one_is_not_there", "package_two_is_not_there")


#### Tests ####
# Test argument 'priority' (also used as an example)
expect_silent(details_base <- get_details_pkgs(priority = "base"))
expect_true(nrow(details_base) > 0L)
expect_true(all(fields_std %in% colnames(details_base)))
expect_true(all(details_base[, "Priority", drop = FALSE] == "base"))

# Enable requesting a non-default field (also used as an example)
expect_silent(
  details_v2 <- get_details_pkgs(pkgs = pkgs_present,
                                 fields = c("SystemRequirements", "SomeField")))
expect_true(all(rownames(details_v2) %in% basename(pkgs_present)))
expect_true(all(c(fields_std, "SystemRequirements", "SomeField") %in%
                  colnames(details_v2)))
expect_true(all(is.na(details_v2[, "Priority", drop = FALSE])))
expect_true(all(is.na(details_v2[, "SomeField", drop = FALSE])))
expect_true(all(details_v2[, "Repository"] == "Github"))

# Do not duplicate fields if a default field and a hardcoded field are requested
expect_silent(
  details_v3 <- get_details_pkgs(pkgs = pkgs_present,
                                 fields = c("LibPath", "URL")))
expect_true(all(rownames(details_v3) %in% basename(pkgs_present)))
expect_true(all(c(fields_std, "LibPath", "URL") %in% colnames(details_v3)))
expect_true(all(is.na(details_v3[, "Priority", drop = FALSE])))
expect_true(all(details_v3[, "Repository"] == "Github"))

# Warn if some packages are not found (also used as an example)
expect_warning(
  details_some_absent <- get_details_pkgs(pkgs = c("base", pkgs_absent)),
  pattern = paste0("Some packages were not found at 'lib.loc'.+",
                   progutils::paste_quoted(pkgs_absent)),
  strict = TRUE, fixed = FALSE)
expect_true(all(rownames(details_some_absent) %in% "base"))
expect_true(all(fields_std %in% colnames(details_some_absent)))

# Warn if no packages are found
expect_warning(
  details_all_absent <- get_details_pkgs(pkgs = pkgs_absent),
  pattern = paste0("Returning a zero-row matrix because none of the packages",
                   " were found at 'lib.loc'.+",
                   progutils::paste_quoted(pkgs_absent)),
  strict = TRUE, fixed = FALSE)
expect_identical(nrow(details_all_absent), 0L)
expect_true(all(fields_std %in% colnames(details_all_absent)))

# Arguments that should result in an error.
expect_error(
  get_details_pkgs(pkgs = 3),
  pattern = "checkinput::all_characters(x = pkgs, allow_zero = TRUE) is not TRUE",
  fixed = TRUE)


#### Remove objects used in tests ####
rm(details_base, details_all_absent, details_some_absent, details_v2, details_v3,
   fields_std, pkgs_absent, pkgs_present)
