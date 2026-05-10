#' Create a fake package
#'
#' Create a minimal package for testing purposes.
#'
#' @param name Character string with the name of the package.
#' @param path Character string with the path to the directory where the package
#' should be installed. See `Details`.
#' @param action_on_failure Character string indicating the action if package
#' installation fails: `"error"` (default) to throw an [error][stop],
#' `"warning"` to issue a [warning], or `"message"` to show a [message]. See
#' `Details`.
#' @param show_progress `TRUE` or `FALSE`: show progress of the
#' [installation][install.packages]?
#'
#' @details
#' `path` should *not* include the package name.
#'
#' If the package is already installed at the directory given by `path`, the
#' action taken by `action_on_failure` will be triggered.
#'
#' The check if the package is [functioning][requireNamespace()] correctly after
#' installation first looks for the package in the directory given by `path`. If
#' it is not found there, it will look for the package in the user directory
#' (with a warning) because [utils::install.packages()] will ask if that
#' directory should be used if `path` does not point to a writeable directory.
#' If the packag is not functioning correctly, the action taken by
#' `action_on_failure` will be triggered.
#'
#' @returns
#' A character string with the [normalised][normalizePath()] path to the package
#' directory, returned [invisibly][invisible]. Identical to
#' `file.path(path, name)` if `path` is already normalized and points to a
#' writeable directory.
#'
#' @export
create_pkg_stub <- function(name, path,
                            action_on_failure = c("error", "warning", "message"),
                            show_progress = FALSE) {
  stopifnot(checkinput::is_character(name), checkinput::is_character(path),
            checkinput::is_logical(show_progress))
  action_on_failure <- match.arg(arg = action_on_failure, several.ok = FALSE)

  path <- normalizePath(path = path,  winslash = "/", mustWork = FALSE)

  # Create a temporary directory that can be removed safely (i.e., without
  # deleting other temporary files still needed by other processes) to put the
  # package skeleton in. Using 'on.exit()' to ensure this temporary directory is
  # also deleted if an error occurs before the function returns.
  skel.loc <- progutils::create_tempdir(subdir = "skel")
  on.exit(unlink(skel.loc, recursive = TRUE), add = TRUE)

  my_fun <- function(x, y) x + y
  suppressMessages(
    skel_path <- utils::package.skeleton(name = name, list = c("my_fun"),
                                         environment = environment(),
                                         path = skel.loc, force = FALSE)
  )

  # Check if the package is already present at the user directory used by
  # utils::install.packages() if the original path is not writeable.
  user_dir <- normalizePath(path = unlist(strsplit(Sys.getenv("R_LIBS_USER"),
                                                   .Platform$path.sep))[1L],
                            winslash = "/", mustWork = FALSE)
  pkg_already_exists_at_userdir <- dir.exists(file.path(user_dir, name))

  pkg_dir <- normalizePath(path = file.path(path, name), winslash = "/",
                           mustWork = FALSE)
  if(dir.exists(pkg_dir)) {
    msg_fail <- paste0("Not installing package '", name, "' in '", path,
                       "':\npackage already exists in that directory!")
    switch(action_on_failure,
           "message" = message(msg_fail),
           "warning" = warning(msg_fail),
           stop(msg_fail))
  }

  utils::install.packages(
    pkgs = skel_path, lib = path, repos = NULL, verbose = show_progress,
    # Set options to install little since it is just for testing
    # Use R CMD INSTALL --help in the terminal to see the options
    INSTALL_opts = c("--fake", "--no-multiarch",
                     "--no-test-load", "--use-vanilla"),
    type = "source", quiet = !show_progress)

  msg_failed_once <- paste0("Installation of package '", name, "' in\n'", path,
                            "' failed")
  if(dir.exists(file.path(path, name))) {
    if(requireNamespace(package = name, lib.loc = path, quietly = TRUE)) {
      if(show_progress) {
        message("Installation of package '", name, "' in\n'", path,
                "' was successful")
      }
    } else {
      switch(action_on_failure,
             "message" = message(msg_failed_once),
             "warning" = warning(msg_failed_once),
             stop(msg_failed_once))
    }
  } else {
    # The package does not exist at 'path', so check the user directory used by
    # utils::install.packages() if the original path is not writeable.
    msg_not_writeable <- paste0(msg_failed_once, " (probably because that",
                                " directory was not writeable)")
    if(requireNamespace(package = name, lib.loc = user_dir, quietly = TRUE)) {
      path <- user_dir
      if(!pkg_already_exists_at_userdir) {
        warning(progutils::wrap_text(paste0(
          msg_not_writeable, " but the attempt to install it at the user",
          " directory '", user_dir, "' succeeded and the package is",
          " functioning correctly.")))
      } else {
        warning(progutils::wrap_text(paste0(
          msg_not_writeable, " but it already existed at the user directory ",
          user_dir, " and that package is functioning correctly")))
      }
    } else {
      msg_failed_twice <- progutils::wrap_text(paste0(
        msg_failed_once, " and the attempt to install it at the user",
        " directory '", user_dir, "' also failed."))

      switch(action_on_failure,
             "message" = message(msg_failed_twice),
             "warning" = warning(msg_failed_twice),
             stop(msg_failed_twice))
    }
  }
  invisible(pkg_dir)
}
