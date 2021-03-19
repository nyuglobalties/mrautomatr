#' Check Mplus version and get model fits
#' @description
#' This function checks if Mplus.version >= 8, if yes, if it reports SRMR along with other statistics;
#' if no, it reports WRMR, which was built in replace of SRMR in earlier versions of Mplus.
#' In the knitted report, the short version is used for CFA model fits, and the long version is used for invariance model fits.
#' @param df A data.frame from readModels
#'
#' @return A data.frame of invariance model fits
#' "Parameters", "ChiSqM_Value", "ChiSqM_DF", "ChiSqM_PValue"
#' "ChiSqBaseline_Value","ChiSqBaseline_DF","ChiSqBaseline_PValue"
#' "ChiSqDiffTest_Value","ChiSqDiffTest_DF","ChiSqDiffTest_PValue",
#' "SRMR", "CFI", "TLI", "RMSEA_Estimate", "SRMR"/"WRMR", "Filename"
#'
#' @seealso `mplus.version.fit.short`
#' @note This function selects ChiSqBaseline_Value and ChiSqDiffTest_Value and their corresponding df and p value,
#' which are not included in `mplus.version.fit.short`
#' @examples
#' \dontrun{
#' df <- MplusAutomation::readModels(target = file.path(path,model))$summaries
#' mplus.version.fit.long(df)
#' }
mplus.version.fit.long <- function(df){

  if(as.numeric(df$Mplus.version) > 8){ # (Column `SRMR` doesn't exist. because the dfs output from Mplus 7 don't have SRMR)
    df.s <- dplyr::select(df, Parameters:RMSEA_Estimate, SRMR, Filename)} else{
      warning("Upgrade Mplus to Version 8 to include SRMR as a df fit index. Mplus Version 7 reports WRMR instead.")
      df.s <- dplyr::select(df, Parameters:RMSEA_Estimate, WRMR, Filename)
    }

  return(df.s)
}
