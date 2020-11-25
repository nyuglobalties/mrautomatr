template_settings <- function(index, text, subscale, model) {
  stopifnot(is.character(index))
  stopifnot(is.data.frame(text))
  stopifnot(is.data.frame(subscale))
  stopifnot(is.data.frame(model))

  structure(
    list(
      title = title,
      text = text,
      subscale = subscale,
      model = model
    ),
    class = "tmpl_settings"
  )
}

template_settings_from_xlsx <- function(path, index) {
  template_settings(
    index,
    openxlsx::read.xlsx(path, sheet = "text"),
    openxlsx::read.xlsx(path, sheet = "subscale"),
    openxlsx::read.xlsx(path, sheet = "model")
  )
}

is_template_settings <- function(x) {
  inherits(x, "tmpl_settings")
}

tmpl_index <- function(x) {
  stopifnot(is_template_settings(x))

  x$index
}

tmpl_text <- function(x) {
  stopifnot(is_template_settings(x))

  x$text
}

tmpl_subscale <- function(x) {
  stopifnot(is_template_settings(x))

  x$subscale
}

tmpl_model <- function(x) {
  stopifnot(is_template_settings(x))

  x$model
}
