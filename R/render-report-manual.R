#' Render measurement report by manually specifying parameters
#'
#' @description
#' This function opens a Shiny app that allows you to type in global information about the measurement report
#' and click/unclick sections that you don't want in the report (see README.md for descriptions about each section).
#' @param output_file A string of the name of the output file.
#' @param output_dir A string of the output directory for the rendered `output_file`.
#'
#' @return A docx document.
#' @export
#' @seealso `render_report`, `render_report_multiple`
#' @examples
#' \dontrun{
#' render_report_manual(index = "lebanon_cs",
#'                      output_dir = "/Users/michaelfive/Google Drive/NYU/3EA/test")
#'                     }
render_report_manual <- function(index, output_dir){
  rmarkdown::render(system.file("Rmd", "report_template.Rmd", package = "mrautomatr"),
                    params = "ask",
                    output_file = paste0("Report_", index, ".docx"),
                    output_dir = output_dir)
}
