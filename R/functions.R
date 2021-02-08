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
    read_csv(path)
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

# get correlation matrix from longitudinal invariance model
get.cor.lg <- function(model, path, string){

  output <- readModels(target = file.path(path, model))$parameters
  
  if(is.null(output$stdyx.standardized) == T){
    x <- output$stdy.standardized
    warning("stdyx.standardized was not calculated in the Mplus model, please check the .out file.",
            call. = F)
  } else{
    x <- output$stdyx.standardized
  }
  
  x <- x[grepl(string,x$paramHeader),]
  x$paramHeader <- substr(x$paramHeader, 1, nchar(x$paramHeader)-5)
  
  rc_n <- length(unique(c(x$param,x$paramHeader)))
  df <- as.data.frame(matrix(nrow = rc_n, ncol = rc_n))
  rownames(df) <- colnames(df) <- unique(c(x$param,x$paramHeader))
  
  index1 <- data.frame(paramHeader = rownames(df), index1 = 1:rc_n)
  index2 <- data.frame(param = rownames(df), index2 = 1:rc_n)
  
  x <- left_join(x, index1, by = c("paramHeader"))
  x <- left_join(x, index2, by = c("param"))
  
  for (i in 1:nrow(x)) {
    
    r <- format(round(x$est[i],3),nsmall = 3)
    p <- x$pval[i]
    mystars <- ifelse(p < .001, "***", ifelse(p < .01, "**", ifelse(p < .05, "*", "")))
    df[x$index1[i], x$index2[i]] <- paste(r, mystars, sep = "")
    
  }
  
  df[is.na(df)]<- "--"
  names(df) <- 1:nrow(df)
  rownames(df) <- paste(1:nrow(df), ". ", rownames(df), sep = "")
  return(df)
}

# get bivariate correlation matrix from factor scores
get.cor.bivar <- function(fs_data){ 
  x <- as.matrix(fs_data) 
  R <- Hmisc::rcorr(x)$r 
  p <- Hmisc::rcorr(x)$P 
  
  ## define notions for significance levels; spacing is important.
  mystars <- ifelse(p < .001, "***", ifelse(p < .01, "**", ifelse(p < .05, "*", "")))
  
  ## trunctuate the matrix that holds the correlations to two decimal
  R <- format(round(cbind(rep(-1.11, ncol(x)), R), 3))[,-1] 
  
  ## build a new matrix that includes the correlations with their apropriate stars 
  df <- matrix(paste(R, mystars, sep=""), ncol=ncol(x)) 
  diag(df) <- paste(diag(R), " ", sep="") 
  rownames(df) <- colnames(x) 
  colnames(df) <- paste(colnames(x), "", sep="") 
  
  ## remove upper triangle
  df <- as.matrix(df)
  df[upper.tri(df, diag = TRUE)] <- "--"
  df[upper.tri(df)] <- ""
  df <- as.data.frame(df) 
  
  ## remove last column and return the matrix (which is now a data frame)
  df <- cbind(df[1:length(df)])
  
  df[is.na(df)]<- "--"
  names(df) <- 1:nrow(df)
  rownames(df) <- paste(1:nrow(df), ". ", rownames(df), sep = "")
  return(df)
} 

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

# get CFA model fit
get.fit <- function(model, path){
  
  output <- readModels(target = file.path(path,model))$summaries
  
  if(is.null(output) == T){stop("Model fits were not calculated in the Mplus model, please check the .out file.",call. = F)}
  
  output <- as_tibble(output)
  
  output <- check.mplus.version.fit(output)
  
  return(output)
}

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

# get CFA model parameters
get.modparam <- function(model, path){
  
  output <- readModels(target = file.path(path,model))$parameters
  
  if(is.null(output$stdyx.standardized) == T){
    output <- output$stdy.standardized
    warning("stdyx.standardized was not calculated in the Mplus model, please check the .out file.",
            call. = F)
  } else{
    output <- output$stdyx.standardized
  }
  
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

# check if mplus is in version 8
check.mplus.version.invariance <- function(model){
  
  if(as.numeric(model$Mplus.version) > 8){ # (Column `SRMR` doesn't exist. because the models output from Mplus 7 don't have SRMR)
    model.s <- select(model, Parameters:RMSEA_Estimate, SRMR, Filename)} else{
      warning("Upgrade Mplus to Version 8 to include SRMR as a model fit index. Mplus Version 7 reports WRMR instead.")
      model.s <- select(model, Parameters:RMSEA_Estimate, WRMR, Filename)    
    }
  
  return(model.s)
}

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

# function to calculate omega squared from CFA models
calc.omega <- function(loadings, resid){
  
  omega <- (sum(loadings, na.rm = T))^2 / ( (sum(loadings, na.rm = T))^2 + sum(resid, na.rm = T) )
  omega <- round(omega, digits = 3)
  
  return(omega)
  
}

# get omega squared from longitudinal invariance model
get.omega.lg <- function(model, path){
  
  df <- readModels(target = file.path(path, model))$parameters
  
  if(is.null(df$stdyx.standardized) == T){
    df <- df$stdy.standardized
    warning("stdyx.standardized was not calculated in the scalar invariance Mplus model, please check the .out file.",
            call. = F)
  } else{
    df <- df$stdyx.standardized
  }
  
  df <- as_tibble(df)
  
  df <- df %>% 
    filter(str_detect(paramHeader, "(.*)(.)(BY)$|Residual.Variances")) %>%
    mutate(type = gsub("^([^.]+)(.)([a-zA-Z]+)$", "\\3", paramHeader)) %>% 
    group_by(type) %>%
    group_split()
  
  df <- left_join(df[[1]] %>% 
                        select(paramHeader, param, est) %>%
                        rename(loadings = est),
                      
                  df[[2]] %>%
                        select(param, est) %>%
                        rename(resid_var = est),
                      
                      by = "param"
                      )
 
   output <- df %>% 
    group_by(paramHeader) %>%
    summarize(omega_lg = calc.omega(loadings, resid_var)) %>%
    mutate(subscale_wave = gsub("^([^.]+)(.)(BY)$","\\1", paramHeader)
           ) %>%
     select(subscale_wave, omega_lg)
     
    
  return(output)
  
}

# get omega squared from CFA at each wave
get.omega.bywave <- function(model, path){
  
  parameters <- readModels(target = file.path(path, model))$parameters
  
  if(is.null(parameters$stdyx.standardized) == T){
    parameters <- parameters$stdy.standardized
    warning("stdyx.standardized was not calculated in the CFA model, please check the .out file.",
            call. = F)
  } else{
    parameters <- parameters$stdyx.standardized
  }
  
  parameters <- parameters %>% 
    filter(str_detect(paramHeader, ".BY$")) %>%
    select(paramHeader, param, est) %>%
    rename(loadings = est)
  
  r2 <- readModels(target = file.path(path, model))$parameters$r2
  
  r2 <- r2 %>%
    select(param, est) %>%
    mutate(resid_var = 1 - est) %>%
    select(-est)
  
  df <- left_join(parameters, r2, by = "param")
  
  output <- df %>% 
    group_by(paramHeader) %>% 
    summarize(omega_by_wave = calc.omega(loadings, resid_var)) %>%
    mutate(subscale_wave = gsub("^([^.]+)(.)(BY)$","\\1", paramHeader)) %>%
    select(subscale_wave, omega_by_wave)
  
}

# get eigenvalue
get.eigenvalue <- function(model, path){
  
  # read .out as texts
  ev <- readLines(file.path(path,model))
  
  # identify the section for eigenvalues
  begin <- grep("RESULTS FOR EXPLORATORY FACTOR ANALYSIS",ev) + 1
  end <- grep("EXPLORATORY FACTOR ANALYSIS WITH 1 FACTOR", ev) - 1
  
  # select the section
  ev <- ev[begin:end]
  
  # take out useless information
  ev <- ev[!grepl("EIGENVALUES FOR SAMPLE CORRELATION MATRIX|^$|________", ev)]
  
  # the actual values are always in the rows with even numbers
  ev <- ev[1:length(ev) %% 2 == 0]
  
  # remove leading white spaces
  ev <- gsub("^(\\s+)(.*)$", "\\2", ev)
  
  # remove  white spaces in between numbers
  ev <- gsub("(\\s+)", ",", ev)
  
  # unlist and create vector of values
  ev <- as.numeric(unlist(strsplit(ev, ",")))
  
  wave <- paste("T",
                gsub("^([a-zA-Z]+)(\\d+)(.*)$", "\\2", model),
                sep = "")
  
  output <- data.frame(wave = wave, nfactor = 1:length(ev), ev = ev)
  
  return(output)
}
