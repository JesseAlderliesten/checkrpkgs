# Check for non-installed or non-functional packages

Function to check for non-installed or non-functional packages.

## Usage

``` r
check_pkgs(pkgs, silently = FALSE)
```

## Arguments

- pkgs:

  A character vector with names of packages to be checked, or ending in
  such names, see section `Package names` below.

- silently:

  `TRUE` or `FALSE`: suppress warnings that are emitted when loading
  installed non-functional packages?

## Value

A list with elements 'absent' and 'nonfunc' containing character vectors
with the names of packages in `pkgs` that are not installed or
non-functional, respectively. The elements are `character(0)` if all
packages in `pkgs` are present and are functional, respectively. A
warning is issued if any package is not installed or not functional.

## Package names

The part after the last forward or backward slash is considered to be
the package name if input to `pkgs` contains such slashes. Therefore
package names, file paths to packages, and full URLs to packages from
[GitHub](https://github.com/) can all be used as input to `pkgs`, e.g.,
`"checkrpkgs"`,
`"C:/Users/Eigenaar/AppData/Local/R/win-library/4.5/checkrpkgs"`,
`"https://github.com/JesseAlderliesten/checkrpkgs"`.

Note that package names are case-sensitive.

## Side effects

Packages are [loaded](https://rdrr.io/r/base/ns-load.html), such that
[updating](https://rdrr.io/r/utils/update.packages.html) them might
fail. Restart R to prevent such problems.

## Notes

Packages are looked for in the library paths given by
[`.libPaths()`](https://rdrr.io/r/base/libPaths.html).

Only the first instance of a package is checked if it occurs more than
once, with a warning.

## Programming notes

This function uses
[`find.package()`](https://rdrr.io/r/base/find.package.html) and
[`requireNamespace()`](https://rdrr.io/r/base/ns-load.html) instead of
[`utils::installed.packages()`](https://rdrr.io/r/utils/installed.packages.html)
because `installed.packages` does not check if packages are functional,
nor if all needed
[dependencies](https://rdrr.io/r/tools/package_dependencies.html) are
installed and functional. In
addition,[`installed.packages()`](https://rdrr.io/r/utils/installed.packages.html)
can be slow such that its help pag\] states that
[`requireNamespace()`](https://rdrr.io/r/base/ns-load.html) or
[`require()`](https://rdrr.io/r/base/library.html) should be used
instead.

## See also

[`get_details_pkgs()`](https://jessealderliesten.github.io/checkrpkgs/reference/get_details_pkgs.md)
for more information about the origin of packages.

The vignette *Instructions about R packages*:
[`vignette("r_pkgs", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/r_pkgs.md).

## Examples

``` r
check_pkgs(pkgs = c("base", "utils", "jessealderliesten/checkrpkgs"))
#> $absent
#> character(0)
#> 
#> $nonfunc
#> character(0)
#> 

non_existent_pkgs <- c("yz/wx/abcdef4", "wx/abcdef3", "abcdef2", "abcdef1")
check_pkgs(non_existent_pkgs)
#> Warning: non-installed packages: 'yz/wx/abcdef4', 'wx/abcdef3', 'abcdef2', 'abcdef1'
#> $absent
#> [1] "yz/wx/abcdef4" "wx/abcdef3"    "abcdef2"       "abcdef1"      
#> 
#> $nonfunc
#> character(0)
#> 
check_pkgs(pkgs = c(non_existent_pkgs, "utils"))
#> Warning: non-installed packages: 'yz/wx/abcdef4', 'wx/abcdef3', 'abcdef2', 'abcdef1'
#> $absent
#> [1] "yz/wx/abcdef4" "wx/abcdef3"    "abcdef2"       "abcdef1"      
#> 
#> $nonfunc
#> character(0)
#> 
```
