#' Render measurement report by manually specifying parameters
#'
#' @description
#' This function opens a Shiny app that allows you to manually type in global information about the measurement report
#' and click/unclick sections that you don't want in the report (see README.md for descriptions about each section).
#'
#' @param output_file A string of the name of the output file.
#' @param output_dir A string of the output directory for the rendered `output_file`.
#'
#' @return A docx document.
#' @export
#' @seealso `render_report`, `render_report_multiple`
#' @examples
#' \dontrun{
#'render_report_manual(output_file = "Report_niger_psra.docx",
#'                       output_dir = box_path("Box 3EA Team Folder/For Zezhen/MR automation/NGY1_FA/PSRA")
#'                      )
#'          }
render_report_manual <- function(output_dir, output_file){
  rmarkdown::render(system.file("Rmd", "report_template.Rmd", package = "mrautomatr"),
                    params = "ask",
                    output_file = output_file,
                    output_dir = output_dir)
}
