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
