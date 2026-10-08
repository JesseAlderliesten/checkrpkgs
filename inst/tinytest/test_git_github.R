#### base ####
expect_true(all(
  c(".libPaths", "cat", "getwd", "normalizePath", "setwd") %in%
    ls(getNamespace("base"), all.names = TRUE)
))

expect_true(all(c("fixed", "pattern", "value", "x") %in% names(formals(grep))))
expect_true("quietly" %in% names(formals(requireNamespace)))

#### remotes ####
if(requireNamespace("remotes", quietly = TRUE)) {
  expect_true(all(
    c("build_vignettes", "dependencies", "force", "quiet", "repo", "upgrade") %in%
      names(formals(remotes::install_github))
  ))
  expect_true(all(c("lib", "verbose") %in% names(formals(install.packages))))
}

#### tools ####
expect_true(all(c("from", "to") %in% names(formals(tools::Rdiff))))

#### utils ####
expect_true(all(
  c("dependencies", "lib", "pkgs", "quiet", "type", "verbose") %in%
    names(formals(utils::install.packages))
))
