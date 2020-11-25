`%??%` <- function(x, y) if (is.null(x)) y else x

`%if_empty%` <- function(x, y) if (length(x) == 0) y else x

`%if_empty_string%` <- function(x, y) {
  stopifnot(length(x) == 1)

  if (x == "") y else x
}

warn0 <- function(...) {
  warning(..., call. = FALSE, immediate. = TRUE)
}

stop0 <- function(...) {
  stop(..., call. = FALSE)
}

stopg <- function(x, .env = parent.frame()) {
  stop0(glue_collapse(glue(x, .envir = .env)))
}

#' Suppress cat messages from MplusAutomation
sup.cat <- function(code) {
  withr::with_output_sink(nullfile(), code)
}

#' Split list into even chunks
split.list <- function(lst, k) {
  n <- length(lst)

  split(
    lst,
    rep(1:ceiling(n/k),
    each=k)[1:n]
  )
}

trim_trailing_nas <- function(x) {
  stopifnot(is.vector(x) || is.null(x))

  if (length(x) == 0) {
    return(NULL)
  } else if (all(is.na(x))) {
    return(NULL)
  } else if (all(!is.na(x))) {
    return(x)
  }

  not_na <- which(!is.na(x))
  is_na <- which(is.na(x))

  range_not_na <- (min(not_na):max(not_na))
  range_is_na <- (min(is_na):max(is_na))

  if (length(intersect(range_not_na, range_is_na)) != 0) {
    stop0("Unsafe operation: NAs dispersed among values, not just trailing")
  }

  if (!1 %in% not_na) {
    stop0("Unsafe operation: NAs lead values, not trail")
  }

  x[!is.na(x)]
}
