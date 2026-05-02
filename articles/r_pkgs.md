# Instructions about R packages

## Introduction and notation

This vignette contains information on installing and getting information
about R packages. It also explains how to obtain the source code of R
functions.

In this vignette, text between angled brackets (`<...>`) is used to
refer to text that should be replaced with specific text to get working
code or working file paths. For example, `<pkgname>` is used as a place
holder to refer to a package name and should be replaced with `utils` if
you want to obtain information about package `utils`, and with `methods`
if you want to obtain information about package `methods`. Similarly,
`<funcname>` is used as a place holder to refer to a function name that
should be filled in with a specific function name to get working code.

In this vignette, calls to functions are frequently written in the form
`<pkgname>::<funcname>()`, to make clear which package is used and,
through the brackets, that a function is indicated. In normal code, one
would use `library(<pkgname>)` followed by `<funcname>()`. For example,
in this vignette the notation
[`utils::citation()`](https://rdrr.io/r/utils/citation.html) is used to
show how to cite R, indicating that the function `citation` is defined
in package `utils`. In normal code, one would use
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
obtained from several websites, called ‘repositories’ (see below). After
installing a package, you need to run
[library](https://jessealderliesten.github.io/checkrpkgs/help/library)`(<pkgname>)`
to be able to use the functions of that package.

#### CRAN

The [Comprehensive R Archive Network](https://cran.r-project.org/)
(CRAN) is the main repository of R
[packages](https://cran.r-project.org/web/packages/index.html). The
following code can be used to install packages from CRAN:

``` r
pkgs_new <- c(<pkgname>, <pkgname>)
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
[ctv](https://CRAN.R-project.org/package=ctv) and run
`ctv::install.views("<taskviewname>", coreOnly = TRUE)`. To update these
packages, use `ctv::update.views("<taskviewname>", coreOnly = TRUE)`.

Packages from CRAN that have been recently archived are available at
[CRANhaven](https://www.cranhaven.org/).

#### BioConductor

The [Bioconductor](https://bioconductor.org/) repository releases
versions that contain specific versions of packages from
[CRAN](https://cran.r-project.org/web/packages/index.html) and
[BioConductor](https://bioconductor.org/packages/release/BiocViews.html)
that are consistent with each other and with a [specific
version](https://bioconductor.org/about/release-announcements/) of R,
preventing version conflicts between R packages.

The following code can be used to install packages from BioConductor
release [version](https://bioconductor.org/about/release-announcements/)
3.23. This code installs the
[BiocManager](https://CRAN.R-project.org/package=BiocManager) package
from [CRAN](https://cran.r-project.org/) that is then used to install
packages from `Bioconductor` and `CRAN` and, through
[`remotes::install_github()`](https://remotes.r-lib.org/reference/install_github.html)
(see the next [section](#github)), from `GitHub`:

``` r
pkgs_new <- c(<pkgname>, <pkgname>)
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

#### Github

The following code can be used to install packages from
[GitHub](https://github.com/): it installs the
[remotes](https://CRAN.R-project.org/package=remotes) package that is
needed to install packages from GitHub. If installing packages fails,
trying with arguments `force = TRUE` to re-install possibly broken
dependencies and `build_vignettes = FALSE` to not install vignettes
might help.

`grep(pattern = "/", x = pkgs_new, value = TRUE)` selects the elements
of `pkgs_new` which contain a slash because
[`remotes::install_github()`](https://remotes.r-lib.org/reference/install_github.html)
only works if each element of `pkgs` contains the author name and
repository name (e.g., `"JesseAlderliesten/checkrpkgs"`) or the full URL
to a package (e.g.,
`"https://github.com/JesseAlderliesten/checkrpkgs"`). To match names in
such formats to package names returned by
[`utils::installed.packages()`](https://rdrr.io/r/utils/installed.packages.html),
use `basename(pkgs_new)` instead of `pkgs_new` to select the last part
of the name (e.g., `"checkrpkgs"` instead of
`"JesseAlderliesten/checkrpkgs"`):
`pkgs[!(basename(pkgs) %in% installed.packages()[, "Package"])]`.

``` r

pkgs_new <- c("JesseAlderliesten/checkrpkgs",
              "https://github.com/JesseAlderliesten/progutils")
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

#### Other repositories, mirrors

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
  [overview](https://r-universe.dev/datasets) of
  [datasets](https://jessealderliesten.github.io/checkrpkgs/help/data)
  included in R packages

The websites of these repositories include instructions how to install
packages from them, and repositories can be selected using
[utils::setRepositories()](https://jessealderliesten.github.io/checkrpkgs/help/setRepositories).
The following code shows how to install packages from
[R-Forge](https://r-forge.r-project.org/) as an example:

``` r
pkgs_new <- c(<pkgname>, <pkgname>)
# Select packages that are currently not installed or not functional
pkgs_install <- pkgs_new[!vapply(X = pkgs_new, FUN = requireNamespace,
                                 FUN.VALUE = logical(1), quietly = TRUE)]
if(length(pkgs_install) > 0L) {
  install.packages(pkgs = pkgs_install, lib = .libPaths(),
                   repos = "https://r-forge.r-project.org/", dependencies = NA,
                   type = getOption("pkgType"), verbose = getOption("verbose"),
                   quiet = FALSE)
}
```

Mirror websites (mirrors) are websites hosted in various parts of the
world with the same content as the main website. Using a nearby mirror
allows for faster downloads. Mirrors of repositories can be selected
using
[utils::setRepositories()](https://jessealderliesten.github.io/checkrpkgs/help/setRepositories).

CRAN [mirrors](https://cran.r-project.org/mirrors.html), with
information about their
[status](https://cran.r-project.org/mirmon_report.html) that is also
available from within R through
[utils::getCRANmirrors()](https://jessealderliesten.github.io/checkrpkgs/help/getCRANmirrors),
can be selected using
[utils::chooseCRANmirror()](https://jessealderliesten.github.io/checkrpkgs/help/chooseCRANmirror).
However, RStudio
[uses](https://docs.posit.co/ide/user/ide/guide/environments/r/packages.html#primary-repository)
the [RStudio CRAN mirror](https://cran.rstudio.com) with its own global
distribution, see
[getOption(“repos”)](https://jessealderliesten.github.io/checkrpkgs/help/getOption).

Bioconductor [mirrors](https://bioconductor.org/about/mirrors/), with
information about their
[status](https://bioconductor.org/dashboard/#mirror_status), can be
selected using
[BiocManager::repositories()](https://jessealderliesten.github.io/checkrpkgs/help/repositories)
or
[chooseBioCmirror()](https://jessealderliesten.github.io/checkrpkgs/help/chooseBioCmirror).
In RStudio, the RStudio CRAN mirror is used (see above), which is
signalled by the message
`'getOption("repos")' replaces Bioconductor standard repositories, see 'help("repositories", package = "BiocManager")' for details`.

### Updating packages

Updating out-of-date packages prevents compatibility issues between
already-installed and newly-installed packages.

#### CRAN

For R packages from CRAN, versions can be compared using
[diffify](https://diffify.com/R) and a chronological overview of changes
is available at
[CRANberries](https://dirk.eddelbuettel.com/cranberries/). To get the
version number of an installed package, run
[utils::packageVersion](https://jessealderliesten.github.io/checkrpkgs/help/packageVersion)`("<pkgname>")`.

The following code can be used to install the latest version of packages
from [CRAN](https://cran.r-project.org/web/packages/index.html) (but
note this **changes** the version of already-installed packages, which
might be undesirable):

``` r

utils::update.packages(lib.loc = .libPaths(), ask = TRUE, dependencies = NA,
                       verbose = getOption("verbose"), quiet = FALSE,
                       checkBuilt = TRUE, type = getOption("pkgType"))
```

#### Bioconductor

The following code can be used to update packages to a specific
BioConductor release (here version 3.23):

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
build the packages from source, see the section ‘Rtools’ in the vignette
*Installing R, Rtools and RStudio*:
[`vignette("install_r", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/install_r.md).

#### CRAN

The following code can be used to install an old version of a package
from CRAN, using package
[remotes](https://CRAN.R-project.org/package=remotes):

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
`Downloads` \> `Old sources` \> `<pkgname> archive` and find the
appropriate URL pointing to an older version to install it using base R.
For example, to install version 1.40 of package
[deSolve](https://CRAN.R-project.org/package=deSolve):

``` r

install.packages(pkgs = "https://cran.r-project.org/src/contrib/Archive/deSolve/deSolve_1.40.tar.gz",
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
version of bioConductor, see the
[overview](https://bioconductor.org/about/release-announcements/) of
Bioconductor versions with the corresponding R version. Information on
these older packages can be found by visiting the appropriate version of
Bioconductor, e.g.,
`https://bioconductor.org/packages/3.22/BiocViews.html`.

### Troubleshooting

#### Installing packages

- If the warnings `lib = <pkgname> is not writeable` or
  `'lib' element <element from .libPaths()> is not a writable directory`
  occur, you probably forgot to run R (or RStudio) as administrator.
  Close R (RStudio), right-click on the R or RStudio icon and select
  `Run as administrator` to start it as administrator.

- If the question
  `Do you want to install from sources the packages which need compilation?`
  is asked (in a new window), accompanied by the remark
  `There are binary versions available but the source versions are later`
  and an overview in the console of the binary and source versions
  indicating if these need compilation, you should choose `No` if you
  have *not* installed
  [Rtools](https://cran.r-project.org/bin/windows/Rtools/): you will
  then get slightly less up to date package versions but a faster
  installation.

  If you want the latest version without using Rtools, you can try again
  a few days later: it usually takes a bit longer for the binaries
  (i.e., the package versions that do not have to be build from source)
  from CRAN and Bioconductor to be updated than for the source versions
  used by Rtools.

  If you have installed Rtools you can choose `Yes` to install the
  latest package versions by building them from source. To install
  Rtools, see the section ‘Rtools’ in the vignette *Installing R, Rtools
  and RStudio*:
  [`vignette("install_r", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/install_r.md).

- The warning
  `package '<pkgname>' is not available (for R version x.y.z)` can have
  many reasons. First double-check the package name (which is
  case-sensitive). Then check possible other reasons mentioned in this
  [stackoverflow answer](https://stackoverflow.com/a/25721890/32365738).

- If installing packages fails, try with arguments `force = TRUE` to
  re-install possibly broken dependencies and `build_vignettes = FALSE`
  to not install vignettes.

#### Using packages

- If a package appears not to be installed when you want to use a
  function from it (e.g., you get the error
  `could not find function "<funcname>"`), remember you need to run
  [library](https://jessealderliesten.github.io/checkrpkgs/help/library)`(<pkgname>)`
  to be able to use its functions.

- If a package is not functional, re-install it using argument
  `force = TRUE` to re-install possibly broken dependencies. You can
  also use
  [checkrpkgs::get_details_pkgs](https://jessealderliesten.github.io/checkrpkgs/help/get_details_pkgs)`(pkgs = <pkgname>)`
  to check which dependencies and other system requirements it has and
  then use
  [checkrpkgs::check_pkgs](https://jessealderliesten.github.io/checkrpkgs/help/check_pkgs)`(pkgs = <pkgnames>)`
  to check if all the dependencies are installed and functional.

- If the warning `package <pkgname> was built under R version 'x.y.z'`
  occurs, you installed a binary package (i.e., not by building from
  source) that was prepared (‘compiled’) for an earlier version of R
  than the version of R you are currently using (run
  [getRversion()](https://jessealderliesten.github.io/checkrpkgs/help/R.Version)
  to see your current R version). The warning is issued because packages
  are not tested on versions of R that are older than the version they
  were built on. Therefore it is best to update R when installing
  packages.

- If errors occur when loading packages that require Java, make sure the
  64-bit [version of Java](https://www.java.com/download/manual.jsp) is
  installed on 64-bit PCs.

## Information about packages

Information about packages can be obtained from the internet before the
packages are installed, as well as from within R after the packages are
installed.

### Not-yet-installed packages

The [reference manual](https://cran.r-project.org/manuals.html) is a
PDF-file with all the help files of the standard and recommended
packages. The manuals and help pages of all packages from CRAN can be
searched [online](https://cran.r-project.org/search.html), or from
within R using
[utils::RSiteSearch()](https://jessealderliesten.github.io/checkrpkgs/help/RSiteSearch).
In addition,
[utils::help.search()](https://jessealderliesten.github.io/checkrpkgs/help/help.search)
can be used to search the help system using fuzzy matching or regular
expressions, which can be disabled by setting argument `agrep` to
`FALSE` to search faster and return fewer results:
`utils::help.search(..., agrep = FALSE)`.

[tools::CRAN_package_db()](https://jessealderliesten.github.io/checkrpkgs/help/CRAN_package_db)
gives information about packages available from
[CRAN](https://cran.r-project.org/web/packages/index.html);
[`BiocManager::available()`](https://bioconductor.github.io/BiocManager/reference/available.html)
gives the names of packages available from
[BioConductor](https://bioconductor.org/packages/release/BiocViews.html).

The source code of base R packages can be obtained from
[GitHub](https://github.com/r-devel/r-svn/) (see the section
[Repositories](#repositories) below), and installation pages of packages
on CRAN frequently contain links to GitHub pages where their source code
can be viewed.

For (not necessarily installed) packages from CRAN, use
[tools::package_dependencies](https://jessealderliesten.github.io/checkrpkgs/help/package_dependencies)`(packages = "<pkgname>", recursive = TRUE)`
to see dependencies (i.e., which packages are required by package
`<pkgname>`) and
[tools::dependsOnPkgs](https://jessealderliesten.github.io/checkrpkgs/help/dependsOnPkgs)`(pkgs = "<pkgname>", recursive = TRUE)`
to see reverse dependencies (i.e., which packages require package
`<pkgname>`). `NULL` is returned for packages that are not found,
whereas `character(0)` is returned for packages that do not have any
dependencies.

### Already-installed packages

The locations where R installs packages, and where it looks for
installed packages, can be obtained with
[.libPaths()](https://jessealderliesten.github.io/checkrpkgs/help/.libPaths),
and the names of all installed packages can be obtained with
[list.files](https://jessealderliesten.github.io/checkrpkgs/help/list.files)`(path = .libPaths(), recursive = FALSE)`.
The repository from which a package was installed can be obtained from
the `Repository` and `URL` fields of package descriptions:
[checkrpkgs::get_details_pkgs](https://jessealderliesten.github.io/checkrpkgs/help/get_details_pkgs)`(pkgs = <pkgname>)`.
The output of
[`checkrpkgs::get_details_pkgs()`](https://jessealderliesten.github.io/checkrpkgs/reference/get_details_pkgs.md)
can be used to re-install packages after installing a new version of R.

Information about a package and its functions is available from within R
after the package has been installed and loaded (i.e.,
[library](https://jessealderliesten.github.io/checkrpkgs/help/library)`(<pkgname>)`
has been run):

- Citation:
  [utils::citation](https://jessealderliesten.github.io/checkrpkgs/help/citation)`("<pkgname>")`,
  with [`utils::citation()`](https://rdrr.io/r/utils/citation.html) to
  cite R itself.
- Function overview: `ls(getNamespace("<pkgname>"))` returns a character
  vector with the function names (ignoring names that start with a dot,
  which by convention are for internal use in packages;
  `ls(getNamespace("<pkgname>"), all.names = TRUE)` includes those
  function names in the returned character vector);
  [`help(package = "<pkgname>")`](https://rdrr.io/pkg/%3Cpkgname%3E/man)
  gives an overview with links to their help-pages if there is a file
  `<pkgname>.R` in folder `<pgkname>\R`.
- Help page: `help(topic = "<pkgname>")`.
- Version:
  [utils::packageVersion](https://jessealderliesten.github.io/checkrpkgs/help/packageVersion)`("<pkgname>")`.
- Vignettes: show them in a browser through
  [utils::browseVignettes](https://jessealderliesten.github.io/checkrpkgs/help/browseVignettes)`(package = "<pkgname>")`
  or list them with
  [utils::vignette](https://jessealderliesten.github.io/checkrpkgs/help/vignette)`(package = "<pkgname>")`.

Information about functions, methods, and classes can also be obtained
(see also the section [Getting the source
code](#getting-the-source-code) below):

- Arguments: `args("<funcname>")`.
- Help page: `help("<funcname>")`; indicate the package to distinguish
  functions with the same name from different packages:
  `help("<funcname>", package = "<pkgname>")`; use quotes around the
  name of an operator to get its help page:
  [`help("%in%")`](https://rdrr.io/r/base/match.html).
- Methods: for a generic class:
  [utils::methods](https://jessealderliesten.github.io/checkrpkgs/help/methods)`(class = "<classname>")`;
  for a generic function:
  [utils::methods](https://jessealderliesten.github.io/checkrpkgs/help/methods)`("<funcname>")`;
  for S3-methods: `attr(utils::methods(class = "<classname>"), "info")`;
  for S4-methods:
  `methods::showMethods(classes = "<classname>", where = getNamespace("<pkgname>"))`.
- Objects (including functions) whose name contains a certain string:
  [utils::apropos](https://jessealderliesten.github.io/checkrpkgs/help/apropos)`("<string>")`.

### Which packages are used?

The function
[loadedNamespaces()](https://jessealderliesten.github.io/checkrpkgs/help/loadedNamespaces)
shows which packages are loaded. To see which packages are used in a
script, look for `::`, `:::`,
[library](https://jessealderliesten.github.io/checkrpkgs/help/library),
[require](https://jessealderliesten.github.io/checkrpkgs/help/require),
and `namespace` (e.g.,
[loadNamespace](https://jessealderliesten.github.io/checkrpkgs/help/loadNamespace),
[requireNamespace()](https://jessealderliesten.github.io/checkrpkgs/help/requireNamespace)).
Various packages have their own way to create dependencies on packages,
see the overview at
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

- Bryan J. 2015. [Accessing R
  Source](https://github.com/jennybc/access-r-source).
- Ligges U. 2006. Accessing the sources. [RNews
  6(4):43-45](https://journal.r-project.org/articles/RN-2006-035/).
- A [community answer](https://stackoverflow.com/a/19226817) from
  [StackOverflow](https://stackoverflow.com/).
- The help page for
  [utils::methods()](https://jessealderliesten.github.io/checkrpkgs/help/methods).

### Repositories

The source code of the base R packages, for the development, current,
and older versions of R, is available at
[CRAN](https://cran.r-project.org/src/base/) and at the
[SVN-project](https://svn.r-project.org/R/branches/). Searching the
source code of the development version is easiest using the [GitHub
mirror](https://github.com/r-devel/r-svn/tree/main/src/library) of the
SVN-project, see also the documentation on [searching
GitHub](https://docs.github.com/en/search-github).

The source code of add-on packages from
[CRAN](https://cran.r-project.org/web/packages/index.html) can be
searched at [METACRAN](https://github.com/cran), an *unofficial* CRAN
mirror. Alternatively, download the source file from section `Downloads`
of the CRAN page. The source files have been compressed into a `tar`
file so you have to extract the files (right-click on the downloaded
file and choose `extract all`).

The source code of add-on packages from
[BioConductor](https://bioconductor.org/) in the current version or in
the development-version is available
[here](https://code.bioconductor.org/search/).

The source code of add-on packages from [GitHub](https://github.com/)
can be viewed directly on GitHub, or after downloading the code to your
computer by clicking the green `Code` button on the repository page
(e.g., `https://github.com/JesseAlderliesten/checkrpkgs`), choosing
`Download ZIP`, and unzipping the downloaded file (right-click on the
file and choose `extract all`).

### Basic method

The simplest way to obtain the source code of a function is to type the
name of the function, *without* the brackets, and press `Enter`. For
example, to see what happens when using
[sd](https://jessealderliesten.github.io/checkrpkgs/help/sd) to
calculate the standard deviation:

``` r

sd
#> function (x, na.rm = FALSE) 
#> sqrt(var(if (is.vector(x) || is.factor(x)) x else as.double(x), 
#>     na.rm = na.rm))
#> <bytecode: 0x559b48d7c998>
#> <environment: namespace:stats>
```

Some special cases:

- To distinguish functions with the same name from different packages,
  specify the package followed by two colons: `<pkgname>::<funcname>`.
- For non-exported functions, specify the package followed by three
  colons: `<pkgname>:::<funcname>` (using only two colons, will result
  in the error
  `'<funcname>' is not an exported object from 'namespace:<pkgname>'`.
  Non-exported functions should *not* be used in code because they might
  change.
- For operators such as
  [%in%](https://jessealderliesten.github.io/checkrpkgs/help/match)
  which start with a symbol, use backticks (\`) around the name:

``` r

`%in%`
#> function (x, table) 
#> match(x, table, nomatch = 0L) > 0L
#> <bytecode: 0x559b470e55c0>
#> <environment: namespace:base>
```

### getAnywhere

A more robust alternative to the [basic method](#basic-method) outlined
above is to use
[getAnywhere](https://jessealderliesten.github.io/checkrpkgs/help/getAnywhere)`("<funcname>")`,
which looks in more places and finds internal functions without the need
to specify in which package a function is defined. Although the quotes
around the function name are not necessary when looking for the source
code of normal functions, they are required when looking for the source
code of operators such as
[%in%](https://jessealderliesten.github.io/checkrpkgs/help/match), such
that it is most robust to always use them.

#### UseMethod

If `getAnywhere("<funcname>")` returns `UseMethod("<funcname>")`, the
function has different methods for different object classes and is
[S3-generic](https://cran.r-project.org/doc/manuals/R-intro.html#Object-orientation).
First use
[methods](https://jessealderliesten.github.io/checkrpkgs/help/methods)`("<funcname>")`
to get an overview of the available methods; then obtain the source code
of a particular method by using `getAnywhere("<function.class>")`, where
`<function.class>` is an item from the overview that was returned by
`methods("<funcname>")`. The advantage over simply using
`"<function.class>"` is that `getAnywhere("<function.class>")` also
works for functions that are not exported, which is indicated in the
overview of `methods(<funcname>)` by an asterisk and the remark
`Non-visible functions are asterisked`.

For example, `UseMethod("mean")` in the output of `getAnywhere("mean")`
indicates `mean` is an S3-generic:

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
#> <bytecode: 0x559b493baa68>
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
`mean.default`. Then use `getAnywhere("mean.Date")` to see the source
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
#> <bytecode: 0x559b4b248fc8>
#> <environment: namespace:base>
```

Or use `getAnywhere("mean.default")` to see the source code of the
method `mean` used with objects of classes not listed in the output of
`methods("mean")`:

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
#> <bytecode: 0x559b4b2485b8>
#> <environment: namespace:base>
```

#### standardGeneric

If `getAnywhere("<funcname>")` returns `standardGeneric("<funcname>")`,
the function has different S4-methods (see
[`help(topic = "Introduction", package = "methods")`](https://rdrr.io/r/methods/Introduction.html))
for different object classes. Use
[showMethods](https://jessealderliesten.github.io/checkrpkgs/help/showMethods)`("<funcname>")`
to get an overview of the available methods in all *loaded* packages, or
use `<pkgname>:::<funcname>` to get an overview of the available methods
from package `<pkgname>`. Finally, provide the function name as argument
`f` and the selected method as a character vector to argument
[signature](https://jessealderliesten.github.io/checkrpkgs/help/signature)
of function
[getMethod()](https://jessealderliesten.github.io/checkrpkgs/help/getMethod)
to obtain the source code of a particular method:
`getMethod(f = "<funcname>", signature = c(target = "<classname>", current = "<classname>"))`.

The example below shows how to find the source code of method
[`cbind2()`](https://rdrr.io/r/methods/cbind2.html) used by the `Matrix`
package to combine two matrices that both have the `Matrix` class as
defined by package `Matrix`.

``` r

library(Matrix)
getAnywhere("cbind2")
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
#> <bytecode: 0x559b48c260f8>
#> <environment: 0x559b47a127f8>
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

# standardGeneric("cbind2") indicating that cbind2() is an S4 function, so use
# showMethods("cbind2") to get an overview of the different methods:
showMethods("cbind2")
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

# To get the source code of 'cbind2' used with two matrices that both have the
# 'Matrix' class defined by package 'Matrix'
getMethod(f = "cbind2", signature = c(x = "Matrix", y = "Matrix"))
#> Method Definition:
#> 
#> function (x, y, ...) 
#> cbind.Matrix(x, y, deparse.level = 0L)
#> <bytecode: 0x559b4aa1e570>
#> <environment: namespace:Matrix>
#> 
#> Signatures:
#>         x        y       
#> target  "Matrix" "Matrix"
#> defined "Matrix" "Matrix"
```

#### .Internal or .Primitive

If `getAnywhere("<funcname>")` returns `.Internal` or `.Primitive`, the
function is internal or primitive. The source code of such functions can
be viewed at code [repositories](#repositories), or on your computer if
you have installed R [from
source](https://cran.r-project.org/sources.html) using Rtools (see the
section ‘Rtools’ in the vignette *Installing R, Rtools and RStudio*:
[`vignette("install_r", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/install_r.md)).

Locate the file `src/main/names.c` and look in the first column for the
name of the R function to find the appropriate c-entry which is given in
the second column of that file. Then either search for that c-entry
using the GitHub search, or manually locate the c-file (the name of the
file is the c-entry without the prefix `do_`) in `src/main` to get the
file with the source code.

For example, `getAnywhere("matrix")` shows, among others, the line
`.Internal(matrix(data, nrow, ncol, byrow, dimnames, missing(nrow), missing(ncol)))`.
The file
[src/main/names.c](https://github.com/r-devel/r-svn/blob/main/src/main/names.c)
has as entry with `matrix` in the first column:
`{"matrix", do_matrix, 0, 11, 7, {PP_FUNCALL, PREC_FN, 0}}` Searching
`src/main` for `matrix` gives file
[array.c](https://github.com/r-devel/r-svn/blob/main/src/main/array.c)
as one of the results. That file contains the source code of `matrix`.
Similarly, `getAnywhere("log10")` shows
`function (x) .Primitive("log10")`. The file
[src/main/names.c](https://github.com/r-devel/r-svn/blob/main/src/main/names.c)
has as entry with `log10` in the first column:
`{"log10", do_log1arg, 10, 1, 1, {PP_FUNCALL, PREC_FN, 0}}`. Searching
`src/main` for `log1arg` gives file
[arithmetic.c](https://github.com/r-devel/r-svn/blob/main/src/main/arithmetic.c)
as one of its results. That file contains the source code of `log10`.

Sometimes an R-function is defined in a file that defines multiple
functions and thus has a general name. Then the file with c-code will
have a similar general name. For example, the source code of
[`make.names()`](https://rdrr.io/r/base/make.names.html) is defined in
`src/library/base/R/character.R` which contains (among others) the code
`.Internal(make.names(names, allow_))`, and the c-code for
`do_makenames()` is in file `src/main/character.c`.

#### .Call

If `getAnywhere("<funcname>")` returns code that contains `.Call(...)`,
the function contains a call to C or C++ code. Although the file
`src/<pkgname>.h` (e.g.,
[src/methods.h](https://github.com/r-devel/r-svn/blob/main/src/library/methods/src/methods.h)
if code is from package `methods`) contains an overview of the C or C++
code included in a package, your best bet for finding the source code is
[searching](https://docs.github.com/en/search-github) the relevant part
of the [GitHub](https://github.com/r-devel/r-svn/) repository (e.g.,
`https://github.com/r-devel/r-svn/tree/main/src/library/methods/src` for
code from package `methods`), or installing the package from source (see
the section ‘Rtools’ in the vignette *Installing R, Rtools and RStudio*:
[`vignette("install_r", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/install_r.md))
and searching in the `src` folder of the downloaded code.

## Documentation and help

- [Instructions](https://bioconductor.org/install/) on installing
  [BioConductor](https://bioconductor.org/packages/release/BiocViews.html)
  packages and
  [documentation](https://docs.r-universe.dev/bioconductor/) on the
  collaboration between BioConductor and the
  [R-universe](https://r-universe.dev/search)
- [Documentation](https://docs.r-universe.dev/) from the
  [R-universe](https://r-universe.dev/search)
- [Search engines](https://cran.r-project.org/search.html) specific for
  R
- Section [Add-on
  packages](https://cran.r-project.org/doc/manuals/R-admin.html#Add_002don-packages)
  in the [R Installation and Administration
  manual](https://cran.r-project.org/doc/manuals/r-release/R-admin.html)
  manual (which also contains a section about installing packages)
- Section ‘Documentation and help’ in the vignette *Installing R, Rtools
  and RStudio*:  
  [`vignette("install_r", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/install_r.md)
- Section [Troubleshooting](#troubleshooting) above
- The help-page
  [checkrpkgs::check_pkgs()](https://jessealderliesten.github.io/checkrpkgs/help/check_pkgs)
- The book [What They Forgot to Teach You About R](https://rstats.wtf/)
