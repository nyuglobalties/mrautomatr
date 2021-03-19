#' Get measurement invariance model fits
#'
#' @param inv_models A vector of Mplus measurement invariance model name, in the order of config, metric and scalar model names
#' @param path Mplus model file path
#'
#' @return A data.frame of measurement invariance model fits
#'
#' @seealso `mplus.version.fit.long`
get.invariance.fit <- function(inv_models, path){

  config = inv_models[1]
  if(is.na(config) == T){stop("Configural invariance model was not available, please add to the source folder.",call. = T)}

  metric = inv_models[2]
  if(is.na(metric) == T){stop("Metric invariance model was not available, please add to the source folder.",call. = T)}

  scalar = inv_models[3]
  if(is.na(scalar) == T){stop("Scalar invariance model was not available, please add to the source folder.",call. = T)}


  x1 <- MplusAutomation::readModels(target = file.path(path,config))$summaries
  if(is.null(x1) == T){stop("Model fits were not calculated in the configural invariance model, please check the .out file.",call. = F)}

  x2 <- MplusAutomation::readModels(target = file.path(path,metric))$summaries
  if(is.null(x2) == T){stop("Model fits were not calculated in the metric invariance model, please check the .out file.",call. = F)}

  x3 <- MplusAutomation::readModels(target = file.path(path,scalar))$summaries
  if(is.null(x2) == T){stop("Model fits were not calculated in the scalar invariance model, please check the .out file.",call. = F)}


  output_config <- tibble::as_tibble(x1)
  output_metric <- tibble::as_tibble(x2)
  output_scalar <- tibble::as_tibble(x3)

  output_config <- mplus.version.fit.long(output_config)
  output_metric <- mplus.version.fit.long(output_metric)
  output_scalar <- mplus.version.fit.long(output_scalar)

  output <- dplyr::bind_rows(output_config, output_metric, output_scalar)
  output <- dplyr::select(output, -c(CFI:Filename), CFI:Filename)

  return(output)
}
