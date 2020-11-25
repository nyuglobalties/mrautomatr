factor_variables <- function(tmpl, fctr) {
  stopifnot(is_template_settings(tmpl))
  stopifnot(is.character(fctr))

  sub <- tmpl_subscale(tmpl)

  if (!fctr %in% names(sub)) {
    stopg("'{fctr}' not found in subscale schema for '{tmpl_index(tmpl)}'")
  }

  vars <- sub[[fctr]]
  trim_trailing_nas(vars)
}
