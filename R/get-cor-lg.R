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
