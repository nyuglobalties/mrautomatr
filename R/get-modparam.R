#' Get CFA model estimates (for tables)
#'
#' @param model Mplus model name
#' @param path Mplus model file path
#'
#' @return A data.frame of wave tags, corresponding model estimates and SEs
#' @export
#' @note stdyx.standardized is used if available. Otherwise, stdy.standardized is used.
#' @seealso `get.est`
#' @importFrom magrittr %>%
get.modparam <- function(model, path){

  output <- MplusAutomation::readModels(target = file.path(path,model))$parameters

  if(is.null(output$stdyx.standardized) == T){
    output <- output$stdy.standardized
    warning("stdyx.standardized was not calculated in the Mplus model, please check the .out file.",
            call. = F)
  } else{
    output <- output$stdyx.standardized
  }

  output <- tibble::as_tibble(output)

  # accepts item names and threshold names with or without wave tags
  output <- output %>%
    dplyr::mutate(
    param = gsub( "^(.*)_(\\d+)(.*)$", "\\1", param)
  ) %>%
    dplyr::filter(paramHeader != "Thresholds")


  wave <- paste("_",
                "T",
                gsub("^([a-zA-Z]+)(\\d+)(.*)$", "\\2", model),
                sep = "")

  output <- output %>%
    dplyr::rename_with(~paste( .x, wave, sep = ""), !dplyr::starts_with("param"))

  return(output)
}
