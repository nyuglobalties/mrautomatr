#' Get CFA model fit
#'
#' @param model Mplus model name
#' @param path Mplus model file path
#'
#' @return A data.frame of CFA model fits
#'
#' @seealso `mplus.version.fit.short`
get.cfa.fit <- function(model, path){

  output <- readModels(target = file.path(path,model))$summaries

  if(is.null(output) == T){stop("Model fits were not calculated in the Mplus model, please check the .out file.",call. = F)}

  output <- as_tibble(output)

  output <- mplus.version.fit.short(output)

  return(output)
}
