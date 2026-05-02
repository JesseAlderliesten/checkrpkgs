# Get details about installed packages

Wrapper around
[`utils::installed.packages()`](https://rdrr.io/r/utils/installed.packages.html)
to get more information about the origin of installed packages and
select the packages for which to return information.

## Usage

``` r
get_details_pkgs(
  pkgs = character(0),
  fields = NULL,
  priority = NULL,
  lib.loc = NULL,
  db = NULL
)
```

## Arguments

- pkgs:

  A character vector with names of packages to be checked, or ending in
  such names, see section `Package names` below.

- fields:

  a character vector giving the fields to extract from each package's
  `DESCRIPTION` file in addition to the default ones, or `NULL`
  (default). Unavailable fields result in `NA` values.

- priority:

  character vector or `NULL` (default). If non-null, used to select
  packages; `"high"` is equivalent to `c("base", "recommended")`. To
  select all packages without an assigned priority use
  `priority = NA_character_`.

- lib.loc:

  character vector describing the location of R library trees to search
  through, or `NULL` for all known trees (see
  [`.libPaths`](https://rdrr.io/r/base/libPaths.html)).

- db:

  `NULL` (default) or a matrix with the results of a call to
  [`utils::installed.packages()`](https://rdrr.io/r/utils/installed.packages.html)
  containing column `Package` (or rownames that are package names). To
  prevent a call to
  [`utils::installed.packages()`](https://rdrr.io/r/utils/installed.packages.html),
  the matrix should contain the columns listed in section `Details`
  below and any requested columns.

## Value

A matrix containing details of the installed packages, see `Details`.

`Repository` fields in the returned matrix that are `NA` or `""` are
changed to `Github` if fields `"GithubRepo"` or `"GithubUsername"` are
not `NA` or field `URL` matches `"github"`.

If `pkgs` has a length larger than zero, only information about the
packages in `pkgs` is returned (but the rows are *not* ordered on
`pkgs`), with a warning if a package is not found.

If a package occurs more than once in the searched R library trees, all
instances are returned, with a warning reporting their version, library
path and origin. Information about a package is not duplicated in the
returned matrix if multiple entries in `pkgs` refer to the same package.

If no packages were found, a zero-row matrix is returned, with a
warning.

## Details

The returned matrix will contain columns `"Package"`, `"Version"`,
`"MD5sum"`, `"Built"`, `"Priority"`, `"LibPath"`, `"Repository"`,
`"Additional_repositories"`, `"URL"`, `"GithubRepo"`,
`"GithubUsername"`, `"SystemRequirements"`, `"NeedsCompilation"`,
`"OS_type"`, `"Depends"`, `"Imports"`, `"LinkingTo"`, `"Suggests"` and
any columns requested through argument `fields`.

## Package names

The part after the last forward or backward slash is considered to be
the package name if input to `pkgs` contains such slashes. Therefore
package names, file paths to packages, and full URLs to packages from
[GitHub](https://github.com/) can all be used as input to `pkgs`, e.g.,
`"checkrpkgs"`,
`"C:/Users/Eigenaar/AppData/Local/R/win-library/4.5/checkrpkgs"`,
`"https://github.com/JesseAlderliesten/checkrpkgs"`.

## See also

[`utils::installed.packages()`](https://rdrr.io/r/utils/installed.packages.html)
that is used by `get_details_pkgs()`.

[`tools::CRAN_package_db()`](https://rdrr.io/r/tools/CRANtools.html) for
information about packages available from
[CRAN](https://cran.r-project.org/web/packages/index.html), including
the `Description` and `Maintainer` fields not returned by
[`utils::available.packages()`](https://rdrr.io/r/utils/available.packages.html).
[`tools::CRAN_check_results()`](https://rdrr.io/r/tools/CRANtools.html),
[`tools::CRAN_check_details()`](https://rdrr.io/r/tools/CRANtools.html)
and
[`tools::CRAN_check_issues()`](https://rdrr.io/r/tools/CRANtools.html)
on the current check status of CRAN packages.

[utils::available.packages](https://rdrr.io/r/utils/available.packages.html)`(fields = NULL, repos = `[`BiocManager::repositories()`](https://bioconductor.github.io/BiocManager/reference/repositories.html)`)`
for information about packages available from
[BioConductor](https://bioconductor.org/packages/release/BiocViews.html),
and
[`BiocManager::available()`](https://bioconductor.github.io/BiocManager/reference/available.html)
for their names.

[check_pkgs](https://jessealderliesten.github.io/checkrpkgs/reference/check_pkgs.md),
with information on obtaining dependencies in its help-page.

The vignette *Instructions about R packages*:
[`vignette("r_pkgs", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/r_pkgs.md).

Other functions to get information about packages:
[`check_pkgs()`](https://jessealderliesten.github.io/checkrpkgs/reference/check_pkgs.md)

## Examples

``` r
get_details_pkgs(priority = "base")
#> Selecting packages with priority 'base'
#>           Package     Version MD5sum
#> base      "base"      "4.6.0" NA    
#> compiler  "compiler"  "4.6.0" NA    
#> datasets  "datasets"  "4.6.0" NA    
#> grDevices "grDevices" "4.6.0" NA    
#> graphics  "graphics"  "4.6.0" NA    
#> grid      "grid"      "4.6.0" NA    
#> methods   "methods"   "4.6.0" NA    
#> parallel  "parallel"  "4.6.0" NA    
#> splines   "splines"   "4.6.0" NA    
#> stats     "stats"     "4.6.0" NA    
#> stats4    "stats4"    "4.6.0" NA    
#> tcltk     "tcltk"     "4.6.0" NA    
#> tools     "tools"     "4.6.0" NA    
#> utils     "utils"     "4.6.0" NA    
#>           Built                                                        
#> base      "R 4.6.0; ; 2026-04-24 08:57:19 UTC; unix"                   
#> compiler  "R 4.6.0; ; 2026-04-24 08:55:35 UTC; unix"                   
#> datasets  "R 4.6.0; ; 2026-04-24 08:56:55 UTC; unix"                   
#> grDevices "R 4.6.0; x86_64-pc-linux-gnu; 2026-04-24 08:56:09 UTC; unix"
#> graphics  "R 4.6.0; x86_64-pc-linux-gnu; 2026-04-24 08:56:16 UTC; unix"
#> grid      "R 4.6.0; x86_64-pc-linux-gnu; 2026-04-24 08:57:08 UTC; unix"
#> methods   "R 4.6.0; x86_64-pc-linux-gnu; 2026-04-24 08:56:56 UTC; unix"
#> parallel  "R 4.6.0; x86_64-pc-linux-gnu; 2026-04-24 08:57:17 UTC; unix"
#> splines   "R 4.6.0; x86_64-pc-linux-gnu; 2026-04-24 08:57:14 UTC; unix"
#> stats     "R 4.6.0; x86_64-pc-linux-gnu; 2026-04-24 08:56:25 UTC; unix"
#> stats4    "R 4.6.0; ; 2026-04-24 08:57:15 UTC; unix"                   
#> tcltk     "R 4.6.0; x86_64-pc-linux-gnu; 2026-04-24 08:57:16 UTC; unix"
#> tools     "R 4.6.0; x86_64-pc-linux-gnu; 2026-04-24 08:55:35 UTC; unix"
#> utils     "R 4.6.0; x86_64-pc-linux-gnu; 2026-04-24 08:56:01 UTC; unix"
#>           Priority LibPath                      Repository
#> base      "base"   "/opt/R/4.6.0/lib/R/library" NA        
#> compiler  "base"   "/opt/R/4.6.0/lib/R/library" NA        
#> datasets  "base"   "/opt/R/4.6.0/lib/R/library" NA        
#> grDevices "base"   "/opt/R/4.6.0/lib/R/library" NA        
#> graphics  "base"   "/opt/R/4.6.0/lib/R/library" NA        
#> grid      "base"   "/opt/R/4.6.0/lib/R/library" NA        
#> methods   "base"   "/opt/R/4.6.0/lib/R/library" NA        
#> parallel  "base"   "/opt/R/4.6.0/lib/R/library" NA        
#> splines   "base"   "/opt/R/4.6.0/lib/R/library" NA        
#> stats     "base"   "/opt/R/4.6.0/lib/R/library" NA        
#> stats4    "base"   "/opt/R/4.6.0/lib/R/library" NA        
#> tcltk     "base"   "/opt/R/4.6.0/lib/R/library" NA        
#> tools     "base"   "/opt/R/4.6.0/lib/R/library" NA        
#> utils     "base"   "/opt/R/4.6.0/lib/R/library" NA        
#>           Additional_repositories URL GithubRepo GithubUsername
#> base      NA                      NA  NA         NA            
#> compiler  NA                      NA  NA         NA            
#> datasets  NA                      NA  NA         NA            
#> grDevices NA                      NA  NA         NA            
#> graphics  NA                      NA  NA         NA            
#> grid      NA                      NA  NA         NA            
#> methods   NA                      NA  NA         NA            
#> parallel  NA                      NA  NA         NA            
#> splines   NA                      NA  NA         NA            
#> stats     NA                      NA  NA         NA            
#> stats4    NA                      NA  NA         NA            
#> tcltk     NA                      NA  NA         NA            
#> tools     NA                      NA  NA         NA            
#> utils     NA                      NA  NA         NA            
#>           SystemRequirements NeedsCompilation OS_type Depends
#> base      NA                 NA               NA      NA     
#> compiler  NA                 NA               NA      NA     
#> datasets  NA                 NA               NA      NA     
#> grDevices NA                 "yes"            NA      NA     
#> graphics  NA                 "yes"            NA      NA     
#> grid      NA                 "yes"            NA      NA     
#> methods   NA                 "yes"            NA      NA     
#> parallel  NA                 "yes"            NA      NA     
#> splines   NA                 "yes"            NA      NA     
#> stats     NA                 "yes"            NA      NA     
#> stats4    NA                 NA               NA      NA     
#> tcltk     NA                 "yes"            NA      NA     
#> tools     NA                 "yes"            NA      NA     
#> utils     NA                 "yes"            NA      NA     
#>           Imports                      LinkingTo
#> base      NA                           NA       
#> compiler  NA                           NA       
#> datasets  NA                           NA       
#> grDevices NA                           NA       
#> graphics  "grDevices"                  NA       
#> grid      "grDevices, utils"           NA       
#> methods   "utils, stats"               NA       
#> parallel  "tools, compiler"            NA       
#> splines   "graphics, stats"            NA       
#> stats     "utils, grDevices, graphics" NA       
#> stats4    "graphics, methods, stats"   NA       
#> tcltk     "utils"                      NA       
#> tools     NA                           NA       
#> utils     NA                           NA       
#>           Suggests                                                                       
#> base      "methods"                                                                      
#> compiler  NA                                                                             
#> datasets  NA                                                                             
#> grDevices "KernSmooth"                                                                   
#> graphics  NA                                                                             
#> grid      NA                                                                             
#> methods   "codetools"                                                                    
#> parallel  "methods"                                                                      
#> splines   "Matrix, methods"                                                              
#> stats     "MASS, Matrix, SuppDists, methods, stats4"                                     
#> stats4    NA                                                                             
#> tcltk     NA                                                                             
#> tools     "codetools, methods, xml2, curl, commonmark, knitr, xfun, mathjaxr, V8, bibtex"
#> utils     "methods, xml2, commonmark, knitr, jsonlite"                                   

# Returns all default fields and requested fields, warns about packages that
# are not found
get_details_pkgs(pkgs = c("JesseAlderliesten/checkinput", "missing_package",
                          "JesseAlderliesten/checkrpkgs"),
                 fields = "SomeField")
#> Warning: Some packages were not found at 'lib.loc'
#> ('/home/runner/work/_temp/Library', '/opt/R/4.6.0/lib/R/site-library', '/opt/R/4.6.0/lib/R/library'):
#> 'missing_package'
#>            Package      Version MD5sum
#> checkinput "checkinput" "0.5.0" NA    
#> checkrpkgs "checkrpkgs" "0.5.2" NA    
#>            Built                                      Priority
#> checkinput "R 4.6.0; ; 2026-05-02 20:25:38 UTC; unix" NA      
#> checkrpkgs "R 4.6.0; ; 2026-05-02 20:25:42 UTC; unix" NA      
#>            LibPath                           Repository Additional_repositories
#> checkinput "/home/runner/work/_temp/Library" "Github"   NA                     
#> checkrpkgs "/home/runner/work/_temp/Library" "Github"   NA                     
#>            URL                                                                                                
#> checkinput "https://github.com/JesseAlderliesten/checkinput"                                                  
#> checkrpkgs "https://github.com/JesseAlderliesten/checkrpkgs,\nhttps://jessealderliesten.github.io/checkrpkgs/"
#>            GithubRepo   GithubUsername      SystemRequirements NeedsCompilation
#> checkinput "checkinput" "JesseAlderliesten" NA                 "no"            
#> checkrpkgs NA           NA                  NA                 "no"            
#>            OS_type Depends       
#> checkinput NA      "R (>= 4.1.0)"
#> checkrpkgs NA      NA            
#>            Imports                                              LinkingTo
#> checkinput NA                                                   NA       
#> checkrpkgs "checkinput (>= 0.5.0), progutils (>= 0.0.6), utils" NA       
#>            Suggests                                                                                                                                                    
#> checkinput "knitr, rmarkdown, tinytest (>= 1.4.1)"                                                                                                                     
#> checkrpkgs "BiocManager (>= 1.30.5), conflicted, ctv (>= 0.4-0), knitr,\nMatrix, methods, pkgbuild, remotes (>= 2.0.0), rmarkdown,\nstrict, tinytest (>= 1.4.1), tools"
#>            SomeField
#> checkinput NA       
#> checkrpkgs NA       
```
