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
#' @export
#' @note Mac users can hit `command + option + c` in finder to quickly get the local file path.
#' @importFrom magrittr %>%

get.omega.lg <- function(model, path){

  df <- MplusAutomation::readModels(target = file.path(path, model))$parameters

  if(is.null(df$stdyx.standardized) == T){
    df <- df$stdy.standardized
    warning("stdyx.standardized was not calculated in the scalar invariance Mplus model, please check the .out file.",
            call. = F)
  } else{
    df <- df$stdyx.standardized
  }

  df <- tibble::as_tibble(df)

  df <- df %>%
    dplyr::filter(stringr::str_detect(paramHeader, "(.*)(.)(BY)$|Residual.Variances")) %>%
    dplyr::mutate(type = gsub("^([^.]+)(.)([a-zA-Z]+)$", "\\3", paramHeader)) %>%
    dplyr::group_by(type) %>%
    dplyr::group_split()

  df <- dplyr::left_join(df[[1]] %>%
                    dplyr::select(paramHeader, param, est) %>%
                    dplyr::rename(loadings = est),

                  df[[2]] %>%
                    dplyr::select(param, est) %>%
                    dplyr::rename(resid_var = est),

                  by = "param"
  )

  output <- df %>%
    dplyr::group_by(paramHeader) %>%
    dplyr::summarize(omega_lg = calc.omega(loadings, resid_var)) %>%
    dplyr::mutate(subscale_wave = gsub("^([^.]+)(.)(BY)$","\\1", paramHeader)) %>%
    dplyr::select(subscale_wave, omega_lg)


  return(output)

}
