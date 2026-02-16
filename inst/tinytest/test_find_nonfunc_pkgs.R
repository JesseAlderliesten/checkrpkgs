# Notes:
# - Subsequent tests use different packages from base-R that are known to be
#   present and functional. These packages are attached during startup if they
#   are in options("defaultPackages") (see help("Startup")).


#### Create objects to use in tests ####
non_existent_pkgs <- c("yz/wx/abcdef4", "wx/abcdef3", "abcdef2", "abcdef1")
msg_restart <- "Restart R to prevent problems arising from updating loaded packages"
warn_non_existent_pkgs <- progutils::wrap_text(paste0(
  "non-installed packages: ", progutils::paste_quoted(non_existent_pkgs)))


#### Test the examples ####
# This test assumes base package 'base' are installed and functional.
expect_message(
  expect_equal(
    find_nonfunc_pkgs(pkgs = c("base", "grid"), quietly = FALSE),
    list(absent = character(0), nonfunc = character(0))
  ),
  pattern = msg_restart, strict = TRUE, fixed = TRUE)

expect_warning(
  expect_equal(
    find_nonfunc_pkgs(pkgs = non_existent_pkgs, quietly = FALSE),
    list(absent = non_existent_pkgs, nonfunc = character(0))
  ),
  pattern = warn_non_existent_pkgs, strict = TRUE, fixed = TRUE)

expect_warning(
  expect_equal(
    find_nonfunc_pkgs(pkgs = non_existent_pkgs, quietly = TRUE),
    list(absent = non_existent_pkgs, nonfunc = character(0))
  ),
  pattern = warn_non_existent_pkgs, strict = TRUE, fixed = TRUE)

expect_warning(
  expect_equal(
    find_nonfunc_pkgs(pkgs = c(non_existent_pkgs, "utils"), quietly = FALSE),
    list(absent = non_existent_pkgs, nonfunc = character(0))
  ),
  pattern = warn_non_existent_pkgs, strict = TRUE, fixed = TRUE)


#### Tests ####
# Everything before the last slash should be removed. This test assumes base
# packages 'methods', 'stats', 'stats4' and 'splines' are installed and
# functional.
expect_message(
  expect_equal(
    find_nonfunc_pkgs(pkgs = c("ab/methods", "ab/cd/stats", "ab/stats4",
                               "ab/cd/splines"),
                      quietly = TRUE),
    list(absent = character(0), nonfunc = character(0))),
  pattern = msg_restart, strict = TRUE, fixed = TRUE)

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
