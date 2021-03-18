# get CFA R-squared
get.R2 <- function(model, path){

  output <- readModels(target = file.path(path,model))$parameters$r2

  if(is.null(output) == T){stop("R2 was not calculated in the Mplus model, please check the .out file.",call. = F)}

  output <- as_tibble(output)

  # accepts item names and threshold names with or without wave tags
  output <- output %>% mutate(
    param = gsub( "^(.*)_(\\d+)(.*)$", "\\1", param)
  )

  wave <- paste("_",
                "T",
                gsub("^([a-zA-Z]+)(\\d+)(.*)$", "\\2", model),
                sep = "")

  output <- output %>% rename_with(~paste( .x, wave, sep = ""), !starts_with("param"))


  return(output)
}
