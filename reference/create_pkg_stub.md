# Create a fake package

Create a minimal package for testing purposes.

## Usage

``` r
create_pkg_stub(
  name,
  path,
  action_on_failure = c("error", "warning", "message"),
  show_progress = FALSE
)
```

## Arguments

- name:

  Character string with the name of the package.

- path:

  Character string with the path to the directory where the package
  should be installed. See `Details`.

- action_on_failure:

  Character string indicating the action if package installation fails:
  `"error"` (default) to throw an
  [error](https://rdrr.io/r/base/stop.html), `"warning"` to issue a
  [warning](https://rdrr.io/r/base/warning.html), or `"message"` to show
  a [message](https://rdrr.io/r/base/message.html). See `Details`.

- show_progress:

  `TRUE` or `FALSE`: show progress of the
  [installation](https://rdrr.io/r/utils/install.packages.html)?

## Value

A character string with the
[normalised](https://rdrr.io/r/base/normalizePath.html) path to the
package directory, returned
[invisibly](https://rdrr.io/r/base/invisible.html). Identical to
`file.path(path, name)` if `path` is already normalized and points to a
writeable directory.

## Details

`path` should *not* include the package name.

If the package is already installed at the directory given by `path`,
the action taken by `action_on_failure` will be triggered.

The check if the package is
[functioning](https://rdrr.io/r/base/ns-load.html) correctly after
installation first looks for the package in the directory given by
`path`. If it is not found there, it will look for the package in the
user directory (with a warning) because
[`utils::install.packages()`](https://rdrr.io/r/utils/install.packages.html)
will ask if that directory should be used if `path` does not point to a
writeable directory. If the packag is not functioning correctly, the
action taken by `action_on_failure` will be triggered.
