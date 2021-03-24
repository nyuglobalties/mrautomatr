#' Get CFA model fit
#'
#' @param model Mplus model name
#' @param path Mplus model file path
#'
#' @return A data.frame of CFA model fits
#' @export
#' @seealso `mplus.version.fit.short`
get.cfa.fit <- function(model, path){

  output <- MplusAutomation::readModels(target = file.path(path,model))$summaries

  if(is.null(output) == T){stop("Model fits were not calculated in the Mplus model, please check the .out file.",call. = F)}

  output <- tibble::as_tibble(output)

  output <- mplus.version.fit.short(output)

  return(output)
}
