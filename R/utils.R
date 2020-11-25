warn0 <- function(...) {
  warning(..., call. = FALSE, immediate. = TRUE)
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
