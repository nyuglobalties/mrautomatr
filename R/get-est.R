#' Get CFA model estimates (for plotting)
#'
#' @param model Mplus model name
#' @param path Mplus model file path
#'
#' @return A data.frame of wave tags and corresponding model estimates
#' @export
#' @note stdyx.standardized is used if available. Otherwise, stdy.standardized is used.
#' @seealso `get.modparam`
#' @importFrom magrittr %>%
#' @importFrom rlang .data

get.est <- function(model, path){

  output <- MplusAutomation::readModels(target = file.path(path,model))$parameters

  if(is.null(output$stdyx.standardized) == T){
    output <- output$stdy.standardized
    warning("stdyx.standardized was not calculated in the Mplus model, please check the .out file.",
            call. = F)
  } else{
    output <- output$stdyx.standardized
  }

  output <- tibble::as_tibble(output)

  wave <- paste("T",
                gsub("^([a-zA-Z]+)(\\d+)(.*)$", "\\2", model),
                ": ",
                sep = "")

  output <- output %>%
    dplyr::filter(grepl(".BY$", .data$paramHeader)) %>%
    dplyr::select(est) %>%
    dplyr::mutate(est = paste(wave, est, "\n", sep = ""))

  return(output)

}
