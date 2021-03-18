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
