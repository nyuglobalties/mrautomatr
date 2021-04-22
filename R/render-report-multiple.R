#' Render multiple measurement reports at once
#'
#' @param input_dir A string of the input directory where the template files are located
#' @param templates A string of prespecified .xlsx templates file names (see README.md); if not specified, all files with the .xlsx suffix will be loaded and run (excel lockfiles "~.xlsx" are excluded).
#' @param output_dir A string of the output directory for the rendered output_file. This allows for a choice of an alternate directory to which the output file should be written (the default output directory of that of the input file). If a path is provided with a filename in output_file the directory specified here will take precedence. Please note that any directory path provided will create any necessary directories if they do not exist.
#' @param parameters A list of the global parameters to be set in the YAML header of the Rmarkdown template (see README.md)
#'
#' @return Multiple docx documents, each with the title "Report_xxx.docx".
#' The "xxx" corresponds to any character between "input_template_" and ".xlsx" as specified in `templates`.
#' @export
#' @seealso `render_report_manual`, `render_report_multiple`
#' @examples
#' \dontrun{
#' render_report_multiple(input_dir = "/Users/michaelfive/Google Drive/NYU/3EA/test",
#'                        templates = c("input_template_lebanon_cs.xlsx",
#'                                      "input_template_niger_psra.xlsx"),
#'                        output_dir = "/Users/michaelfive/Google Drive/NYU/3EA/test",
#'                        # set parameters globally for all documents
#'                        parameters = list(
#'                        # set R code print options
#'                        printcode = FALSE,
#'                        printwarning = FALSE,
#'                        storecache = FALSE,
#'
#'                        # set report overall parameters
#'                        set_author = "Jane Doe",
#'                        # report title comes from the `year` tab in each excel template
#'
#'                        # select report sections
#'                        item = TRUE,
#'                        descriptive = TRUE,
#'                        ds_plot = TRUE,
#'                        correlation_matrix_lg = TRUE,
#'                        correlation_matrix_bivar = TRUE,
#'                        correlation_matrix_item = FALSE, # BE CAREFUL! This might crash the document.
#'                        efa_screeplot = TRUE,
#'                        cfa_model_fit = TRUE,
#'                        cfa_model_plot = TRUE,
#'                        cfa_model_parameters = TRUE,
#'                        cfa_r2 = TRUE,
#'                        internal_reliability = TRUE,
#'                        summary_item_statistics = TRUE,
#'                        item_total_statistics = TRUE,
#'                        inv_tx = TRUE,
#'                        inv_gender = TRUE,
#'                        inv_age = TRUE,
#'                        inv_lg = TRUE
#'                        ))
#'                       }
render_report_multiple <- function(input_dir,
                                   templates = list.files(input_dir, pattern = "^[a-zA-Z].*\\.xlsx$"),
                                   output_dir,
                                   parameters = NULL){

  # get measure names
  index <- gsub("(input_template_)(.*)(\\.xlsx)$", "\\2", templates)

  # get document titles
  title <- c()
  for(i in 1:length(templates)){
    title[i] <- openxlsx::read.xlsx(file.path(input_dir,templates[i]), sheet = 1)$year
  }


# rendering the Rmd document in a new R session so that objects in the current R session will not pollute the Rmd document

  for (i in 1:length(templates)) {
   rmarkdown::render(input = system.file("Rmd", "report_template.Rmd", package = "mrautomatr"),
                     params = c(
                       list(
                       template = file.path(input_dir, templates[i]),
                       set_title = title[i]),
                       parameters
                       ),
                     output_file = paste0("Report_", index[i], ".docx"),
                     output_dir = output_dir,
                     envir = new.env())
  }
}
# rmarkdown::render(input = system.file("Rmd", "report_template.Rmd", package = "mrautomatr"),
#                   params = list(
#                     template = file.path(input_dir, templates[i]),
#                     set_title = title[i]
#                   ),
#                   output_file = paste0("Report_", index[i], ".docx"),
#                   output_dir = output_dir)


# xfun::Rscript_call(
#   rmarkdown::render,
#   list(input = system.file("Rmd", "report_template.Rmd", package = "mrautomatr"),
#        params = list(
#          template = file.path(input_dir, templates[i]),
#          set_title = title[i]
#        ),
#        output_file = paste0("Report_", index[i], ".docx"),
#        output_dir = output_dir
#   )
# )
