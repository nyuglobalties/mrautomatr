# check if mplus is in version 8
check.mplus.version.invariance <- function(model){

  if(as.numeric(model$Mplus.version) > 8){ # (Column `SRMR` doesn't exist. because the models output from Mplus 7 don't have SRMR)
    model.s <- select(model, Parameters:RMSEA_Estimate, SRMR, Filename)} else{
      warning("Upgrade Mplus to Version 8 to include SRMR as a model fit index. Mplus Version 7 reports WRMR instead.")
      model.s <- select(model, Parameters:RMSEA_Estimate, WRMR, Filename)
    }

  return(model.s)
}
