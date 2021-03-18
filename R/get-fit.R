# get CFA model fit
get.fit <- function(model, path){

  output <- readModels(target = file.path(path,model))$summaries

  if(is.null(output) == T){stop("Model fits were not calculated in the Mplus model, please check the .out file.",call. = F)}

  output <- as_tibble(output)

  output <- check.mplus.version.fit(output)

  return(output)
}
