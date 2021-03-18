# check if mplus is in version 8
check.mplus.version.fit <- function(model){

  if(as.numeric(model$Mplus.version) >= 8){ # (Column `SRMR` doesn't exist. because the models output from Mplus 7 don't have SRMR)
    model.s <- select(model, Parameters, ChiSqM_Value, ChiSqM_DF, ChiSqM_PValue, CFI, TLI, RMSEA_Estimate, SRMR, Filename)
    names(model.s) <- c("k", "ChiSq", "df", "p", "CFI", "TLI", "RMSEA", "SRMR", "Filename")} else{
      warning("Upgrade Mplus to Version 8 to include SRMR as a model fit index. Mplus Version 7 reports WRMR instead.")
      model.s <- select(model, Parameters, ChiSqM_Value, ChiSqM_DF, ChiSqM_PValue, CFI, TLI, RMSEA_Estimate, WRMR, Filename)
      names(model.s) <- c("k", "ChiSq", "df", "p", "CFI", "TLI", "RMSEA", "WRMR", "Filename")
    }

  return(model.s)
}
