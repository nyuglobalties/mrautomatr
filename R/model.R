model_cfa <- function(tmpl) {
  stopifnot(is_template_settings(tmpl))

  trim_trailing_nas(tmpl_model(tmpl)$model_cfa)
}

model_efa <- function(tmpl) {
  stopifnot(is_template_settings(tmpl))

  trim_trailing_nas(tmpl_model(tmpl)$model_efa)
}

model_inv_tx <- function(tmpl) {
  stopifnot(is_template_settings(tmpl))

  inv_tx <- trim_trailing_nas(tmpl_model(tmpl)$model_inv_tx)

  if (!is.null(inv_tx)) {
    inv_tx <- split.list(inv_tx, 3)
  }

  inv_tx
}
