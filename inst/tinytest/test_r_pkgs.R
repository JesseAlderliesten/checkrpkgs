# Tests in this file are used to confirm code proposed in vignette 'R packages':
# it is checked that packages have the mentioned functions and that functions
# have the mentioned arguments.


#### base ####
expect_true(all(
  c("%in%", ".libPaths", "::", ":::", "args", "basename", "conflictRules",
    "getNamespace", "getOption", "getRversion", "library", "loadedNamespaces",
    "loadNamespace", "make.names", "mean", "options", "path.package",
    "require", "requireNamespace", "suppressPackageStartupMessages",
    "Sys.getenv", "UseMethod") %in%
    ls(getNamespace("base"), all.names = TRUE)
))

expect_true("all.available" %in% names(formals(.packages)))
expect_true(all(c("detail", "where") %in% names(formals(conflicts))))
expect_true(all(
  c("lib.loc", "package", "verbose") %in% names(formals(find.package))
))
expect_true("package" %in% names(formals(help)))
expect_true("fields" %in% names(formals(installed.packages)))
expect_true(all(c("help", "package") %in% names(formals(library))))
expect_true(all(c("lib.loc", "versionCheck") %in% names(formals(loadNamespace))))
expect_true("quietly" %in% names(formals(requireNamespace)))

expect_true(any(grepl(pattern = ".Primitive", x = getAnywhere("log10"))))
expect_true(any(grepl(pattern = ".Internal", x = getAnywhere("matrix"))))
expect_true(isS3method("mean.Date"))

inst_high_prio_pkgs <- installed.packages(
  priority = "high", fields = "SystemRequirements")
expect_true("SystemRequirements" %in% colnames(inst_high_prio_pkgs))
expect_true("base" %in% inst_high_prio_pkgs[, "Package"])
expect_false("translations" %in% inst_high_prio_pkgs[, "Package"])
expect_true(all(
  inst_high_prio_pkgs[, "Package"] == rownames(inst_high_prio_pkgs)
))

hdb_base <- hsearch_db(package = "base", types = "help")
expect_true(all(
  c(".internalGenerics", "Startup") %in%
    c(hdb_base$Base[, "Name"], hdb_base$Aliases[, "Alias"])
))

#### BiocManager ####
if(requireNamespace("BiocManager", quietly = TRUE)) {
  expect_true(all(
    c("available", "repositories", "valid", "version") %in%
      ls(getNamespace("BiocManager"), all.names = TRUE)
  ))
  expect_true(all(
    c("ask", "checkBuilt", "force", "pkgs", "update", "version") %in%
      names(formals(BiocManager::install))
  ))
  expect_true(all(
    c("dependencies", "lib", "type", "verbose") %in%
      names(formals(install.packages))
  ))
  expect_true("build_vignettes" %in% names(formals(remotes::install_github)))
}

#### checkinput ####
if(requireNamespace("checkinput", quietly = TRUE)) {
  expect_true("is_path" %in% ls(getNamespace("checkinput"), all.names = TRUE))
}

#### conflicted ####
if(requireNamespace("conflicted", quietly = TRUE)) {
  expect_true(
    "conflicts_prefer" %in% ls(getNamespace("conflicted"), all.names = TRUE)
  )
}

#### ctv ####
if(requireNamespace("ctv", quietly = TRUE)) {
  expect_true(all(c("views", "coreOnly") %in% names(formals(ctv::install.views))))
  expect_true(all(c("views", "coreOnly") %in% names(formals(ctv::update.views))))
}

#### Matrix ####
if(requireNamespace("Matrix", quietly = TRUE)) {
  expect_false(is.null(
    methods::getMethod(f = "cbind2", signature = c(x = "Matrix", y = "Matrix"))
  ))
}

#### methods ####
expect_true(all(c("f", "signature") %in% names(formals(methods::getMethod))))
expect_true(all(c("classes", "where") %in% names(formals(methods::showMethods))))
expect_true(all(
  c("Introduction", "Methods_Details") %in%
    hsearch_db(package = "methods", types = "help")$Base[, "Name"]
))

#### pkgbuild ####
if(requireNamespace("pkgbuild", quietly = TRUE)) {
  expect_true("debug" %in% names(formals(pkgbuild::check_build_tools)))
}

#### pkgdepends ####
if(requireNamespace("pkgdepends", quietly = TRUE)) {
  expect_true(
    "new_pkg_deps" %in% ls(getNamespace("pkgdepends"), all.names = TRUE)
  )

  # Needed to prevent errors caused by package 'pkgcache', see
  # https://github.com/r-lib/pkgcache#using-pkgcache-in-cran-packages
  withr::local_envvar(
    R_USER_CACHE_DIR = tempfile()
  )

  prop <- pkgdepends::new_pkg_deps("JesseAlderliesten/checkrpkgs")
  expect_true(all(c("draw", "get_solution", "solve") %in% names(prop)))
  prop$solve()
  expect_true("data" %in% names(prop$get_solution()))
}

#### remotes ####
if(requireNamespace("remotes", quietly = TRUE)) {
  expect_true(all(
    c("build_vignettes", "dependencies", "force", "quiet", "repo",
      "upgrade") %in%
      names(formals(remotes::install_github))
  ))
  expect_true(all(
    c("build_vignettes", "dependencies", "package", "quiet", "upgrade",
      "version") %in%
      c(names(formals(remotes::install_version)))))
  expect_true(all(
    c("os", "package") %in% names(formals(remotes::system_requirements))
  ))
  expect_true(all(c("lib", "verbose") %in% names(formals(install.packages))))
}

#### sessioninfo ####
if(requireNamespace("sessioninfo", quietly = TRUE)) {
  expect_true("source" %in% colnames(sessioninfo::session_info(
    pkgs = "checkrpkgs", include_base = FALSE, info = "packages",
    dependencies = FALSE)$packages))
}

#### tools ####
expect_true(all(
  c("CRAN_check_results", "CRAN_package_db") %in%
    ls(getNamespace("tools"), all.names = TRUE)
))
expect_true(all(
  c("pkgs", "recursive") %in% names(formals(tools::dependsOnPkgs))
))
expect_true(all(
  c("packages", "recursive") %in% names(formals(tools::package_dependencies))
))

CRAN_pkg_db <- tools::CRAN_package_db()
expect_true(all(c("Description", "Maintainer") %in% colnames(CRAN_pkg_db)))
expect_true(
  endsWith(x = names(table(CRAN_pkg_db[, "Path"])), suffix = "Recommended")
)

if(getRversion() >= "4.4.0") {
  std_pkg_names <- tools::standard_package_names()
  expect_true(is.list(std_pkg_names))
  expect_identical(names(std_pkg_names), c("base", "recommended"))
}

#### utils ####
expect_true(all(
  c("apropos", "chooseBioCmirror", "chooseCRANmirror", "citation", "data",
    "getAnywhere", "getCRANmirrors", "hasName", "methods", "old.packages",
    "packageVersion", "RSiteSearch", "sessionInfo", "setRepositories") %in%
    ls(getNamespace("utils"), all.names = TRUE)
))
expect_true(all(c("package", "types") %in% names(formals(utils::hsearch_db))))

expect_true("repos" %in% names(formals(utils::available.packages)))
expect_true("package" %in% names(formals(utils::browseVignettes)))
expect_true(all(
  c("package", "agrep", "types") %in% names(formals(utils::help.search))
))
expect_true(all(
  c("dependencies", "lib", "pkgs", "quiet", "repos", "type", "verbose") %in%
    names(formals(install.packages))
))
expect_true("fields" %in% names(formals(utils::installed.packages)))
expect_true("class" %in% names(formals(utils::methods)))
expect_true("package" %in% names(formals(utils::news)))
expect_true(all(
  c("lib.loc", "ask", "checkBuilt", "type") %in%
    names(formals(utils::update.packages))
))
expect_true("package" %in% names(formals(utils::vignette)))
expect_true(all(
  !(c("Description", "Maintainer") %in%
      # Set a repository because that is not done automatically in checks
      colnames(utils::available.packages(repos = "https://cran.rstudio.com/")))
))
expect_false(is.null(attr(methods(class = "aov"), "info")))
