#' Render measurement report
#'
#' @param input_dir A string of the input directory where the template file is located
#' @param template A string of prespecified .xlsx template file name (see README.md)
#' @param index A string of the report file name
#' @param title A string of the report title
#' @param output_dir A string of the output directory for the rendered output_file. This allows for a choice of an alternate directory to which the output file should be written (the default output directory of that of the input file). If a path is provided with a filename in output_file the directory specified here will take precedence. Please note that any directory path provided will create any necessary directories if they do not exist.
#'
#' @return A docx document with the name "Report_index.docx"
#' @export
#' @examples
#' \dontrun{
#' render_report(input_dir = "/Users/michaelfive/Google Drive/NYU/3EA/test",
#'               template = "input_template_lebanon_cs.xlsx",
#'               index = "lebanon_cs",
#'               title = "Lebanon Year 1 (2016-2017)",
#'               output_dir = "/Users/michaelfive/Google Drive/NYU/3EA/test")
#'               }
#' @seealso `render_report`, `render_report_manual`
render_report = function(input_dir, template, index, title, output_dir) {
  rmarkdown::render(
    system.file("Rmd", "report_template.Rmd", package = "mrautomatr"),
    params = list(
      template = file.path(input_dir, template),
      set_title = title
    ),
    output_dir = output_dir,
    output_file = paste0("Report_", index, ".docx")
  )
}
