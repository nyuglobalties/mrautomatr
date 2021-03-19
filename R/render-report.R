#' Render measurement report
#'
#' @param template A prespecified .xlsx template file (see README.md)
#' @param index A string of the report file name
#' @param title A string of the report title
#' @param output_dir The output directory for the rendered output_file. This allows for a choice of an alternate directory to which the output file should be written (the default output directory of that of the input file). If a path is provided with a filename in output_file the directory specified here will take precedence. Please note that any directory path provided will create any necessary directories if they do not exist.
#'
#' @return A docx document with the name "Report_index.docx"
#'
#' @examples
#' \dontrun{
#' render_report(template = "Template/input_template_lebanon_cs.xlsx",
#'               index = "lebanon_cs",
#'               title = "Lebanon Year 1 (2016-2017)",
#'               output_dir = "~/Box/Box 3EA Team Folder/3EA Analysis/3EA Lebanon_Analysis")
#'               }
render_report = function(template, index, title, output_dir) {
  rmarkdown::render(
    "child.Rmd", params = list(
      template = template,
      set_title = title,
      output_dir = output_dir
    ),
    envir = globalenv(),
    output_file = paste0("Report_", index, ".docx")
  )
}
