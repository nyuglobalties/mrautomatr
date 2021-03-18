# get CFA model estimate (for plotting)
get.est <- function(model, path){

  output <- readModels(target = file.path(path,model))$parameters

  if(is.null(output$stdyx.standardized) == T){
    output <- output$stdy.standardized
    warning("stdyx.standardized was not calculated in the Mplus model, please check the .out file.",
            call. = F)
  } else{
    output <- output$stdyx.standardized
  }

  output <- as_tibble(output)

  wave <- paste("T",
                gsub("^([a-zA-Z]+)(\\d+)(.*)$", "\\2", model),
                ": ",
                sep = "")

  output <- output %>%
    filter(grepl(".BY$", paramHeader)) %>%
    select(est) %>%
    mutate(est = paste(wave, est, "\n", sep = ""))

  return(output)

}
