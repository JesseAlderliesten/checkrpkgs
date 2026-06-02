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
([`help("environment variables")`](https://rdrr.io/r/base/EnvVar.html),
[`help("options")`](https://rdrr.io/r/base/options.html),
[`help("install.packages")`](https://rdrr.io/r/utils/install.packages.html),
and [`help(".libPaths")`](https://rdrr.io/r/base/libPaths.html)).
Although options for start-up can also be changed (see
[`help("Startup")`](https://rdrr.io/r/base/Startup.html) and the chapter
[R Startup](https://rstats.wtf/r-startup)), such settings can be stored
in multiple files in various locations and might make code behave
differently on PCs where these options are not set, for example when
they do not automatically load a package or add a path to the search
path, so should be used cautiously.

Various options can be changed to make R a bit stricter:

- Warn in case of partial matching
  ([`help("pmatch")`](https://rdrr.io/r/base/pmatch.html)) such as
  `list(mean = 3)$me`:
  `options(warnPartialMatchArgs = TRUE, warnPartialMatchAttr = TRUE, warnPartialMatchDollar = TRUE)`.
  The default is `FALSE` for each of these.
- Error instead of warn when calling `a:b` when numeric `a` or `b` is
  longer than one, such as `3:c(5, 7)` (introduced in R 4.3.0):
  `Sys.setenv("_R_CHECK_LENGTH_COLON_" = "TRUE")`.
- Error instead of silently using only the first element in logical
  operations
  ([`help("Logic", package = "base")`](https://rdrr.io/r/base/Logic.html))
  such as `c(TRUE, TRUE) && TRUE)` (introduced in R 3.6.0, no longer
  used since R 4.3.0 because there calling `&&` or `||` with length
  larger than one always gives an error):
  `Sys.setenv("_R_CHECK_LENGTH_1_LOGIC2_" = "TRUE")`.
- Error instead of warn if a condition
  ([`help("Control", package = "base")`](https://rdrr.io/r/base/Control.html))
  has length larger than one, such as `if(3 < c(5, 7))` (introduced in R
  3.4.0, no longer used since R 4.2.0 because there conditions with
  length larger than one always give an error):
  `Sys.setenv("_R_CHECK_LENGTH_1_CONDITION_" = "TRUE")`.
- Print [`warnings()`](https://rdrr.io/r/base/warnings.html) immediately
  as they occur (`options(warn = 1)`) or make them an error
  ([`help("stop")`](https://rdrr.io/r/base/stop.html)):
  `options(warn = 2)`. The latter should only be used for debugging
  because it may trigger bugs and resource leaks (per its help-page).
  The default is `options(warn = 0)` to warn after the top-level
  function returns.
- Enter the environment browser
  ([`help("browser")`](https://rdrr.io/r/base/browser.html)) upon error
  (default: `options(error = NULL)`): `options(error = browser)`; press
  `Q` or `Escape` to quit the browser mode; press `c` to continue code.

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
  [`help("sessionInfo")`](https://rdrr.io/r/utils/sessionInfo.html) and
  the `Note` in
  [`help("win.version")`](https://rdrr.io/r/utils/winextras.html).
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
- [`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html) extracts
  parts of the information mentioned above about the operating system
  and R. It also lists attached and loaded packages. Its printing method
  can be used to print additional information about the used locale
  (i.e., settings that depend on the user’s language or region) and
  random number generation:
  `print(sessionInfo(), locale = TRUE, RNG = TRUE)`.

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
`Appearance`. The default `Editor theme` is the light `Textmate`. Other
nice editor themes are the light `Xcode` and the dark
`Tomorrow Night Bright`, `Idle Fingers`, and `Pastel On Dark`. Nice
`Editor font`s are `Consolas`, `Cacadia Mono Light`, and
`Lucida Console`.

To check that characters in a typeface or font can be properly
distinguished from each other when choosing a font, for example using
[Adobe Fonts](https://fonts.adobe.com/) or [Google
Fonts](https://fonts.google.com/), the following string groups together
characters that in some fonts are similar in appearance:
`71lI|i/ oQO0D gq B8 S5 Z2 ijy4 ., :; "'' __ cldcIdc|dc1d rnm UVVWuvvw`

The string consists of the following characters (using upper case letter
that are easier to distinguish, with ‘lower’ and ‘upper’ indicating the
case used in the string):

- SEVEN, ONE, lower EL, upper I, vertical BAR, lower I, SLASH
- lower O, upper CUE, upper O, ZERO, upper DEE
- lower GEE, lower CUE
- upper BEE, EIGHT
- upper ESS, FIVE
- upper ZED, TWO
- lower I, lower JAY, lower WYE, FOUR
- DOT, COMMA,
- COLON, SEMICOLON
- double QUOTES, single QUOTES, single QUOTES
- UNDERSCORE, UNDERSCORE
- lower CEE, lower EL, lower DEE, lower CEE, upper I, lower DEE, lower
  CEE,  
  vertical BAR, lower DEE, lower CEE, ONE, lower DEE
- lower AR, lower EN, lower EM
- upper U, upper VEE, upper VEE, upper double-U,  
  lower U, lower VEE, lower VEE, lower double-U

## Rtools

[Rtools](https://cran.r-project.org/bin/windows/Rtools/) is **not** an R
package but software used to build R [from
source](https://cran.r-project.org/sources.html) and to build R packages
from source: packages from [GitHub](https://github.com/) and **older**
versions of packages from
[CRAN](https://cran.r-project.org/web/packages/index.html) or
[Bioconductor](https://bioconductor.org/packages/release/BiocViews.html#___Software)
(see the section ‘Installing packages’ in the vignette *R packages* for
instructions:
[`vignette("r_pkgs", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/r_pkgs.md)).
Rtools is **not** needed to install current versions of packages from
[CRAN](https://cran.r-project.org/web/packages/index.html) or
[Bioconductor](https://bioconductor.org/) on Windows.

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
- CRAN [homepage](https://cran.r-project.org/)
- CRAN mirrors: see the section ‘Other repositories and mirrors’ in the
  vignette *R packages*:
  [`vignette("r_pkgs", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/r_pkgs.md)
- [develcoder](https://jessealderliesten.github.io/develcoder/) with
  code to develop R packages
- R [FAQs](https://cran.r-project.org/faqs.html)
- R help: from inside R through
  [`help.start()`](https://rdrr.io/r/utils/help.start.html) or online
  via <https://cran.r-project.org/search.html>
- R [homepage](https://www.r-project.org/)
- R [mailing lists](https://www.r-project.org/mail.html) with a web
  interface with [information and
  archives](https://stat.ethz.ch/mailman/listinfo) and a mirror for
  [searching](https://r-mailing-lists.thecoatlessprofessor.com/)
- R [manuals](https://cran.r-project.org/manuals.html), especially the
  [R Installation and Administration
  manual](https://cran.r-project.org/doc/manuals/r-release/R-admin.html),
  with [derived versions](https://rstudio.github.io/r-manuals/) better
  suited for searching.
- R [news](https://cran.r-project.org/doc/manuals/r-release/NEWS.html)
- [RStudio user guide](https://docs.posit.co/ide/user/) and
  [cheatsheet](https://opensource.posit.co/resources/cheatsheets/rstudio-ide/)
  by [Posit](https://posit.co/)
- [Search engines](https://cran.r-project.org/search.html) specific for
  R;
- [StackOverflow](https://stackoverflow.com/tags/r/info) posts with the
  `r` tag
- The website [What They Forgot to Teach You About
  R](https://rstats.wtf/)

Resources with more details than this vignette:

- Chapter [Installation & Environment
  Setup](https://bookdown.org/guokai8/mastering-r-through-errors/docs/installation-environment.html)
  from the book [Mastering R Through Errors and
  Warnings](https://bookdown.org/guokai8/mastering-r-through-errors/docs/)
- Chapter [Getting Started and Getting
  Help](https://rc2e.com/gettingstarted) from the [R
  Cookbook](https://rc2e.com/)
- The book [An introduction to R](https://intro2r.com/) by Alex Douglas,
  Deon Roos, Francesca Mancini, Ana Couto & David Lusseau
