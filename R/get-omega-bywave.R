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
#' @export
#' @note Mac users can hit `command + option + c` in finder to quickly get the local file path.
#' @importFrom magrittr %>%

get.omega.bywave <- function(model, path){

  parameters <- MplusAutomation::readModels(target = file.path(path, model))$parameters

  if(is.null(parameters$stdyx.standardized) == T){
    parameters <- parameters$stdy.standardized
    warning("stdyx.standardized was not calculated in the CFA model, please check the .out file.",
            call. = F)
  } else{
    parameters <- parameters$stdyx.standardized
  }

  parameters <- parameters %>%
    dplyr::filter(stringr::str_detect(paramHeader, ".BY$")) %>%
    dplyr::select(paramHeader, param, est) %>%
    dplyr::rename(loadings = est)

  r2 <- MplusAutomation::readModels(target = file.path(path, model))$parameters$r2

  r2 <- r2 %>%
    dplyr::select(param, est) %>%
    dplyr::mutate(resid_var = 1 - est) %>%
    dplyr::select(-est)

  df <- dplyr::left_join(parameters, r2, by = "param")

  output <- df %>%
    dplyr::group_by(paramHeader) %>%
    dplyr::summarize(omega_by_wave = calc.omega(loadings, resid_var)) %>%
    dplyr::mutate(subscale_wave = gsub("^([^.]+)(.)(BY)$","\\1", paramHeader)) %>%
    dplyr::select(subscale_wave, omega_by_wave)

  return(output)
}
