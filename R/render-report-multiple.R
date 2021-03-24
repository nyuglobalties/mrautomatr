#' Render multiple measurement reports at once
#'
#' @param input_dir A string of the input directory where the template files are located
#' @param templates A string of prespecified .xlsx templates file names (see README.md); if not specified, all files with the .xlsx suffix will be loaded and run (excel lockfiles "~.xlsx" are excluded).
#' @param output_dir A string of the output directory for the rendered output_file. This allows for a choice of an alternate directory to which the output file should be written (the default output directory of that of the input file). If a path is provided with a filename in output_file the directory specified here will take precedence. Please note that any directory path provided will create any necessary directories if they do not exist.
#'
#' @return Multiple docx documents, each with the name "Report_index.docx". Index is extracted from the file name of the input templates.
#' @export
#' @seealso `render_report_manual`, `render_report_multiple`
#' @examples
#' \dontrun{
#' render_report_multiple(input_dir = "/Users/michaelfive/Google Drive/NYU/3EA/test",
#'                        templates = c("input_template_lebanon_cs.xlsx",
#'                                      "input_template_niger_psra.xlsx"),
#'                        output_dir = "/Users/michaelfive/Google Drive/NYU/3EA/test"
#'                       }
render_report_multiple <- function(input_dir,
                                   templates = list.files(input_dir, pattern = "^[a-zA-Z].*\\.xlsx$"),
                                   output_dir){

  # get measure names
  index <- gsub("(input_template_)(.*)(\\.xlsx)$", "\\2", templates)

  # get document titles
  title <- c()
  for(i in 1:length(templates)){
    title[i] <- openxlsx::read.xlsx(file.path(input_dir,templates[i]), sheet = 1)$year
  }


# rendering the Rmd document in a new R session so that objects in the current R session will not pollute the Rmd document

  for (i in 1:length(templates)) {

    xfun::Rscript_call(
      rmarkdown::render,
      list(input =  mrautomatr_path('Rmd/report_template.Rmd'),
           params = list(
             template = templates[i],
             set_title = title[i]
           ),
           output_file = paste0("Report_", index[i], ".docx"),
           output_dir = output_dir
      )
    )

  }
}
