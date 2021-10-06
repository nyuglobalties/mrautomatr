#' Render measurement report
#'
#' @param output_dir A string of the output directory for the rendered output_file. This allows for a choice of an alternate directory to which the output file should be written (the default output directory of that of the input file). If a path is provided with a filename in output_file the directory specified here will take precedence. Please note that any directory path provided will create any necessary directories if they do not exist.
#' @param output_file A string of the name of the output Word document
#' @param parameters A list of the global parameters to be set in the YAML header of the Rmarkdown template (see README.md)
#'
#' @return A docx document with the name specified by the user (e.g. "Report_xxx.docx".)
#' @export
#' @examples
#' \dontrun{
#'render_report(output_dir = box_path("Box 3EA Team Folder/For Zezhen/MR automation/NGY1_FA/PSRA"),
#'                output_file = "Report_niger_psra.docx",
#'                parameters = list(
#'                  # set R code print options
#'                  printcode = FALSE,
#'                  printwarning = FALSE,
#'                  storecache = FALSE,
#'
#'                  # set report overall parameters
#'                  template = file.path(path, "input_template_niger_psra.xlsx"),
#'                  set_title = "Niger Year 1 Measurement Report - Preschool Stress Regulation Assessment (PSRA)",
#'                  set_author = "Jane Doe",
#'
#'                  # select report sections
#'                  item = TRUE,
#'                  descriptive = TRUE,
#'                  ds_plot = TRUE,
#'                  correlation_matrix_lg = TRUE,
#'                  correlation_matrix_bivar = TRUE,
#'                  correlation_matrix_item = FALSE, # BE CAREFUL! This might crash the document.
#'                  efa_screeplot = TRUE,
#'                  cfa_model_fit = TRUE,
#'                  cfa_model_plot = TRUE,
#'                  cfa_model_parameters = TRUE,
#'                  cfa_model_thresholds = FALSE, # default is to mute the thresholds as the table can get very long
#'                  cfa_r2 = TRUE,
#'                  internal_reliability = TRUE,
#'                  summary_item_statistics = TRUE,
#'                  item_total_statistics = TRUE,
#'                  inv_tx = TRUE,
#'                  inv_gender = TRUE,
#'                  inv_age = TRUE,
#'                  inv_lg = TRUE)
#'                  )
#'         }
#' @seealso `render_report`, `render_report_manual`
render_report = function(output_dir,
                         output_file,
                         parameters = NULL) {
  rmarkdown::render(
    system.file("Rmd", "report_template.Rmd", package = "mrautomatr"),
    params = parameters,
    output_dir = output_dir,
    output_file = output_file
  )
}
