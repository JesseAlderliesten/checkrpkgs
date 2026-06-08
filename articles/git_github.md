# Using Git and GitHub

## Introduction and notation

This vignette explains how to set up and use Git (a version control
system) and [GitHub](https://github.com/) (a website where files,
usually code, can be stored) with
[RStudio](https://posit.co/products/open-source/rstudio).

Angled brackets (`<...>`) indicate place holders that should be replaced
with specific text to get working code or working file paths. For
example, `<username>` and `<repository>` are place holders that refer to
a username and repository name, e.g.,
`https://github.com/<username>/<repository>` could refer to the URL
<https://github.com/JesseAlderliesten/checkrpkgs>, the GitHub repository
of this package.

Files on your PC are called often called ‘local files’, whereas files on
GitHub are called ‘remote files’. Similarly, a folder on your PC (e.g.,
`C:\Program Files\R\R-4.6.0\library\checkrpkgs`) is often called a
‘directory’, whereas a folder on GitHub (e.g.,
<https://github.com/JesseAlderliesten/checkrpkgs>) is often called a
‘repository’.

## Setting up Git and GitHub

Create a [GitHub](https://github.com/) account, download a [GitHub
client](https://git-scm.com/tools/guis) such as [Git
SCM](https://git-scm.com/downloads) or [Git for
Windows](https://gitforwindows.org/) and install it. To update Git for
Windows if you already have it, type `git\update-git-for-windows` in the
[shell](https://happygitwithr.com/shell).

To use Git and GitHub from
[RStudio](https://posit.co/products/open-source/rstudio), in RStudio go
to `Tools` \> `Global Options` \> `Git/SVN` and tick
`Enable version control interface for RStudio projects`. The
`Git executable` field should point to the `git.exe` file, which
probably is at `C:\Program Files\Git\bin\git.exe` or in a hidden folder
at `C:\Users\<owner>\AppData\Local\Git\bin\git.exe` (in Windows
notation; outside Windows, these paths are written as
`C:/Program Files/Git/bin/git.exe` or
`C:/Users/<owner>/AppData/Local/Git/bin/git.exe`, see [Paths in the
shell](#paths-in-the-shell)). If the content of the `Git executable` is
not correct, open the `Git Bash`
[shell](https://happygitwithr.com/shell) (which was installed when
installing [Git for Windows](https://gitforwindows.org/)) by searching
for `Git Bash` in Windows’ `Start` menu. In the Git Bash shell, run
`where git.exe` to get the location of the Git executable.

To associate Git with your GitHub account, you need to provide your name
(this name is listed in GitHub with the changes you make and does
**not** have to be your GitHub username), and the email associated with
your GitHub account. See the Chapter [Introduce yourself to
Git](https://happygitwithr.com/hello-git.html) from [Happy Git and
GitHub for the useR](https://happygitwithr.com/) for more details.

``` git
git config --global user.name '<Jane Doe>'
git config --global user.email '<jane@example.com>'
git config --global --list
```

The last line should return the username and email address you just
entered.

### Using personal access tokens (PATs)

On the use of personal access tokens (PATs) instead of a username and
password, see:

- GitHub
  [documentation](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
- The Chapter about [Personal Access
  Tokens](https://happygitwithr.com/https-pat.html) in [Happy Git and
  GitHub for the useR](https://happygitwithr.com/)
- A [vignette](https://usethis.r-lib.org/articles/git-credentials.html)
  from package [usethis](https://CRAN.R-project.org/package=usethis)

## Using Git and GitHub

To work with GitHub in RStudio, you should open the R Project file
(i.e., a file with extension `.Rproj`), **not** the R script (i.e., a
file with extension `.R`). Then the `Git` menu will be visible as a tab
in the [Environment
pane](https://docs.posit.co/ide/user/ide/guide/ui/ui-panes.html).

`Pull` to get changes from `GitHub`) incorporated in your PC, and handle
any conflicts to get directory on your PC up-to-date with the repository
on GitHub:

- in RStudio: use the `pull` button (downward arrow) in the `Git` menu
- or in the [shell](https://happygitwithr.com/shell):
  `git pull https://github.com/<username>/<repository>`

Save the modified R file after you have made some changes, only then
will the name of the file appear in the `Git` menu of RStudio to review
changes:

- in RStudio: check the box in front of the relevant filename, use the
  `Diff` button in the `Git` menu to get an overview of the changes to
  the file, in the box `Commit message` you should describe the changes
  and why you made them, and use the `Commit` button. `Pull` again
  (downward arrow) to make sure the directory on your PC is up-to-date,
  and handle any conflicts. Then `push` (upward arrow) to incorporate
  the changes in the repository on GitHub.
- or in the [shell](https://happygitwithr.com/shell): compare the
  content of two files, see the instructions in the section [Comparing
  files](#comparing-files) below. Next, use
  `git commit -m '<your commit message>' <path>/<and>/<filename>.R`
  `git push https://github.com/<username>/<repository>` to commit
  changes.

If a `Push` leads to an error because of an invalid username or
password, `Push` again, then you will be asked for a personal access
token (PAT; see the section [Using personal access tokens
(PATs)](#using-personal-access-tokens-pats) above). After you have
entered the PAT once, RStudio will remember it.

## Adding a new file

To add a file to GitHub that is not there yet, first add it to the R
project folder on your PC, then check the `staged` box in the `GitHub`
pane of RStudio and commit it as described
[above](#using-git-and-github)

In the shell this is more involved: If the working directory is **not**
the folder where the to-be-added file is in, the working directory has
to be changed to that folder (e.g., using `cd <path/to/folder>` in the
[shell](https://happygitwithr.com/shell)), or the path has to be added
in front of the filename (dragging the file onto the shell will copy the
path to the shell).

Then let `git` know it is there by typing (it is convenient to use
`tab`-completion to select files): `git add <filename>.<extension>`.

## Comparing files

### Using GitHub

- For a chronological overview of all commits (i.e., across all files)
  in a particular branch of a repository, use an URL of the form
  `http://github.com/<username>/<repository>/commits`, or go to the main
  page of the repository and in the `Code` panel click the `clock` icon
  at the top of the file overview.
- Comparing different branches: see
  [here](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-comparing-branches-in-pull-requests#three-dot-and-two-dot-git-diff-comparisons)
- Comparing commits: see
  [here](https://docs.github.com/en/pull-requests/committing-changes-to-your-project/viewing-and-comparing-commits/comparing-commits)
- See also section [Repositories: download, fork, or
  clone?](#repositories-download-fork-or-clone) below.

### Not using GitHub

R scripts can be compared using
[`tools::Rdiff()`](https://rdrr.io/r/tools/Rdiff.html): use the quoted
file paths (i.e., the directories and file names, **including** the
extensions) of the two files as arguments `from` and `to`:  
`tools::Rdiff(from = "<path/and/filename_file1>.R", to = "<path/and/filename_file2>.R")`

For a nicer output, compare R scripts using the `Bash`
[shell](https://happygitwithr.com/shell): open the `Bash` shell and copy
the file paths (i.e., the directories and file names, **including** the
extensions) of the two files to be compared into the shell on the same
line, and press `Enter`:
`git diff --no-index '<path/and/filename_file1>.R' '<path/and/filename_file2>.R'`

Notes:

- `--no-index` makes it possible to compare files that are **not** under
  version control in `Git`.
- Using quotes (`''`) around the paths ensures this also works when they
  contain spaces.
- The two paths should be on the same line, i.e., **not** separated by a
  newline.
- Although the scroll bar in `Git Bash` seems to indicate the end of the
  file is reached (and scrolling with the mouse does not work), usually
  a colon (`:`) will be displayed left to the cursor to indicate that
  only part of the file is shown. Use the `down arrow` key to see the
  whole file until the end of the file is reached, which is indicated by
  `(END)`.
- The location of a change is indicated at the top of a changed chunk.
  E.g., `-13,5 +14,9` indicates a deletion at character five of line
  thirteen and an insertion at character nine of line fourteen.

## Deleting a file

To delete a file, delete the file from your PC, then `commit` the change
(i.e., deletion of a file), using the `commit message` to describe why
the file was deleted. Then `pull` to make sure directory on your PC is
up to date with the repository on GitHub, and then `push` the change to
the GitHub repository.

Alternatively, open the file in the `GitHub` repository, click the three
dots at the top-right of the file \> `delete` \> `commit`. Use the
commit message to describe why the file was deleted. After that, find
the file on your PC and delete it. Then `pull`.

Deleted files and their history can still be viewed on GitHub, e.g., by
[finding the commit](#using-github) in which the file was deleted.

## Moving or renaming a file

See the GitHub documentation
[here](https://docs.github.com/en/repositories/working-with-files/managing-files/moving-a-file-to-a-new-location)
and
[here](https://docs.github.com/en/repositories/working-with-files/managing-files/renaming-a-file).

## Repositories: download, fork, or clone?

There are several ways to get code from a `GitHub` repository to your
PC:

- To be able to `push` your changes back to a `GitHub` repository to
  which you do **not** have writing access, you need to `fork` the
  repository: use the `fork` button \> `create a new fork`. This creates
  a copy of the repository in your own GitHub repository. Next, you have
  to `clone` your copy to your PC, see the next point.
- To be able to push your changes back to a GitHub repository to which
  you **do** have writing access (e.g., to work on a fork you created in
  the step above; or to work on your project from another PC), you have
  to clone the GitHub repository to your PC: use the green `Code` button
  in the repository (if you forked a repository, you need the `Code`
  button of **your** fork, not of the original repository), copy the URL
  to the clipboard (i.e., do **not** use `download ZIP`), create a new R
  project in RStudio (`File` \> `New Project` \> `Version control` \>
  `Git`), paste the repository URL
  (`https://github.com/<username>/<repository>`) in the designated
  field, select the desired location on your PC, and create the project.
  The same repository URL can be used when using shell commands to clone
  a repository, either with its complete history by using
  `git clone https://github.com/<username>/<repository>` or with only
  the last commit by using
  `git clone --depth=1 https://github.com/<username>/<repository>`.
- To download code without being able to push your changes back to a
  GitHub repository, download the repository by using the green `Code`
  button, choose `Download ZIP` and unzip the downloaded file
  (right-click on them and choose `extract all`). To be able to let R
  use the package correctly, move the package to a location where R
  looks for packages (given by `cat(normalizePath(.libPaths()))`,
  something like `C:\Program Files\R\R-4.6.0\library` or
  `C:\Users\<owner>\AppData\Local\R\win-library\4.6`. Then open the
  `.Rproj` file that has the same name as the repository.

### Installing a package from GitHub

The following code can be used to install packages from
[GitHub](https://github.com/) (for details see the section ‘Installing
packages \> Github’ in the vignette *R packages*:
[`vignette("r_pkgs", package = "checkrpkgs")`](https://jessealderliesten.github.io/checkrpkgs/articles/r_pkgs.md)):

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

### Further documentation

In addition to section [Using GitHub](#using-github) above, see:

- Branches: GitHub documentation about
  [branches](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-branches)
  and <https://learngitbranching.js.org/>

- Cloning (clones) and forking (forks) a repository: GitHub
  documentation about
  [cloning](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
  and
  [forks](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/about-forks)
  and the section [Fork and
  clone](https://happygitwithr.com/fork-and-clone) from [Happy Git and
  GitHub for the useR](https://happygitwithr.com/)

- GitHub documentation about [pull
  requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)

## GitHub Actions

See the section ‘Automate checks’ in the vignette *Package setup* and
section ‘Use GitHub Actions’ in the vignette *Package development*, both
from package `develcoder`:
`vignette("pkg_setup", package = "develcoder")` and
`vignette("pkg_devel", package = "develcoder")`.

## Common shell commands

For an overview of [shell](https://happygitwithr.com/shell) commands,
see the documentation of [Git SCM](https://git-scm.com/docs), the
section about the
[shell](https://happygitwithr.com/shell#basic-shell-commands) from
[Happy Git and GitHub for the useR](https://happygitwithr.com/) (a
summary of which is given below), or in the `BASH shell` type
`git config` or `git help <command>` (replace `<command>` by the command
you want help about).

- list files: `ls` (use `ls -a` to also show hidden files)
- list remote repositories: `git remote -v`
- show status of repositories: `git status`
- show user details: `git config --global --list`
- working directory: change it with `cd` (e.g.,
  `cd 'D:/Userdata/<owner>/Documents/GIT/<somefolder>'`); navigate to
  it: `cd ~`; print it: `pwd`

### Paths in the shell

When entering paths in the [shell](https://happygitwithr.com/shell), use
the forward slash (`/`) as file separator instead of the Windows-default
backslash (`\`). If the path you want to specify contains spaces (e.g.,
`D:\Userdata\My Account\...`), you need to use quotes around the path
(e.g., `"D:/Userdata/My Account/..."`). `Tab`-completion can be used
when entering paths: single `tab` to select an option, double `tab` to
see multiple options. Dragging a file into the shell gives the absolute
path to that file. The current and parent directory can be indicated by
a single (`.`) or two (`..`) dots in file paths, respectively. On paths
and file separators in R, see the ‘Notes on paths’ in
[`help("is_path", package = "checkinput")`](https://jessealderliesten.github.io/checkinput/reference/is_path.html).

## Documentation

Official documentation

- [Git](https://git-scm.com/docs)
- [Git: setting
  up](https://docs.github.com/en/get-started/git-basics/set-up-git),
- [GitHub: setting
  up](https://docs.github.com/en/get-started/onboarding/getting-started-with-your-github-account)
- [GitHub: general](https://docs.github.com/en)
- [GitHub: searching](https://docs.github.com/en/search-github)
- [GitHub: status](https://www.githubstatus.com/)
- [GitHub:
  workflow](https://docs.github.com/en/get-started/using-github/github-flow)

Books

- [Happy Git and GitHub for the useR](https://happygitwithr.com/) by
  Jennifer Bryan
- [Pro Git Book](https://git-scm.com/book/en/v2) by Scott Chacon and Ben
  Straub

Chapters

- [Version
  control](https://docs.posit.co/ide/user/ide/guide/tools/version-control.html)
  from Posit’s [RStudio User
  Guide](https://posit.co/products/open-source/rstudio)
- [Collaboration](https://epirhandbook.com/en/new_pages/collaboration.html)
  from [The Epidemiologist R Handbook](https://epirhandbook.com/en/)
