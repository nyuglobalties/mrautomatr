#' Get omega squared from longitudinal invariance models
#'
#' @description
#' `get.omega.lg` creates McDonald's omega from an Mplus longitudinal invariance model.
#' `calc.omega()` is called to calculate omegas. `loadings` come from factor loadings in stdyx.standardized,
#' and `resid` comes from resid_var.
#'
#' @param model Mplus model name
#' @param path Mplus model file path
#'
#' @return A data.frame with two variables: `subscale_wave` and `omega_lg`
#'
#' @note Mac users can hit `command + option + c` in finder to quickly get the local file path.

get.omega.lg <- function(model, path){

  df <- readModels(target = file.path(path, model))$parameters

  if(is.null(df$stdyx.standardized) == T){
    df <- df$stdy.standardized
    warning("stdyx.standardized was not calculated in the scalar invariance Mplus model, please check the .out file.",
            call. = F)
  } else{
    df <- df$stdyx.standardized
  }

  df <- as_tibble(df)

  df <- df %>%
    filter(str_detect(paramHeader, "(.*)(.)(BY)$|Residual.Variances")) %>%
    mutate(type = gsub("^([^.]+)(.)([a-zA-Z]+)$", "\\3", paramHeader)) %>%
    group_by(type) %>%
    group_split()

  df <- left_join(df[[1]] %>%
                    select(paramHeader, param, est) %>%
                    rename(loadings = est),

                  df[[2]] %>%
                    select(param, est) %>%
                    rename(resid_var = est),

                  by = "param"
  )

  output <- df %>%
    group_by(paramHeader) %>%
    summarize(omega_lg = calc.omega(loadings, resid_var)) %>%
    mutate(subscale_wave = gsub("^([^.]+)(.)(BY)$","\\1", paramHeader)
    ) %>%
    select(subscale_wave, omega_lg)


  return(output)

}
