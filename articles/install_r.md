# Installing R, Rtools and RStudio

## Introduction and notation

This vignette contains instructions on installing and configuring
[R](https://www.r-project.org/),
[RStudio](https://posit.co/products/open-source/rstudio), and
[Rtools](https://cran.r-project.org/bin/windows/Rtools/).

Text between angled brackets (`<...>`) is used to refer to text that
should be replaced with specific text to get working code. For example,
`<pkg>` is used as a place holder to refer to a package name and should
be replaced with `utils` if you want to obtain information about package
`utils`, and with `methods` if you want to obtain information about
package `methods`. Similarly, `<func>` is used as a place holder to
refer to a function name that should be filled in with a specific
function name to get working code.

## R

To install [R](https://www.r-project.org/), visit a nearby CRAN
[mirror](https://cran.r-project.org/mirrors.html) (i.e., a website with
the same content as the [main](https://cran.r-project.org/) CRAN page),
download R via `Download R for Windows` \> `base` \>
`Download R-X.Y.Z for Windows` and install it by opening the downloaded
`.exe` file.

Note that R is **not** required to read R scripts: R scripts are
plain-text files that can be read by applications such as Microsoft
NotePad.

### Making R stricter

R can be configured by changing environment variables and various
options, see
[`help("environment variables")`](https://rdrr.io/r/base/EnvVar.html),
[`help("options")`](https://rdrr.io/r/base/options.html),
[`help("install.packages")`](https://rdrr.io/r/utils/install.packages.html),
and [`help(".libPaths")`](https://rdrr.io/r/base/libPaths.html).
Although options for startup can also be changed (see
[`help("Startup")`](https://rdrr.io/r/base/Startup.html) and the chapter
[R Startup](https://rstats.wtf/r-startup)), that should be done
cautiously because those settings probably make code behave differently
on PCs where those options are not set, for example when changing which
packages are automatically loaded or when adding path to the search
path.

Various options can be changed to make R a bit stricter:

- Warn in case of partial matching such as `list(mean = 3)$me`:  
  `options(warnPartialMatchArgs = TRUE, warnPartialMatchAttr = TRUE, warnPartialMatchDollar = TRUE)`,
  with default `FALSE` for each of these. Details:
  [`help("pmatch")`](https://rdrr.io/r/base/pmatch.html),
  [`help("attr")`](https://rdrr.io/r/base/attr.html), and
  [`help("Extract")`](https://rdrr.io/r/base/Extract.html).
- Error instead of warn when calling `a:b` when numeric `a` or `b` is
  longer than one, such as `3:c(5, 7)`:  
  `Sys.setenv("_R_CHECK_LENGTH_COLON_" = "TRUE")`. Details:
  [`help("colon", package = "base")`](https://rdrr.io/r/base/Colon.html).
  This option was introduced in R 4.3.0.
- Error instead of silently using only the first element in logical
  operations such as `c(TRUE, TRUE) && TRUE)`:  
  `Sys.setenv("_R_CHECK_LENGTH_1_LOGIC2_" = "TRUE")`. Details:
  [`help("Logic", package = "base")`](https://rdrr.io/r/base/Logic.html).
  This option was introduced in R 3.6.0 and is no longer used since R
  4.3.0 because there calling `&&` or `||` with length larger than one
  always gives an error.
- Error instead of warn if a condition has length larger than one, such
  as `if(3 < c(5, 7))`:  
  `Sys.setenv("_R_CHECK_LENGTH_1_CONDITION_" = "TRUE")`. Details:
  [`help("Control", package = "base")`](https://rdrr.io/r/base/Control.html).
  This option was introduced in R 3.4.0 and is no longer used since R
  4.2.0 because there conditions with length larger than one always give
  an error.
- Print [`warnings()`](https://rdrr.io/r/base/warnings.html) immediately
  as they occur (`options(warn = 1)`) or make them an error
  (`options(warn = 2)`). The latter should only be used for debugging
  because it may trigger bugs and resource leaks. The default is
  `options(warn = 0)` to warn after the top-level function returns.
  Details: [`help("stop")`](https://rdrr.io/r/base/stop.html).
- Enter the environment browser upon error:  
  `options(error = browser)`, with default `options(error = NULL)` to
  not enter the environment browser. Press `Q` or `Escape` to quit the
  browser mode and press `c` to continue code. Details:
  [`help("browser")`](https://rdrr.io/r/base/browser.html).

In addition, various packages contain ways to make R stricter:

- Package [strict](https://github.com/hadley/strict/) warns about
  various unsafe practices, such as the behaviour of
  [`sample()`](https://rdrr.io/r/base/sample.html) and
  [`diag()`](https://rdrr.io/r/base/diag.html) if called with an
  argument of length one and type-unsafe
  [`sapply()`](https://rdrr.io/r/base/lapply.html); additional ideas are
  in the GitHub
  [issues](https://github.com/hadley/strict/issues?q=is%3Aissue).
- Package [conflicted](https://CRAN.R-project.org/package=conflicted)
  avoids silent conflict resolution (i.e., choosing the latest attached
  package out of multiple packages to use a function from; see
  `help("conflict")`), and provides `conflicts_prefer(<pkg>::<func>)` to
  declare preferences.

### Information about R

Several variables and functions provide information about the current R
session, such as the R version and characteristics of the machine and
platform R is running on:

- `.Machine` (see
  [`help(".Machine")`](https://rdrr.io/r/base/zMachine.html)) and
  [`Sys.info()`](https://rdrr.io/r/base/Sys.info.html) provide
  information about the machine and platform R is running on.
  [`getRversion()`](https://rdrr.io/r/base/numeric_version.html)
  provides the version of the running R. Operating systems might
  identify themselves and their versions in surprising ways, and Windows
  might report older versions than the versions that are actually
  installed (see the section `osVersion` in
  [`help("sessionInfo", package = "utils")`](https://rdrr.io/r/utils/sessionInfo.html)
  and the `Note` in
  [`help("win.version", package = "utils")`](https://rdrr.io/r/utils/winextras.html).
- `.Platform` (see
  [`help(".Platform")`](https://rdrr.io/r/base/Platform.html)) and
  [`R.Version()`](https://rdrr.io/r/base/Version.html) provide
  information about the platform R was built on.
- [`Sys.getlocale()`](https://rdrr.io/r/base/locales.html) and
  [`l10n_info()`](https://rdrr.io/r/base/l10n_info.html) provide details
  about the locale (i.e., settings that depend on the user’s language or
  region).
- [`capabilities()`](https://rdrr.io/r/base/capabilities.html) and
  [`extSoftVersion()`](https://rdrr.io/r/base/extSoftVersion.html)
  provide details about external software that can be used with R.
- The help page on environment variables
  ([`help("environment variables")`](https://rdrr.io/r/base/EnvVar.html))
  lists some of the environment variables which affect an R session.
- [`utils::sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html)
  extracts parts of the information mentioned above about the operating
  system and R. It also lists attached and loaded packages. Its printing
  method can be used to print additional information about the used
  locale (i.e., settings that depend on the user’s language or region)
  and random number generation:
  `print(sessionInfo(), locale = TRUE, RNG = TRUE)`. Package
  `sessioninfo` contains the similar function `session_info()` which
  provides more details about the origin of loaded or installed
  packages, and has the option to show only information about selected
  packages and their dependencies.

## RStudio

[RStudio](https://posit.co/products/open-source/rstudio) is an
[integrated development
environment](https://en.wikipedia.org/wiki/Integrated_development_environment)
for R developed by [Posit](https://posit.co/) that can be downloaded
[here](https://posit.co/download/rstudio-desktop/).

RStudio can also be used to read and modify plain-text files.

### Configuring RStudio

After installing RStudio, start RStudio, go to `Tools` \>
`Global Options` \> `General` to **deselect** the option
`Restore .RData into workspace at startup` and set the option
`Save workspace to .RData on exit` to `Never` to make work portable
(i.e., make sure that R does not use information or data that is not
present on another PC).

The version of R to use can be selected at `Tools` \> `Global Options`
\> `General` \> `R version`.

Keyboard shortcuts can be modified at `Tools` \>
`Modify Keyboard Shortcuts`, e.g., to change the shortcut
`Run current line or selection` from `Ctrl+Enter` to `Ctrl+R` so it can
be used with one hand. Sometimes RStudio does not use the modified
keyboard shortcuts. Going to `Tools` \> `Modify Keyboard Shortcuts`
usually fixes that without the need to actually reset the shortcuts.

The appearance of code can be changed at `Tools` \> `Global options` \>
`Appearance`. Nice editor themes are the light `Xcode` and the dark
`Tomorrow Night Bright`, `Idle Fingers`, and `Pastel On Dark`. Nice
`Editor fonts` are `Consolas`, `Cacadia Mono Light`, and
`Lucida Console`.

Choosing a good editor font deserves some attention: using a font with
clearly distinct characters prevents confusing similar characters when
writing code. The following strings group together characters that in
some fonts are similar in appearance. Letters are indicated with their
names in upper case letters that are easier to distinguish, with ‘upper’
indicating that upper case letters are used in the string:

- `B8 S5 y4 Z2`: upper BEE, eight; upper ESS, five; WYE, four; upper
  ZED, two
- `gq ijy rnm uvvw UVVW`: GEE, CUE; I, JAY, WYE; AR, EN, EM; U, repeated
  VEE, double-U; upper U, repeated upper VEE, upper double-U
- `., :; "'' __`: dot, comma; colon, semicolon; double quotes, repeated
  single quotes; repeated underscores
- `cldcIdc|dc1`: CEE, EL, DEE, CEE, upper I, DEE, CEE, vertical bar,
  DEE, CEE, one
- `71lI|i/`: seven, one, EL, upper I, vertical bar, I, slash
- `oQO0D`: O, upper CUE, upper O, ZERO, upper DEE

Together, these strings form the following string that can be used to
compare fonts, for example using [Adobe Fonts](https://fonts.adobe.com/)
or [Google Fonts](https://fonts.google.com/):
`B8 S5 y4 Z2 gq ijy rnm uvvw UVVW ., :; "'' __ cldcIdc|dc1 71lI|i/ oQO0D`

## Rtools

[Rtools](https://cran.r-project.org/bin/windows/Rtools/) is **not** an R
package but software used to build R [from
source](https://cran.r-project.org/sources.html) and to build R packages
from source. The latter is needed when installing packages from
[GitHub](https://github.com/) and when installing **older** versions of
packages from [CRAN](https://cran.r-project.org/web/packages/index.html)
or
[Bioconductor](https://bioconductor.org/packages/release/BiocViews.html#___Software)
(see the section ‘Installing packages’ in the vignette *R packages* for
instructions on installing R packages:
[`vignette("r_pkgs", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/r_pkgs.md)).
In addition, when updating packages, you might get the question
`Do you want to install from sources the packages which need compilation?`.
If you have installed Rtools you can choose `Yes` to install the latest
package versions by building them from source, see the section
‘Troubleshooting’ in the vignette *R packages* for details:
[`vignette("r_pkgs", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/r_pkgs.md).
If you have **not** installed Rtools you should choose `No`: then you
will get slightly less up-to-date package versions (but a faster
installation).

To install [Rtools](https://cran.r-project.org/bin/windows/Rtools/),
download the version appropriate for the installed version of R (see the
output of
[`getRversion()`](https://rdrr.io/r/base/numeric_version.html)) from
[CRAN](https://cran.r-project.org/) via `Download R for Windows` \>
`Rtools` \> `RTools X.Y` and set it up using the instructions given
there. See also the
[HowTo](https://cran.r-project.org/bin/windows/base/howto-R-4.6.html) by
Tomas Kalibera. Alternatively,
`pkgbuild::check_build_tools(debug = TRUE)` can be used to check and
install Rtools.

## Documentation and help

- [Bug reporting](https://www.r-project.org/bugs.html), linking to
  [bugzilla](https://bugs.r-project.org/)
- CRAN: the [homepage](https://cran.r-project.org/) and an overview of
  its [mirrors](https://cran.r-project.org/mirrors.html) (for details,
  see the section ‘Other repositories and mirrors’ in the vignette *R
  packages*:
  [`vignette("r_pkgs", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/r_pkgs.md)).
- R [homepage](https://www.r-project.org/) with
  [FAQs](https://cran.r-project.org/faqs.html),
  [NEWS](https://cran.r-project.org/doc/manuals/r-release/NEWS.html),
  and [manuals](https://cran.r-project.org/manuals.html) (especially the
  [R Installation and Administration
  manual](https://cran.r-project.org/doc/manuals/r-release/R-admin.html))
  with [derived versions](https://rstudio.github.io/r-manuals/) better
  suited for searching.
- R help: from inside R through
  [`utils::help.start()`](https://rdrr.io/r/utils/help.start.html) or
  [online](https://cran.r-project.org/search.html)
- R [mailing lists](https://www.r-project.org/mail.html) with a web
  interface with [information and
  archives](https://stat.ethz.ch/mailman/listinfo) and a mirror for
  [searching](https://r-mailing-lists.thecoatlessprofessor.com/)
- RStudio [user guide](https://docs.posit.co/ide/user/) and
  [cheatsheet](https://opensource.posit.co/resources/cheatsheets/rstudio-ide/)
  by [Posit](https://posit.co/)
- Search engines specific for R: [METACRAN](https://r-pkg.org/),
  [r-project](https://search.r-project.org/),
  [Rseek](https://www.rseek.org/),
  [R-universe](https://r-universe.dev/search)
- [StackOverflow](https://stackoverflow.com/tags/r/info) posts with the
  `r` tag

Resources with more details than this vignette:

- The book [What They Forgot to Teach You About R](https://rstats.wtf/)
  by J. Bryan, J. Hester, S. Pileggi, and E. D. Aja
- The book [An introduction to R](https://intro2r.com/) by A.
  Douglas, D. Roos, F. Mancini, A. Couto and D. Lusseau
- Chapter [Installation & Environment
  Setup](https://bookdown.org/guokai8/mastering-r-through-errors/docs/installation-environment.html)
  from the book [Mastering R Through Errors and
  Warnings](https://bookdown.org/guokai8/mastering-r-through-errors/docs/)
  by K. Guo
- Chapter [Getting Started and Getting
  Help](https://rc2e.com/gettingstarted) from the [R
  Cookbook](https://rc2e.com/) by J. Long and P. Teetor
