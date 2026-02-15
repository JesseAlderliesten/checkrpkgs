# Notes:
# - Subsequent tests should probably use different packages.
# - Tests use packages from base-R that are attached during startup if they are
#   in options("defaultPackages") (see help("Startup")): these packages should
#   not have an effect; and recommended packages for which it is assumed are not
#   in options("defaultPackages") such that they are not loaded during startup.


#### Create objects to use in tests ####
non_existent_pkgs <- c("yz/wx/abcdef4", "wx/abcdef3", "abcdef2", "abcdef1")
msg_restart <- "Restart R to prevent problems arising from updating loaded packages"
warn_non_existent_pkgs <- progutils::wrap_text(paste0(
  "non-installed packages: ", progutils::paste_quoted(non_existent_pkgs)))


#### Test the examples ####
# This test assumes base package 'base' and recommended package 'grid' are
# installed and functional.
expect_message(
  expect_equal(
    find_nonfunc_pkgs(pkgs = c("base", "grid"), quietly = FALSE),
    character(0)),
  pattern = msg_restart, strict = TRUE, fixed = TRUE)

expect_warning(
  expect_equal(
    find_nonfunc_pkgs(pkgs = non_existent_pkgs, quietly = FALSE),
    non_existent_pkgs),
  pattern = warn_non_existent_pkgs, strict = TRUE, fixed = TRUE)

expect_warning(
  expect_equal(
    find_nonfunc_pkgs(pkgs = non_existent_pkgs, quietly = TRUE),
    non_existent_pkgs),
  pattern = warn_non_existent_pkgs, strict = TRUE, fixed = TRUE)

expect_warning(
  expect_equal(
    find_nonfunc_pkgs(pkgs = c(non_existent_pkgs, "utils"), quietly = FALSE),
    non_existent_pkgs),
  pattern = warn_non_existent_pkgs, strict = TRUE, fixed = TRUE)


#### Tests ####
# Everything before the last slash should be removed. This test assumes base
# packages 'methods' and 'utils' and recommended packages 'stats4' and 'Matrix'
# are installed and functional.
# expect_message(
  expect_equal(
    find_nonfunc_pkgs(pkgs = c("ab/methods", "ab/cd/utils", "ab/stats4",
                               "ab/cd/Matrix"),
                      quietly = TRUE),
    character(0))
#,  pattern = msg_restart, strict = TRUE, fixed = TRUE)

# Arguments that should result in an error.
expect_error(
  find_nonfunc_pkgs(pkgs = character(0), quietly = FALSE),
  pattern = "all_characters(pkgs) is not TRUE", fixed = TRUE)

expect_error(
  find_nonfunc_pkgs(pkgs = "", quietly = FALSE),
  pattern = "all_characters(pkgs) is not TRUE", fixed = TRUE)

expect_error(
  find_nonfunc_pkgs(pkgs = 1, quietly = FALSE),
  pattern = "all_characters(pkgs) is not TRUE", fixed = TRUE)

expect_error(
  find_nonfunc_pkgs(pkgs = non_existent_pkgs, quietly = NA),
  pattern = "is_logical(quietly) is not TRUE", fixed = TRUE)

expect_error(
  find_nonfunc_pkgs(pkgs = non_existent_pkgs, quietly = 1),
  pattern = "is_logical(quietly) is not TRUE", fixed = TRUE)


#### Remove objects used in tests ####
rm(non_existent_pkgs, warn_non_existent_pkgs)
