# suppress cat messages from MplusAutomation
sup.cat <- function(code){
  
  withr::with_output_sink(nullfile(), 
                          {code}
                          )
}

# get correlation matrix
get.cor <- function(model, string){
  data <- readModels(target = file.path(model_file_path,model))
  x <- data$parameters$stdyx.standardized
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

# get CFA model fit
get.fit <- function(model){
  
  output <- as_tibble(readModels(target = file.path(model_file_path,model))$summaries)
  
  
  output <- select(output, Parameters, ChiSqM_Value, ChiSqM_DF, ChiSqM_PValue, CFI, TLI, RMSEA_Estimate, SRMR, Filename)
  
  names(output) <- c("k", "ChiSq", "df", "p", "CFI", "TLI", "RMSEA", "SRMR", "Filename")
  
  return(output)
}

# get CFA model estimate (for plotting)
get.est <- function(model){
  
  output <- as_tibble(readModels(target = file.path(model_file_path,model))$parameters$stdyx.standardized)
  
  wave <- paste("T",
                gsub("^(.*)([0-9])_(.*)$", "\\2", model),
                ": ",
                sep = "")

  output <- output %>% 
              filter(grepl(".BY$", paramHeader)) %>% 
              select(est) %>% 
              mutate(est = paste(wave, est, "\n", sep = ""))
  
  return(output)
  
}

# get CFA model parameters
get.modparam <- function(model){
  
  output <- as_tibble(readModels(target = file.path(model_file_path,model))$parameters$stdyx.standardized)
  
  wave <- paste("_",
                "T",
                gsub("^(.*)([0-9])_(.*)$", "\\2", model),
                sep = "")
  
  output <- output %>% rename_with(~paste( .x, wave, sep = ""), !starts_with("param"))
  
  return(output)
}

# get CFA R-squared
get.R2 <- function(model){
  
  output <- as_tibble(readModels(target = file.path(model_file_path,model))$parameters$r2)
  
  wave <- paste("_",
                "T",
                gsub("^(.*)([0-9])_(.*)$", "\\2", model),
                sep = "")
  
  output <- output %>% rename_with(~paste( .x, wave, sep = ""), !starts_with("param"))
  
  
  return(output)
}


# check if mplus is in version 8
check.mplus.version <- function(model){
  
  if(as.numeric(model$Mplus.version) >= 8){ # (Column `SRMR` doesn't exist. because the models output from Mplus 7 don't have SRMR)
    model.s <- select(model, Parameters:RMSEA_Estimate, SRMR, Filename)} else{
      warning("Upgrade Mplus to Version 8 to include SRMR as a model fit index. Mplus Version 7 reports WRMR instead.")
      model.s <- select(model, Parameters:RMSEA_Estimate, WRMR, Filename)    
      }
  
  return(model.s)
}


# get measurement invariance model fits

get.invariance <- function(inv_models){
  
  config = inv_models[1]
  metric = inv_models[2]
  scalar = inv_models[3]
  
  output_config <-as_tibble(readModels(target = file.path(model_file_path,config))$summaries)
  output_metric <-as_tibble(readModels(target = file.path(model_file_path,metric))$summaries)
  output_scalar <-as_tibble(readModels(target = file.path(model_file_path,scalar))$summaries)
  
  output_config <- check.mplus.version(output_config)
  output_metric <- check.mplus.version(output_metric)
  output_scalar <- check.mplus.version(output_scalar)
  
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
get.omega <- function(model){
  

  df <- as_tibble(readModels(target = file.path(model_file_path,model))$parameters$stdyx.standardized)
  
  df <- df %>% 
    mutate(type = gsub("(.*)(_)(.*)(\\.)(.*)", "\\5", paramHeader)) %>%
    filter(type %in% c("BY", "Residual.Variances")) %>% 
    group_by(type) %>%
    group_split()
  
  df <- left_join(df[[1]] %>% 
                        select(paramHeader, param, est) %>%
                        rename(loadings = est),
                      
                  df[[2]] %>%
                        select(param, est) %>%
                        rename(resid = est),
                      
                      by = "param"
                      )
 
   output <- df %>% 
    group_by(paramHeader) %>%
    summarize(omega = calc.omega(loadings, resid)) %>%
    mutate(subscale_wave = gsub("^(.*)(_)([0-9])(.BY)$","\\1\\2\\3", paramHeader)
           ) %>%
     select(subscale_wave, omega)
     
    
  return(output)
  
}
