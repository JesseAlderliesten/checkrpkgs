# Notes:
# - Subsequent tests use different packages from base-R that should be present
#   and functional. The packages used here are attached during startup if
#   environment variable R_DEFAULT_PACKAGES is unset (they should be in
#   options("defaultPackages"), see help("Startup") and the entry
#   'defaultPackages' in help(options)).


#### Create objects to use in tests ####
non_existent_pkgs <- c("yz/wx/abcdef4", "wx/abcdef3", "abcdef2", "abcdef1")
warn_non_existent_pkgs <- paste0("non-installed packages: ",
                                 progutils::paste_quoted(non_existent_pkgs))


#### Test the examples ####
# This test assumes base packages 'base' is installed and functional.
expect_silent(
  expect_identical(
    check_pkgs(pkgs = "base", quietly = FALSE),
    list(absent = character(0), nonfunc = character(0))
  )
)

expect_warning(
  expect_identical(
    check_pkgs(pkgs = non_existent_pkgs, quietly = FALSE),
    list(absent = non_existent_pkgs, nonfunc = character(0))
  ),
  pattern = warn_non_existent_pkgs, strict = TRUE, fixed = TRUE)

expect_warning(
  expect_identical(
    check_pkgs(pkgs = non_existent_pkgs, quietly = TRUE),
    list(absent = non_existent_pkgs, nonfunc = character(0))
  ),
  pattern = warn_non_existent_pkgs, strict = TRUE, fixed = TRUE)

# This test assumes base package 'utils' is installed and functional.
expect_warning(
  expect_identical(
    check_pkgs(pkgs = c(non_existent_pkgs, "utils"), quietly = FALSE),
    list(absent = non_existent_pkgs, nonfunc = character(0))
  ),
  pattern = warn_non_existent_pkgs, strict = TRUE, fixed = TRUE)


#### Tests ####
# Everything up to the last slash should be removed. This test assumes base
# packages 'methods', 'stats', 'datasets' and 'graphics' are installed and
# functional.
expect_silent(
  expect_identical(
    check_pkgs(pkgs = c("ab/methods", "ab/cd/stats", "ab/datasets",
                        "ab/cd/graphics"),
               quietly = TRUE),
    list(absent = character(0), nonfunc = character(0)))
)

# Arguments that should result in an error.
expect_error(
  check_pkgs(pkgs = character(0), quietly = FALSE),
  pattern = "all_characters(pkgs) is not TRUE", fixed = TRUE)

expect_error(
  check_pkgs(pkgs = "", quietly = FALSE),
  pattern = "all_characters(pkgs) is not TRUE", fixed = TRUE)

expect_error(
  check_pkgs(pkgs = 1, quietly = FALSE),
  pattern = "all_characters(pkgs) is not TRUE", fixed = TRUE)

expect_error(
  check_pkgs(pkgs = non_existent_pkgs, quietly = NA),
  pattern = "is_logical(quietly) is not TRUE", fixed = TRUE)

expect_error(
  check_pkgs(pkgs = non_existent_pkgs, quietly = 1),
  pattern = "is_logical(quietly) is not TRUE", fixed = TRUE)


#### Remove objects used in tests ####
rm(non_existent_pkgs, warn_non_existent_pkgs)
