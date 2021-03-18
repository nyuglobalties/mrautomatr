#' Get omega squared from CFA at each wave
#'
#' @description
#' `get.omega.bywave` creates McDonald's omega from an Mplus CFA model on a given wave data.
#' `calc.omega()` is called to calculate omegas. `loadings` come from factor loadings of the CFA model,
#' and `resid` comes from r2 of the CFA model.
#'
#' @param model Mplus model name
#' @param path Mplus model file path
#'
#' @return A data.frame with two variables: `subscale_wave` and `omega_by_wave`
#'
#' @note Mac users can hit `command + option + c` in finder to quickly get the local file path.

get.omega.bywave <- function(model, path){

  parameters <- readModels(target = file.path(path, model))$parameters

  if(is.null(parameters$stdyx.standardized) == T){
    parameters <- parameters$stdy.standardized
    warning("stdyx.standardized was not calculated in the CFA model, please check the .out file.",
            call. = F)
  } else{
    parameters <- parameters$stdyx.standardized
  }

  parameters <- parameters %>%
    filter(str_detect(paramHeader, ".BY$")) %>%
    select(paramHeader, param, est) %>%
    rename(loadings = est)

  r2 <- readModels(target = file.path(path, model))$parameters$r2

  r2 <- r2 %>%
    select(param, est) %>%
    mutate(resid_var = 1 - est) %>%
    select(-est)

  df <- left_join(parameters, r2, by = "param")

  output <- df %>%
    group_by(paramHeader) %>%
    summarize(omega_by_wave = calc.omega(loadings, resid_var)) %>%
    mutate(subscale_wave = gsub("^([^.]+)(.)(BY)$","\\1", paramHeader)) %>%
    select(subscale_wave, omega_by_wave)

  return(output)
}
