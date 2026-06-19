# R packages

## Introduction and notation

This vignette explains how to install R packages; how to get information
about to-be-installed and already-installed R packages; and how to get
the source code of R functions.

Text between angled brackets (`<...>`) is used to refer to text that
should be replaced with specific text to get working code or working
file paths. For example, `<pkg>` is used as a place holder to refer to a
package name and should be replaced with `utils` if you want to get
information about package `utils`, and with `methods` if you want to get
information about package `methods`. Similarly, `<func>` is used as a
place holder to refer to a function name that should be replaced with a
specific function name to get working code.

In this vignette, calls to functions are frequently written in the form
`<pkg>::<func>()`, to make clear which package is used and, through the
brackets, that a function is indicated. In normal code, one would use
`library(<pkg>)` followed by `<func>()`. For example, in this vignette
the notation
[`utils::citation()`](https://rdrr.io/r/utils/citation.html) is used to
show how to cite R, indicating that the function
[`citation()`](https://rdrr.io/r/utils/citation.html) is defined in
package `utils`. In normal code, one would use
[`library(utils)`](https://rdrr.io/r/base/library.html) followed by
[`citation()`](https://rdrr.io/r/utils/citation.html) where that is
needed.

## R packages

An R
[package](https://cran.r-project.org/doc/FAQ/R-FAQ.html#What-is-the-difference-between-package-and-library_003f)
is a standardized collection of material extending R by providing code,
data, or documentation.

The
[base](https://cran.r-project.org/doc/FAQ/R-FAQ.html#Add_002don-packages-in-R)
packages are always installed together with R. The
[recommended](https://cran.r-project.org/doc/FAQ/R-FAQ.html#Add_002don-packages-from-CRAN)
packages are installed with binary distributions of R. Together, the
base and recommended packages are the ‘high priority’ packages. Since R
4.4.0,
[`tools::standard_package_names()`](https://rdrr.io/r/tools/testInstalledPackage.html)
contains a list with the names of these packages. To see which
high-priority packages are currently installed, run
`sort(unname(installed.packages(priority = "high")[, "Package"]))`.
Package ‘translations’ is not a recommended package, but will be
installed if that option is set during the installation of R.

### Installing packages

To install a package, run R or RStudio as administrator: right-click on
the R or RStudio icon and select `Run as administrator`. Packages can be
obtained from several websites, called ‘repositories’, such as `CRAN`,
`BioConductor`, and `GitHub`, discussed in the next sections. After
installing a package, you need to
[attach](#loading-and-attaching-packages) the package to be able to use
its functions: run `library(<pkg>)`.

#### CRAN

The [Comprehensive R Archive Network](https://cran.r-project.org/)
(CRAN) is the main repository of R
[packages](https://cran.r-project.org/web/packages/index.html). The
following code can be used to install packages from CRAN:

``` r
pkgs_new <- c(<pkg>, <pkg>)
# Select packages from 'pkgs_new' that are not installed or not functional
pkgs_install <- pkgs_new[!vapply(X = pkgs_new, FUN = requireNamespace,
                                 FUN.VALUE = logical(1), quietly = TRUE)]
if(length(pkgs_install) > 0L) {
  install.packages(pkgs = pkgs_install, lib = .libPaths(), dependencies = NA,
                   type = getOption("pkgType"), verbose = getOption("verbose"),
                   quiet = FALSE)
}
```

CRAN has thematic package collections known as [task
views](https://cran.r-project.org/web/views/). To install all core
packages of a task view, install package
[`ctv`](https://CRAN.R-project.org/package=ctv) and run
`ctv::install.views("<taskview>", coreOnly = TRUE)`. To update these
packages, use `ctv::update.views("<taskview>", coreOnly = TRUE)`.

[`utils::available.packages()`](https://rdrr.io/r/utils/available.packages.html)
gives information about packages available from
[CRAN](https://cran.r-project.org/web/packages/index.html).
[`tools::CRAN_package_db()`](https://rdrr.io/r/tools/CRANtools.html)
includes the `Description` and `Maintainer` fields not returned by
[`utils::available.packages()`](https://rdrr.io/r/utils/available.packages.html).
[`tools::CRAN_check_results()`](https://rdrr.io/r/tools/CRANtools.html)
gives information about the current check status of CRAN packages.
Packages from CRAN that have been recently archived, for example because
check issues were not addressed in time, are available at
[CRANhaven](https://www.cranhaven.org/).

#### BioConductor

The [Bioconductor](https://bioconductor.org/) repository has a new
release every six months. Each release contains specific versions of
packages from [CRAN](https://cran.r-project.org/web/packages/index.html)
and
[BioConductor](https://bioconductor.org/packages/release/BiocViews.html)
that are consistent with each other and with a [specific
version](https://bioconductor.org/about/release-announcements/) of R,
preventing version conflicts between R packages.

The following code can be used to install packages from BioConductor
release [version](https://bioconductor.org/about/release-announcements/)
3.23. This code installs the
[`BiocManager`](https://CRAN.R-project.org/package=BiocManager) package
from [CRAN](https://cran.r-project.org/) that is then used to install
packages from `Bioconductor` and CRAN and, through
[`remotes::install_github()`](https://remotes.r-lib.org/reference/install_github.html)
(see the next [section](#github)), from GitHub:

``` r
pkgs_new <- c(<pkg>, <pkg>)
if(!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages(pkgs = "BiocManager", lib = .libPaths(), dependencies = NA,
                   type = getOption("pkgType"), verbose = getOption("verbose"),
                   quiet = FALSE)
}
BiocManager::install(pkgs = pkgs_new, lib = .libPaths(), dependencies = NA,
                     build_vignettes = TRUE,
                     type = getOption("pkgType"), verbose = getOption("verbose"),
                     update = FALSE, ask = TRUE, checkBuilt = TRUE,
                     force = FALSE, version = "3.23")
```

Bioconductor also has thematic package collections known as
[BiocViews](https://bioconductor.org/packages/release/BiocViews.html).

`utils::available.packages(fields = NULL, repos = BiocManager::repositories())`
gives information about packages available from
[BioConductor](https://bioconductor.org/packages/release/BiocViews.html),
and
[`BiocManager::available()`](https://bioconductor.github.io/BiocManager/reference/available.html)
gives their names.

#### Github

The following code can be used to install packages from
[GitHub](https://github.com/): it installs the
[`remotes`](https://CRAN.R-project.org/package=remotes) package that is
needed to install packages from GitHub, selects those elements of
`pkgs_new` that give the author name and repository name (e.g.,
`"JesseAlderliesten/checkrpkgs"`) or the full URL to a package (e.g.,
`"https://github.com/JesseAlderliesten/checkrpkgs"`) as required by
[`remotes::install_github()`](https://remotes.r-lib.org/reference/install_github.html),
and installs those packages. To match such names to package names as
returned by
[`utils::installed.packages()`](https://rdrr.io/r/utils/installed.packages.html),
use `basename(pkgs_new)` to select the last part of those names:
`pkgs_new[!(basename(pkgs_new) %in% installed.packages()[, "Package"])]`.

``` r

pkgs_new <- "JesseAlderliesten/checkrpkgs"
if(!requireNamespace("remotes", quietly = TRUE)) {
  install.packages(pkgs = "remotes", lib = .libPaths(), dependencies = NA,
                   type = getOption("pkgType"), verbose = getOption("verbose"),
                   quiet = FALSE)
}
remotes::install_github(repo = grep(pattern = "/", x = pkgs_new, value = TRUE),
                        dependencies = NA, upgrade = "ask", force = FALSE,
                        quiet = FALSE, build_vignettes = TRUE, lib = .libPaths(),
                        verbose = getOption("verbose"))
```

#### Other repositories

Examples of other repositories for R packages are:

- [Neuroconductor](https://neuroconductor.org/list-packages/all)
- [R-Forge](https://r-forge.r-project.org/) with a [GitHub
  mirror](https://github.com/r-forge) and thematic package
  [collections](https://r-forge.r-project.org/softwaremap/trove_list.php)
- [R-multiverse](https://r-multiverse.org/overview.html) with thematic
  package [collections](https://r-multiverse.org/topics/)
- [rOpenSci](https://ropensci.org/packages/all/) with thematic package
  [collections](https://ropensci.org/packages/)
- [R universe](https://r-universe.dev/search) with an
  [overview](https://r-universe.dev/datasets) of datasets (see
  [`help("data", package = "utils")`](https://rdrr.io/r/utils/data.html))
  included in R packages

Repositories can be selected using
[`utils::setRepositories()`](https://rdrr.io/r/utils/setRepositories.html).
The websites of these repositories include instructions how to install
packages from them. In addition, package
[`remotes`](https://CRAN.R-project.org/package=remotes) contains
functions to install packages from some of these repositories. The
following code shows how to install packages from
[R-Forge](https://r-forge.r-project.org/) as an example:

``` r
pkgs_new <- c(<pkg>, <pkg>)
# Select packages from 'pkgs_new' that are not installed or not functional
pkgs_install <- pkgs_new[!vapply(X = pkgs_new, FUN = requireNamespace,
                                 FUN.VALUE = logical(1), quietly = TRUE)]
if(length(pkgs_install) > 0L) {
  install.packages(pkgs = pkgs_install, lib = .libPaths(),
                   repos = "https://r-forge.r-project.org/", dependencies = NA,
                   type = getOption("pkgType"), verbose = getOption("verbose"),
                   quiet = FALSE)
}
```

#### Mirror websites

Mirror websites (‘mirrors’) are websites hosted in various parts of the
world with the same content as the main website. Using a nearby mirror
allows for faster downloads. Mirrors of repositories can be selected
using
[`utils::setRepositories()`](https://rdrr.io/r/utils/setRepositories.html),
which in the documentation also mentions `options("repos")`,
`options("BioC_mirror")` and the environment variable `R_REPOSITORIES`
(the value of which is shown by `Sys.getenv("R_REPOSITORIES")`).

CRAN [mirrors](https://cran.r-project.org/mirrors.html), with
information about their
[status](https://cran.r-project.org/mirmon_report.html) that is also
available from within R through
[`utils::getCRANmirrors()`](https://rdrr.io/r/utils/chooseCRANmirror.html),
can be selected using
[`utils::chooseCRANmirror()`](https://rdrr.io/r/utils/chooseCRANmirror.html).
However, RStudio
[uses](https://docs.posit.co/ide/user/ide/guide/environments/r/packages.html#primary-repository)
the [RStudio CRAN mirror](https://cran.rstudio.com) with its own global
distribution, which is signalled by the message
`'getOption("repos")' replaces Bioconductor standard repositories, see 'help("repositories", package = "BiocManager")' for details`.

Bioconductor [mirrors](https://bioconductor.org/about/mirrors/), with
information about their
[status](https://bioconductor.org/dashboard/#mirror_status), can be
selected using
[`BiocManager::repositories()`](https://bioconductor.github.io/BiocManager/reference/repositories.html)
or
[`utils::chooseBioCmirror()`](https://rdrr.io/r/utils/chooseBioCmirror.html),
although the RStudio CRAN mirror is used in RStudio (see the preceding
paragraph).

### Loading and attaching packages

After installing a package, you need to load the namespace of a package
and attach the package to the search list to be able to use its
functions: run `library(<pkg>)`. If this fails without clear reason,
setting environment variable `_R_TRACE_LOADNAMESPACE_` to a numerical
value (e.g., `Sys.setenv("_R_TRACE_LOADNAMESPACE_" = 4)`) will generate
additional messages on progress for non-standard packages (see the
section `Tracing` in
[`help("requireNamespace")`](https://rdrr.io/r/base/ns-load.html)).

[`loadedNamespaces()`](https://rdrr.io/r/base/ns-load.html) gives the
names of packages that are currently loaded,
[`utils::sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html) also
gives their versions,
[`path.package()`](https://rdrr.io/r/base/find.package.html) gives the
paths from which packages were loaded.
[`sessioninfo::session_info()`](https://sessioninfo.r-lib.org/reference/session_info.html)
provides both the version and the path and has the option to show
information about their dependencies (and returns the names in
alphabetical order instead of the order of loading).
`options("defaultPackages")` gives the names of packages that are
attached by default when R starts up if environment variable
`R_DEFAULT_PACKAGES` is unset (i.e., `Sys.getenv("R_DEFAULT_PACKAGES")`
is `""`, see [`help("Startup")`](https://rdrr.io/r/base/Startup.html)
and the entry `defaultPackages` in
[`help(options)`](https://rdrr.io/r/base/options.html)).

### Updating packages

Updating out-of-date packages prevents compatibility issues between
already-installed and newly-installed packages.

#### CRAN

For R packages from CRAN, versions can be compared using
[`diffify`](https://diffify.com/R) and a chronological overview of
changes is available at
[CRANberries](https://dirk.eddelbuettel.com/cranberries/). To get the
version number of an installed package, run
`utils::packageVersion("<pkg>")`.
[`old.packages()`](https://rdrr.io/r/utils/update.packages.html)
indicates which packages can be updated.

The following code can be used to install the latest version of packages
from [CRAN](https://cran.r-project.org/web/packages/index.html) (this
**changes** the version of already-installed packages, which might be
undesirable):

``` r

utils::update.packages(lib.loc = .libPaths(), ask = TRUE, dependencies = NA,
                       verbose = getOption("verbose"), quiet = FALSE,
                       checkBuilt = TRUE, type = getOption("pkgType"))
```

#### Bioconductor

[`BiocManager::valid()`](https://bioconductor.github.io/BiocManager/reference/valid.html)
indicates which packages can be updated and also checks for too new
packages, taking the currently used version of Bioconductor (see
[`BiocManager::version()`](https://bioconductor.github.io/BiocManager/reference/version.html))
into account. The following code can be used to update packages to a
specific BioConductor release (here version 3.23):

``` r

if(!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages(pkgs = "BiocManager", lib = .libPaths(), dependencies = NA,
                   type = getOption("pkgType"), verbose = getOption("verbose"),
                   quiet = FALSE)
}
BiocManager::install(pkgs = character(), lib = .libPaths(), dependencies = NA,
                     build_vignettes = TRUE,
                     type = getOption("pkgType"), verbose = getOption("verbose"),
                     update = TRUE, ask = TRUE, checkBuilt = TRUE, force = FALSE,
                     version = "3.23")
```

### Installing old versions

Installing old versions of a package might require installing Rtools to
build the packages from source, see the section `Rtools` in the vignette
*Installing R, Rtools and RStudio*:
[`vignette("install_r", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/install_r.md).

#### CRAN

The following code can be used to install an old version of a package
from CRAN, using package
[`remotes`](https://CRAN.R-project.org/package=remotes):

``` r

if(!requireNamespace("remotes", quietly = TRUE)) {
  install.packages(pkgs = "remotes", lib = .libPaths(), dependencies = NA,
                   type = getOption("pkgType"), verbose = getOption("verbose"),
                   quiet = FALSE)
}
remotes::install_version(package = "deSolve", version = "1.40", dependencies = NA,
                         upgrade = "ask", quiet = FALSE, build_vignettes = TRUE,
                         lib = .libPaths(), verbose = getOption("verbose"))
```

Alternatively, visit the installation page of a package from CRAN, go to
`Downloads` \> `Old sources` \> `<pkg> archive` and find the appropriate
URL pointing to an older version to install it using base R. For
example, to install version 1.40 of package
[`deSolve`](https://CRAN.R-project.org/package=deSolve):

``` r

install.packages(
  pkgs = "https://cran.r-project.org/src/contrib/Archive/deSolve/deSolve_1.40.tar.gz",
  lib = .libPaths(), repos = NULL, dependencies = NA,
  type = getOption("pkgType"), verbose = getOption("verbose"),
  quiet = FALSE)
```

#### Bioconductor

Older versions of packages from Bioconductor can be installed by
changing the value of argument `version` of
[`BiocManager::install()`](https://bioconductor.github.io/BiocManager/reference/install.html)
(e.g., `BiocManager::install(pkgs = "deSolve", version = "3.22")` to
indicate the version of `deSolve` included in BioConductor version 3.22)
but that only works when using the version of R for that specific
version of Bioconductor, see the
[overview](https://bioconductor.org/about/release-announcements/) of
Bioconductor versions with the corresponding R version. Information on
these older packages can be found by visiting the appropriate version of
Bioconductor, e.g.,
`https://bioconductor.org/packages/3.22/BiocViews.html`.

### Troubleshooting

#### Installing packages

- If the warning `lib = <pkg> is not writeable` or
  `'lib' element <element from .libPaths()> is not a writable directory`
  occurs, you probably forgot to run R (or RStudio) as administrator.
  Close it, right-click on the R (or RStudio) icon and select
  `Run as administrator` to start it as administrator.

- If the question
  `Do you want to install from sources the packages which need compilation?`
  is asked (in a new window), accompanied by the remark
  `There are binary versions available but the source versions are later`
  with an overview of the binary and source versions indicating if these
  need compilation, you can choose `Yes` to install the latest package
  versions by building them from source, or choose `No` to get slightly
  less up-to-date package versions but a faster installation.

  To install [Rtools](https://cran.r-project.org/bin/windows/Rtools/),
  see the section `Rtools` in the vignette *Installing R, Rtools and
  RStudio*:
  [`vignette("install_r", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/install_r.md).
  If you want the latest version without using Rtools, you can try again
  a few days later: it usually takes a bit longer for the binaries
  (i.e., the package versions that do not have to be build from source)
  from CRAN and Bioconductor to be updated than for the source versions
  used by Rtools.

- The warning `package '<pkg>' is not available (for R version x.y.z)`
  can have many reasons. First check the package name, which is
  case-sensitive. Then check possible other reasons mentioned in this
  [stackoverflow answer](https://stackoverflow.com/a/25721890/32365738).

- If installing packages fails, try with arguments `force = TRUE` to
  re-install possibly broken dependencies and with argument
  `build_vignettes = FALSE` to not install vignettes.

#### Using packages

- If a package appears not to be installed when you want to use a
  function from it (e.g., you get the error
  `could not find function "<func>"`), remember you need to run
  `library(<pkg>)` to be able to use its functions.

- If `library(<pkg>)` results in the error
  `there is no package called '<pkg>'`, you have not installed the
  package, or it is not in any of the library paths returned by
  [`.libPaths()`](https://rdrr.io/r/base/libPaths.html), which is where
  R looks for packages.

- To check that a package is installed and functional, use
  `library(<pkg)` or `requireNamespace(<pkg>)`. These functions do not
  allow vectors as input, such that the following code has to be used to
  check multiple packages:

  ``` r
  suppressPackageStartupMessages(
    !vapply(X = c(<pkg>, <pkg>), FUN = requireNamespace, FUN.VALUE = logical(1),
            lib.loc = NULL, quietly = FALSE)
  )
  ```

- If a package is not functional, re-install it using argument
  `force = TRUE` to re-install possibly broken dependencies. You can
  also use
  `tools::package_dependencies(packages = "<pkg>", recursive = TRUE)` to
  check which dependencies it has and
  `installed.packages(fields = "SystemRequirements")["<pkg>", "SystemRequirements"]`
  to check which system requirements it has. On operating systems other
  than Windows,
  `remotes::system_requirements(os = "<os>-<version>", package = <pkg>)`
  can be used to get installation instructions for system requirements.

- If the warning `package <pkg> was built under R version 'x.y.z'`
  occurs, you installed a binary package (i.e., not by building from
  source) that was prepared (‘compiled’) for an earlier version of R
  than the version of R you are currently using (run
  [`getRversion()`](https://rdrr.io/r/base/numeric_version.html) to see
  your current R version). The warning is issued because packages are
  **not** tested on versions of R that are older than the version they
  were built on. Therefore it is best to update R when installing
  packages.

- If errors occur when [loading and attaching
  packages](#loading-and-attaching-packages) that require Java, make
  sure the 64-bit [version of
  Java](https://www.java.com/download/manual.jsp) is installed on 64-bit
  PCs.

## Information about packages

Information about packages can be obtained from the internet before the
packages are installed, and from within R after the packages are
installed.

### Not-yet-installed packages

#### Available packages

[`utils::available.packages()`](https://rdrr.io/r/utils/available.packages.html)
and [`tools::CRAN_package_db()`](https://rdrr.io/r/tools/CRANtools.html)
give information about packages available from
[CRAN](https://cran.r-project.org/web/packages/index.html);
`utils::available.packages(fields = NULL, repos = BiocManager::repositories())`
gives information about packages available from
[BioConductor](https://bioconductor.org/packages/release/BiocViews.html),
and
[`BiocManager::available()`](https://bioconductor.github.io/BiocManager/reference/available.html)
gives their names.

#### Documentation

The [reference manual](https://cran.r-project.org/manuals.html) is a
PDF-file with all the help files of the standard and recommended
packages. The manuals and help pages of all packages from CRAN can be
searched [online](https://cran.r-project.org/search.html), or from
within R using
[`utils::RSiteSearch()`](https://rdrr.io/r/utils/RSiteSearch.html). In
addition,
[`utils::help.search()`](https://rdrr.io/r/utils/help.search.html) can
be used to search the help system using fuzzy matching or regular
expressions, which can be disabled by setting argument `agrep` to
`FALSE` to search faster and return fewer results:
`utils::help.search(..., agrep = FALSE)`.

#### Dependencies

For (not necessarily installed) packages from CRAN, use
`tools::package_dependencies(packages = "<pkg>", recursive = TRUE)` to
see dependencies (i.e., which packages are required by package `<pkg>`)
and `tools::dependsOnPkgs(pkgs = "<pkg>", recursive = TRUE)` to see
reverse dependencies (i.e., which packages require package `<pkg>`).
`NULL` is returned for packages that are not found, whereas
`character(0)` is returned for packages that do not have any
dependencies. To see dependencies of packages from other repositories
(e.g., [GitHub](https://github.com/)), use package
[`pkgdepends`](https://r-lib.github.io/pkgdepends/):

``` r

library(pkgdepends)
prop <- pkgdepends::new_pkg_deps("<repos>/<pkg>")
prop$solve()
prop$get_solution()$data
prop$draw()
```

#### Source code

The source code of base R packages can be obtained from
[GitHub](https://github.com/r-devel/r-svn/) (see the section
[Repositories](#repositories) below), and installation pages of packages
on CRAN frequently contain links to GitHub pages where their source code
can be viewed.

### Already-installed packages

#### Available packages

The locations where R looks for installed packages can be obtained with
[`.libPaths()`](https://rdrr.io/r/base/libPaths.html). The names of all
installed packages can be obtained with
`.packages(all.available = TRUE)`. The location where a particular
package is installed can be obtained with
`find.package(package = "<pkg>", lib.loc = NULL, verbose = TRUE)`, using
`verbose = TRUE` to get a warning if a package is found more than once.

#### Documentation

[`library()`](https://rdrr.io/r/base/library.html) (without providing
the `package` or `help` arguments) and
[`utils::installed.packages()`](https://rdrr.io/r/utils/installed.packages.html)
give details on installed packages. Argument `fields` of the
[`utils::installed.packages()`](https://rdrr.io/r/utils/installed.packages.html)
can be used to specify additional fields to extract from the package
`DESCRIPTION`, for example
`fields = c("Repository", "Additional_repositories", "URL", "GithubRepo", "GithubUsername", "SystemRequirements")`.
The `Repository` and `URL` fields show the repository from which a
package was installed and are conveniently shown by
[`sessioninfo::session_info()`](https://sessioninfo.r-lib.org/reference/session_info.html),
which also has the option to show only information about selected
packages and their dependencies.

Information about a package and its functions is available from within R
after the package has been installed and
[attached](#loading-and-attaching-packages) (i.e., `library(<pkg>)` has
been run):

- Arguments of a function: `args("<func>")`.
- Citation for a package: `utils::citation("<pkg>")`, with
  [`utils::citation()`](https://rdrr.io/r/utils/citation.html) to cite R
  itself.
- Conflicts (i.e., if objects with the same name exist in two or more
  places on the search path):
  `base::conflicts(where = search(), detail = TRUE)`. See also the
  section `Conflicts` in
  [`help("conflictRules", package = "base")`](https://rdrr.io/r/base/library.html)
  and `conflicts_prefer(<pkg>::<func>)` from package
  [`conflicted`](https://CRAN.R-project.org/package=conflicted) to
  declare preferences.
- Functions, finding functions and other objects whose name contains a
  certain string: `utils::apropos("<string>")`.
- Functions, overview of all functions in a package:
  `ls(getNamespace("<pkg>"), all.names = TRUE)` returns a character
  vector with the function names (the default `all.names = FALSE`
  ignores names that start with a dot because those are for internal use
  in packages;
  [`help(package = "<pkg>")`](https://rdrr.io/pkg/%3Cpkg%3E/man) gives
  an overview with links to their help-pages if there is a file
  `<pkg>.R` in folder `<pkg>\R`.
- Help page of a function: `help("<func>")`; indicate the package to
  distinguish functions with the same name from different packages:
  `help("<func>", package = "<pkg>")`; use quotes around the name of an
  operator to get its help page:
  [`help("%in%")`](https://rdrr.io/r/base/match.html).
- Installation path of a package (i.e., where is a package installed):
  `find.package(package = "<pkg>", lib.loc = NULL, verbose = TRUE)`.
- Methods for a function: for a generic class:
  `utils::methods(class = "<class>")`; for a generic function:
  `utils::methods("<func>")`; for S3-methods:
  `attr(utils::methods(class = "<class>"), "info")`; for S4-methods:
  `methods::showMethods(classes = "<class>", where = getNamespace("<pkg>"))`.
- Version of a package that is currently used:
  `utils::packageVersion("<pkg>")`.
- Vignettes of a package: show them in a browser through
  `utils::browseVignettes(package = "<pkg>")`, or list them with
  `utils::vignette(package = "<pkg>")`.

### Which packages are used?

The function [`loadedNamespaces()`](https://rdrr.io/r/base/ns-load.html)
shows which packages are loaded. `getAnywhere(<func>)` shows in which
package a function is defined. To see which packages are used in a
script, looking for `::`, `:::`, `library`, `require`, and `namespace`
(e.g., [`loadNamespace()`](https://rdrr.io/r/base/ns-load.html),
[`requireNamespace()`](https://rdrr.io/r/base/ns-load.html)) will cover
most cases. However, various packages have their own way to create
dependencies on packages, see the overview at
[pak::scan_deps()](https://pak.r-lib.org/reference/scan_deps.html).

To see which packages are mentioned in comments, also look for:

- `conductor`: [Bioconductor](https://bioconductor.org/),
  [Neuroconductor](https://neuroconductor.org/)
- `CRAN`: [CRAN](https://cran.r-project.org/)
- `forge`: [R-Forge](https://r-forge.r-project.org/)
- `Git`: [GitHub](https://github.com/)
- `package` and `libraries`
- `rOpenSci`: [rOpenSci](https://ropensci.org/packages/)
- `verse`: [R-multiverse](https://r-multiverse.org/),
  [R-universe](https://r-universe.dev/packages),
  [tidyverse](https://tidyverse.org/packages/), etc

## Getting the source code

### Acknowledgements

Partly based on:

- Bryan J. 2015.
  [`Accessing R Source`](https://github.com/jennybc/access-r-source).
- Ligges U. 2006. `R help desk: accessing the sources`. [RNews
  6(4):43-45](https://journal.r-project.org/articles/RN-2006-035/).
- A [community answer](https://stackoverflow.com/a/19226817) from
  [StackOverflow](https://stackoverflow.com/).
- The help page for
  [`utils::methods()`](https://rdrr.io/r/utils/methods.html).

### Repositories

The source code of the base R packages is available at
[CRAN](https://cran.r-project.org/src/base/) and at the
[SVN-project](https://svn.r-project.org/R/branches/). Searching the
source code of the development version is easiest using the [GitHub
mirror](https://github.com/r-devel/r-svn/tree/main/src/library) of the
SVN-project, see also the documentation on
[`searching GitHub`](https://docs.github.com/en/search-github).

The source code of packages from
[CRAN](https://cran.r-project.org/web/packages/index.html) can be
searched at [METACRAN](https://github.com/cran), an **unofficial** CRAN
mirror. Alternatively, download the source file from section `Downloads`
of the CRAN page. The source files have been compressed into a `tar`
file so you have to extract the files (right-click on the downloaded
file and choose `extract all`).

The source code of packages from
[BioConductor](https://bioconductor.org/) in the current and
development-version is available
[here](https://code.bioconductor.org/search/).

The source code of packages from [GitHub](https://github.com/) can be
viewed directly on GitHub, or after downloading the code to your PC by
clicking the green `Code` button on the repository page (e.g.,
`https://github.com/JesseAlderliesten/checkrpkgs`), choosing
`Download ZIP`, and unzipping the downloaded file (right-click on the
file and choose `extract all`).

### Basic method

The simplest way to get the source code of a function is to type the
name of the function, **without** the brackets. For example, use `sd` to
see what happens when using [`sd()`](https://rdrr.io/r/stats/sd.html) to
calculate the standard deviation:

``` r

sd
#> function (x, na.rm = FALSE) 
#> sqrt(var(if (is.vector(x) || is.factor(x)) x else as.double(x), 
#>     na.rm = na.rm))
#> <bytecode: 0x5648b52f8378>
#> <environment: namespace:stats>
```

Some special cases:

- To distinguish functions with the same name from different packages,
  specify the package followed by two colons: `<pkg>::<func>`.
- For non-exported functions, specify the package followed by three
  colons: `<pkg>:::<func>` (using only two colons will result in the
  error `'<func>' is not an exported object from 'namespace:<pkg>'`; if
  that error appears when using three colons, you probably looked in the
  wrong package, use `getAnywhere(<func>)` to check in which package
  `<func>` is defined). Non-exported functions should **not** be used in
  code because they might change.
- For operators such as `%in%` (see
  [`help("%in%")`](https://rdrr.io/r/base/match.html) that start with a
  symbol, use backticks (\`) around the name:

``` r

`%in%`
#> function (x, table) 
#> match(x, table, nomatch = 0L) > 0L
#> <bytecode: 0x5648b10c2640>
#> <environment: namespace:base>
```

### getAnywhere

A more robust alternative to the [basic method](#basic-method) outlined
above is to use `getAnywhere("<func>")`, which looks in more places and
finds non-exported functions without the need to specify in which
package a function is defined. Although the quotes around the function
name are only required when looking for the source code of operators
that start with a symbol (e.g., `%in%`), it is most robust to always use
them.

#### UseMethod

If `getAnywhere("<func>")` returns `UseMethod("<func>")`, the function
has different methods for different object classes and is
[S3-generic](https://cran.r-project.org/doc/manuals/R-intro.html#Object-orientation).
First use `methods("<func>")` to get an overview of the available
methods; then use a particular method `"<method>"` from that overview
and use `getAnywhere("<method>")` to get the source code of that method.
The advantage over simply using `"<method>"` is that
`getAnywhere("<method>")` also works for functions that are not
exported, which is indicated in the overview of `methods(<func>)` by an
asterisk and the remark `Non-visible functions are asterisked`.

For example, the output of `getAnywhere("mean")` contains
`UseMethod("mean")`, indicating that `mean` is an S3-generic:

``` r

getAnywhere("mean")
#> A single object matching 'mean' was found
#> It was found in the following places
#>   package:base
#>   namespace:base
#> with value
#> 
#> function (x, ...) 
#> UseMethod("mean")
#> <bytecode: 0x5648b33ade00>
#> <environment: namespace:base>
```

First use `methods("mean")` to get an overview of the available methods:

``` r

methods("mean")
#> [1] mean.Date     mean.default  mean.difftime mean.POSIXct  mean.POSIXlt 
#> [6] mean.quosure*
#> see '?methods' for accessing help and source code
```

The output shows, among others, the methods `mean.Date` and
`mean.default`. You can use `getAnywhere("mean.Date")` to see the source
code of the method `mean` used with objects of class `Date`.

``` r

getAnywhere("mean.Date")
#> A single object matching 'mean.Date' was found
#> It was found in the following places
#>   package:base
#>   registered S3 method for mean from namespace base
#>   namespace:base
#> with value
#> 
#> function (x, ...) 
#> .Date(mean(unclass(x), ...))
#> <bytecode: 0x5648b4e458e0>
#> <environment: namespace:base>
```

You can also use `getAnywhere("mean.default")` to see the source code of
the method `mean` used with objects of classes not listed in the output
of `methods("mean")`:

``` r

getAnywhere("mean.default")
#> A single object matching 'mean.default' was found
#> It was found in the following places
#>   package:base
#>   registered S3 method for mean from namespace base
#>   namespace:base
#> with value
#> 
#> function (x, trim = 0, na.rm = FALSE, ...) 
#> {
#>     if (!is.numeric(x) && !is.complex(x) && !is.logical(x)) {
#>         warning("argument is not numeric or logical: returning NA")
#>         return(NA_real_)
#>     }
#>     if (isTRUE(na.rm)) 
#>         x <- x[!is.na(x)]
#>     if (!is.numeric(trim) || length(trim) != 1L) 
#>         stop("'trim' must be numeric of length one")
#>     n <- length(x)
#>     if (trim > 0 && n) {
#>         if (is.complex(x)) 
#>             stop("trimmed means are not defined for complex data")
#>         if (anyNA(x)) 
#>             return(NA_real_)
#>         if (trim >= 0.5) 
#>             return(stats::median(x, na.rm = FALSE))
#>         lo <- floor(n * trim) + 1
#>         hi <- n + 1 - lo
#>         x <- sort.int(x, partial = unique(c(lo, hi)))[lo:hi]
#>     }
#>     .Internal(mean(x))
#> }
#> <bytecode: 0x5648b4e48d00>
#> <environment: namespace:base>
```

#### standardGeneric

If `getAnywhere("<func>")` returns `standardGeneric("<func>")`, the
function has different S4-methods for different object classes (see
[`help("Introduction", package = "methods")`](https://rdrr.io/r/methods/Introduction.html)).
Use `showMethods("<func>")` to get an overview of the available methods
in all [attached](#loading-and-attaching-packages) packages, or use
`<pkg>:::<func>` to get an overview of the available methods from
package `<pkg>`. Finally, provide the function name as argument `f` and
the selected method as a character vector to argument `signature` (see
also
[`help("signature")`](https://rdrr.io/r/methods/GenericFunctions.html))
of function [`getMethod()`](https://rdrr.io/r/methods/getMethod.html) to
get the source code of a particular method:
`getMethod(f = "<func>", signature = c(target = "<class>", current = "<class>"))`.

The example below shows how to find the source code of method
[`cbind2()`](https://rdrr.io/r/methods/cbind2.html) used by the `Matrix`
package to combine two matrices that both have the `Matrix` class as
defined by package `Matrix`.

``` r

# Need to attach and load package 'Matrix' for this example to work
if(requireNamespace("Matrix")) {
  library(Matrix)
  getAnywhere("cbind2")
}
#> Loading required namespace: Matrix
#> A single object matching 'cbind2' was found
#> It was found in the following places
#>   package:Matrix
#>   package:methods
#>   namespace:methods
#> with value
#> 
#> new("standardGeneric", .Data = function (x, y, ...) 
#> standardGeneric("cbind2"), generic = "cbind2", package = "methods", 
#>     group = list(), valueClass = character(0), signature = c("x", 
#>     "y"), default = NULL, skeleton = (function (x, y, ...) 
#>     stop(gettextf("invalid call in method dispatch to '%s' (no default method)", 
#>         "cbind2"), domain = NA))(x, y, ...))
#> <bytecode: 0x5648b2d56c40>
#> <environment: 0x5648b19ef918>
#> attr(,"generic")
#> [1] "cbind2"
#> attr(,"generic")attr(,"package")
#> [1] "methods"
#> attr(,"package")
#> [1] "methods"
#> attr(,"group")
#> list()
#> attr(,"valueClass")
#> character(0)
#> attr(,"signature")
#> [1] "x" "y"
#> attr(,"default")
#> `\001NULL\001`
#> attr(,"skeleton")
#> (function (x, y, ...) 
#> stop(gettextf("invalid call in method dispatch to '%s' (no default method)", 
#>     "cbind2"), domain = NA))(x, y, ...)
#> attr(,"class")
#> [1] "standardGeneric"
#> attr(,"class")attr(,"package")
#> [1] "methods"
```

`standardGeneric("cbind2")` indicates that
[`cbind2()`](https://rdrr.io/r/methods/cbind2.html) is an S4 function,
so use `showMethods("cbind2")` to get an overview of the different
methods:

``` r

if(requireNamespace("Matrix")) {
  library(Matrix)
  showMethods("cbind2")
}
#> Function: cbind2 (package methods)
#> x="ANY", y="ANY"
#> x="ANY", y="missing"
#> x="matrix", y="Matrix"
#> x="Matrix", y="matrix"
#> x="Matrix", y="Matrix"
#> x="Matrix", y="missing"
#> x="Matrix", y="NULL"
#> x="Matrix", y="vector"
#> x="NULL", y="Matrix"
#> x="vector", y="Matrix"
```

Then choose one of the returned methods. For example, to get the source
code of `cbind2` used with two matrices that both have the `Matrix`
class defined by package `Matrix`:

``` r

if(requireNamespace("Matrix")) {
  library(Matrix)
  getMethod(f = "cbind2", signature = c(x = "Matrix", y = "Matrix"))
}
#> Method Definition:
#> 
#> function (x, y, ...) 
#> cbind.Matrix(x, y, deparse.level = 0L)
#> <bytecode: 0x5648b4c43bb8>
#> <environment: namespace:Matrix>
#> 
#> Signatures:
#>         x        y       
#> target  "Matrix" "Matrix"
#> defined "Matrix" "Matrix"
```

#### .Internal or .Primitive

If `getAnywhere("<func>")` returns `.Internal` or `.Primitive`, the
function is internal or primitive (see
[`help(".internalGenerics")`](https://rdrr.io/r/base/InternalMethods.html)
and `help(".Primitive()")`). The source code of such functions can be
viewed at code [repositories](#repositories), or on your PC if you have
installed R [from source](https://cran.r-project.org/sources.html) using
Rtools (see the section `Rtools` in the vignette *Installing R, Rtools
and RStudio*:
[`vignette("install_r", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/install_r.md)).

Locate the file `src/main/names.c` and look in the first column
(`printname`) for the name of the R function to find the appropriate
c-entry which is given in the second column of that file. Then either
search for that c-entry using the GitHub search, or manually locate the
c-file (the name of the file is the c-entry without the prefix `do_`) in
`src/main` to get the file with the source code.

For example, `getAnywhere("matrix")` shows, among others, the line  
`.Internal(matrix(data, nrow, ncol, byrow, dimnames, missing(nrow), missing(ncol)))`.
The file
[`src/main/names.c`](https://github.com/r-devel/r-svn/blob/main/src/main/names.c)
has as entry with `matrix` in the first column:  
`{"matrix", do_matrix, 0, 11, 7, {PP_FUNCALL, PREC_FN, 0}}`. Searching
`src/main` for `matrix` gives file
[`array.c`](https://github.com/r-devel/r-svn/blob/main/src/main/array.c)
as one of the results. That file contains the source code of `matrix`.
Similarly, `getAnywhere("log10")` shows
`function (x) .Primitive("log10")`. The file
[`src/main/names.c`](https://github.com/r-devel/r-svn/blob/main/src/main/names.c)
has as entry with `log10` in the first column:  
`{"log10", do_log1arg, 10, 1, 1, {PP_FUNCALL, PREC_FN, 0}}`. Searching
`src/main` for `log1arg` gives file
[`arithmetic.c`](https://github.com/r-devel/r-svn/blob/main/src/main/arithmetic.c)
as one of its results. That file contains the source code of `log10`.

Sometimes an R function is defined in a file that defines multiple
functions and thus has a general name. Then the file with c-code will
have a similar general name. For example, the source code of
[`make.names()`](https://rdrr.io/r/base/make.names.html) is defined in
`src/library/base/R/character.R` which, among others, contains the code
`.Internal(make.names(names, allow_))`, and the c-code for
`do_makenames()` is in file `src/main/character.c`.

#### .Call

If `getAnywhere("<func>")` returns code that contains `.Call(...)`, the
function contains a call to C or C++ code. Although the file
`src/<pkg>.h` (e.g.,
[src/methods.h](https://github.com/r-devel/r-svn/blob/main/src/library/methods/src/methods.h)
if code is from package `methods`) contains an overview of the C or C++
code included in a package, your best bet for finding the source code is
[searching](https://docs.github.com/en/search-github) the relevant part
of the [GitHub](https://github.com/r-devel/r-svn/) repository (e.g.,
`https://github.com/r-devel/r-svn/tree/main/src/library/methods/src` for
code from package `methods`), or installing the package from source (see
the section `Rtools` in the vignette *Installing R, Rtools and RStudio*:
[`vignette("install_r", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/install_r.md))
and searching in the `src` folder of the downloaded code.

## Documentation and help

### Installing and managing packages

- [Documentation](https://docs.r-universe.dev/install.html) from the
  [R-universe](https://r-universe.dev/search)
- [Instructions](https://bioconductor.org/install/) on installing
  [BioConductor](https://bioconductor.org/packages/release/BiocViews.html)
  packages
- Section
  [`Add-on packages`](https://cran.r-project.org/doc/manuals/R-admin.html#Add_002don-packages)
  in the
  [`R Installation and Administration manual`](https://cran.r-project.org/doc/manuals/r-release/R-admin.html)
  manual
- Section [Troubleshooting](#troubleshooting) above

### Package status

- [Check
  results](https://docs.r-universe.dev/bioconductor/#check-results) from
  BioConductor.

### Source code

- Bryan J. 2015.
  [`Accessing R Source`](https://github.com/jennybc/access-r-source).
- Ligges U. 2006. `R help desk: accessing the sources`. [RNews
  6(4):43-45](https://journal.r-project.org/articles/RN-2006-035/).
- A [community answer](https://stackoverflow.com/a/19226817) from
  [StackOverflow](https://stackoverflow.com/).
- The help page for
  [`utils::methods()`](https://rdrr.io/r/utils/methods.html).

### Miscellaneous

- The book
  [`What They Forgot to Teach You About R`](https://rstats.wtf/) by J.
  Bryan, J. Hester, S. Pileggi, and E. D. Aja
- Section `Documentation and help` in the vignette *Installing R, Rtools
  and RStudio*:  
  [`vignette("install_r", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/install_r.md)
- Search engines specific for R: [METACRAN](https://r-pkg.org/),
  [r-project](https://search.r-project.org/),
  [Rseek](https://www.rseek.org/),
  [R-universe](https://r-universe.dev/search)
