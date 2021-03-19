#' Render multiple measurement reports at once
#'
#' @return Multiple docx documents, each with the name "Report_index.docx". Index is extracted from the file name of the input templates.

render_report_multiple <- function(){

  # get input template file names
  input_templates <- paste0("Template/", list.files("Template", pattern = "^[a-zA-Z].*\\.xlsx$"))

  # get measure names
  index <- gsub("(Template/input_template_)(.*)(\\.xlsx)$", "\\2", input_templates)

  # get document titles
  title <- c()
  for(i in 1:length(input_templates)){
    title[i] <- openxlsx::read.xlsx(input_templates[i], sheet = 1)$year
  }


# rendering the Rmd document in a new R session so that objects in the current R session will not pollute the Rmd document

  for (i in 1:length(input_templates)) {

    xfun::Rscript_call(
      rmarkdown::render,
      list(input =  "child.Rmd",
           params = list(
             template = input_templates[i],
             set_title = title[i]
           ),
           output_file = paste0("Report_", index[i], ".docx")
      )
    )

  }
}
