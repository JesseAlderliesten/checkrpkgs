#### base ####
expect_true(all(
  c(".libPaths", ".Machine", ".Platform", "attr", "browser", "capabilities",
    "conflictRules", "conflicts", "diag", "extSoftVersion", "getRversion",
    "getwd", "l10n_info", "loadedNamespaces", "options", "pmatch", "R.Version",
    "sample", "sapply", "stop", "suppressWarnings", "Sys.getenv",
    "Sys.getlocale", "Sys.info", "warning") %in%
    ls(getNamespace("base"), all.names = TRUE)
))

if(requireNamespace("utils", quietly = TRUE)) {
  hdb_base <- utils::hsearch_db(package = "base", types = "help")
  expect_true(all(
    c("colon", "Control", "environment variables", "Extract", "Logic", "Startup") %in%
      c(hdb_base$Base[, "Name"], hdb_base$Aliases[, "Alias"])
  ))
}

#### conflicted ####
if(requireNamespace("conflicted", quietly = TRUE)) {
  expect_true(
    "conflicts_prefer" %in% ls(getNamespace("conflicted"), all.names = TRUE)
  )
}

#### pkgbuild ####
if(requireNamespace("pkgbuild", quietly = TRUE)) {
  expect_true("debug" %in% names(formals(pkgbuild::check_build_tools)))
}

#### sessioninfo ####
if(requireNamespace("sessioninfo", quietly = TRUE)) {
  expect_true(
    "session_info" %in% ls(getNamespace("sessioninfo"), all.names = TRUE)
  )
}

#### utils ####
expect_true(all(
  c("help.start", "install.packages", "sessionInfo") %in%
    ls(getNamespace("utils"), all.names = TRUE)
))
