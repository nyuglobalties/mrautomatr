#' Check Mplus version and get model fits
#' @description
#' This function checks if Mplus.version >= 8, if yes, if it reports SRMR along with other statistics;
#' if no, it reports WRMR, which was built in replace of SRMR in earlier versions of Mplus.
#' In the knitted report, the short version is used for CFA model fits, and the long version is used for invariance model fits.
#' @param df A data.frame from readModels
#'
#' @return A data.frame of CFA model fits: "k", "ChiSq", "df", "p", "CFI", "TLI", "RMSEA", "SRMR"/"WRMR", "Filename"
#'
#' @seealso `mplus.version.fit.long`
#' @examples
#' df <- readModels(target = file.path(path,model))$summaries
#' mplus.version.fit.short(df)
mplus.version.fit.short <- function(df){

  if(as.numeric(df$Mplus.version) >= 8){ # (Column `SRMR` doesn't exist. because the dfs output from Mplus 7 don't have SRMR)
    df.s <- select(df, Parameters, ChiSqM_Value, ChiSqM_DF, ChiSqM_PValue, CFI, TLI, RMSEA_Estimate, SRMR, Filename)
    names(df.s) <- c("k", "ChiSq", "df", "p", "CFI", "TLI", "RMSEA", "SRMR", "Filename")} else{
      warning("Upgrade Mplus to Version 8 to include SRMR as a df fit index. Mplus Version 7 reports WRMR instead.")
      df.s <- select(df, Parameters, ChiSqM_Value, ChiSqM_DF, ChiSqM_PValue, CFI, TLI, RMSEA_Estimate, WRMR, Filename)
      names(df.s) <- c("k", "ChiSq", "df", "p", "CFI", "TLI", "RMSEA", "WRMR", "Filename")
    }

  return(df.s)
}
