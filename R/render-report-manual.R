#' Render measurement report by manually specifying parameters
#'
#' @description
#' This function opens a Shiny app that allows you to type in global information about the measurement report
#' and click/unclick sections that you don't want in the report.
#' @param output_file The name of the output file.
#' @param output_dir The output directory for the rendered `output_file`.
#'
#' @return A docx document.
render_report_manual <- function(output_file, output_dir){
  rmarkdown::render("child.Rmd", params = "ask",
                    output_file = output_file,
                    output_dir = output_dir)
}
