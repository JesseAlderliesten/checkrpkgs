# Notes:
# - Subsequent tests use different packages from base R that should be present
#   and functional. The packages used here are attached during startup if
#   environment variable R_DEFAULT_PACKAGES is unset (they should be in
#   options("defaultPackages"), see help("Startup") and the entry
#   'defaultPackages' in help(options)).

# Check that environment value R_DEFAULT_PACKAGES is unset
expect_silent(expect_identical(Sys.getenv("R_DEFAULT_PACKAGES"), ""))

# Check that packages 'utils', 'grDevices', 'methods', 'stats', 'datasets', and
# 'graphics' are in the output of options("defaultPackages")
expect_silent(
  expect_true(
    all(c("utils", "grDevices", "methods", "stats", "datasets", "graphics") %in%
          unlist(options("defaultPackages"), use.names = FALSE))
  )
)


#### Create objects to use in tests ####
non_existent_pkgs <- c("yz/wx/abcdef4", "wx/abcdef3", "abcdef2", "abcdef1")
warn_non_existent_pkgs <- paste0("non-installed packages: ",
                                 progutils::paste_quoted(non_existent_pkgs))


#### Test the examples ####
# This test assumes base packages 'base' and 'utils' are installed and functional.
expect_silent(
  expect_identical(
    check_pkgs(pkgs = c("base", "utils")),
    list(absent = character(0), nonfunc = character(0))
  )
)

# Not using 'expect_silent()' because it might warn about 'checkrpkgs' installed
# in multiple places.
expect_identical(
  check_pkgs(pkgs = c("base", "utils", "jessealderliesten/checkrpkgs")),
  list(absent = character(0), nonfunc = character(0))
)

expect_warning(
  expect_identical(
    check_pkgs(pkgs = non_existent_pkgs, silently = FALSE),
    list(absent = non_existent_pkgs, nonfunc = character(0))
  ),
  pattern = warn_non_existent_pkgs, strict = TRUE, fixed = TRUE)

expect_warning(
  expect_identical(
    check_pkgs(pkgs = non_existent_pkgs, silently = TRUE),
    list(absent = non_existent_pkgs, nonfunc = character(0))
  ),
  pattern = warn_non_existent_pkgs, strict = TRUE, fixed = TRUE)

expect_warning(
  expect_identical(
    check_pkgs(pkgs = c(non_existent_pkgs, "grDevices"), silently = FALSE),
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
               silently = TRUE),
    list(absent = character(0), nonfunc = character(0)))
)

# Arguments that should result in an error.
expect_error(
  check_pkgs(pkgs = character(0), silently = FALSE),
  pattern = "all_characters(pkgs) is not TRUE", fixed = TRUE)

expect_error(
  check_pkgs(pkgs = "", silently = FALSE),
  pattern = "all_characters(pkgs) is not TRUE", fixed = TRUE)

expect_error(
  check_pkgs(pkgs = 1, silently = FALSE),
  pattern = "all_characters(pkgs) is not TRUE", fixed = TRUE)

expect_error(
  check_pkgs(pkgs = non_existent_pkgs, silently = NA),
  pattern = "is_logical(silently) is not TRUE", fixed = TRUE)

expect_error(
  check_pkgs(pkgs = non_existent_pkgs, silently = 1),
  pattern = "is_logical(silently) is not TRUE", fixed = TRUE)


#### Remove objects used in tests ####
rm(non_existent_pkgs, warn_non_existent_pkgs)
