#' Get CFA model R-squared
#'
#' @param model Mplus model name
#' @param path Mplus model file path
#'
#' @return A data.frame of wave tags, corresponding R2 estimates, SEs, p values and residual variances
#' @importFrom magrittr %>%
get.R2 <- function(model, path){

  output <- MplusAutomation::readModels(target = file.path(path,model))$parameters$r2

  if(is.null(output) == T){stop("R2 was not calculated in the Mplus model, please check the .out file.",call. = F)}

  output <- tibble::as_tibble(output)

  # accepts item names and threshold names with or without wave tags
  output <- output %>%
    dplyr::mutate(
    param = gsub( "^(.*)_(\\d+)(.*)$", "\\1", param)
  )

  wave <- paste("_",
                "T",
                gsub("^([a-zA-Z]+)(\\d+)(.*)$", "\\2", model),
                sep = "")

  output <- output %>%
    dplyr::rename_with(~paste( .x, wave, sep = ""), !dplyr::starts_with("param"))


  return(output)
}
