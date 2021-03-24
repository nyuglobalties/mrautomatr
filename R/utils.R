# declare global variables (in Mplus .out and imported to R)
utils::globalVariables(
  c("param", "paramHeader", "type","est",
    "Filename", "Parameters", "CFI", "TLI", "RMSEA_Estimate",
    "SRMR", "WRMR", "ChiSqM_Value", "ChiSqM_DF", "ChiSqM_PValue",
    "loadings", "resid_var",
    "subscale_wave", "omega_by_wave", "omega_lg")
)

# check for empty lists
is.empty <- function(x) {
  return(length(x)==0)
}

# load multiple types of data files
read.any <- function(path){

  data <- if(grepl(".dta$", path)){
    haven::read_dta(path) %>%
      haven::zap_labels() # haven label interferes with skim
  } else if(grepl(".xlsx$", path)){
    openxlsx::read.xlsx(path)
  } else if(grepl(".csv$", path)){
    readr::read_csv(path)
  }

  return(data)
}

# split list into even chunks

split.list <- function(model, k){

  n = length(model)

  split(model,
        rep(1:ceiling(n/k),
            each=k)[1:n])
}

# suppress cat messages from MplusAutomation
sup.cat <- function(code){

  withr::with_output_sink(nullfile(),
                          {code}
  )
}
