# get measurement invariance model fits

get.invariance <- function(inv_models, path){

  config = inv_models[1]
  if(is.na(config) == T){stop("Configural invariance model was not available, please add to the source folder.",call. = T)}

  metric = inv_models[2]
  if(is.na(metric) == T){stop("Metric invariance model was not available, please add to the source folder.",call. = T)}

  scalar = inv_models[3]
  if(is.na(scalar) == T){stop("Scalar invariance model was not available, please add to the source folder.",call. = T)}


  x1 <- readModels(target = file.path(path,config))$summaries
  if(is.null(x1) == T){stop("Model fits were not calculated in the configural invariance model, please check the .out file.",call. = F)}

  x2 <- readModels(target = file.path(path,metric))$summaries
  if(is.null(x2) == T){stop("Model fits were not calculated in the metric invariance model, please check the .out file.",call. = F)}

  x3 <- readModels(target = file.path(path,scalar))$summaries
  if(is.null(x2) == T){stop("Model fits were not calculated in the scalar invariance model, please check the .out file.",call. = F)}


  output_config <- as_tibble(x1)
  output_metric <- as_tibble(x2)
  output_scalar <- as_tibble(x3)

  output_config <- check.mplus.version.invariance(output_config)
  output_metric <- check.mplus.version.invariance(output_metric)
  output_scalar <- check.mplus.version.invariance(output_scalar)

  output <- bind_rows(output_config, output_metric, output_scalar)
  output <- select(output, -c(CFI:Filename), CFI:Filename)

  return(output)
}
