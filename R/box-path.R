#' Build paths relative to where Box is located
#'
#' Box can be found on multiple locations on a device. This utility
#' searches for common locations, both on macOS and Windows. From
#' there, it builds paths similar to how `file.path()` operates.
#'
#' @param ... String elements that will be combined with the Box
#'   root to form a path (see `?file.path`)
#' @param .box_root A path to where the Box is located, if it is
#'   installed in a non-standard place. If `NULL`, this utility will
#'   also check the "BOX_PATH" environmental variable to see if it's
#'   defined. This method is useful for containerized code.
#' @export
#' @return An absolute, normalized path
#' @examples
#' if (FALSE) {
#'   box_path("Box 3EA Team Folder/Data Management")
#'   box_path("Peru/Data/Full")
#' }
box_path <- function(..., .box_root = NULL) {
  # If env var "BOX_PATH" is available, use it
  if (is.null(.box_root) && nzchar(Sys.getenv("BOX_PATH"))) {
    .box_root <- Sys.getenv("BOX_PATH")
  }

  if (identical(.Platform$OS.type, "windows")) {
    home <- normalizePath(file.path("~", ".."), winslash = "/")
  } else {
    home <- normalizePath("~")
  }

  # Find Box root if .box_root not defined
  if (!is.null(.box_root)) {
    box_true_root <- .box_root
  } else {
    box_true_root <- file.path(home, "Box")
  }

  if (!dir.exists(box_true_root)) {
    box_true_root <- file.path(home, "Box Sync")

    if (!dir.exists(box_true_root)) {
      stop("Cannot find Box root. Please define it with .box_root", call. = FALSE)
    }
  }

  file.path(box_true_root, ...)
}
