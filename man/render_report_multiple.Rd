% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/render-report-multiple.R
\name{render_report_multiple}
\alias{render_report_multiple}
\title{Render multiple measurement reports at once}
\usage{
render_report_multiple(
  input_dir,
  templates = list.files(input_dir, pattern = "^[a-zA-Z].*\\\\.xlsx$"),
  output_dir,
  parameters = NULL
)
}
\arguments{
\item{input_dir}{A string of the input directory where the template files are located}

\item{templates}{A string of prespecified .xlsx templates file names (see README.md); if not specified, all files with the .xlsx suffix will be loaded and run (excel lockfiles "~.xlsx" are excluded).}

\item{output_dir}{A string of the output directory for the rendered output_file. This allows for a choice of an alternate directory to which the output file should be written (the default output directory of that of the input file). If a path is provided with a filename in output_file the directory specified here will take precedence. Please note that any directory path provided will create any necessary directories if they do not exist.}

\item{parameters}{A list of the global parameters to be set in the YAML header of the Rmarkdown template (see README.md)}
}
\value{
Multiple docx documents, each with the title "Report_xxx.docx".
The "xxx" corresponds to any character between "input_template_" and ".xlsx" as specified in \code{templates}.
}
\description{
Render multiple measurement reports at once
}
\examples{
\dontrun{
render_report_multiple(input_dir = box_path("Box 3EA Team Folder/For Zezhen/MR automation/NGY1_FA"),
                       templates = c("input_template_lebanon_cs.xlsx",
                                     "input_template_niger_psra.xlsx"),
                       output_dir = box_path("Box 3EA Team Folder/For Zezhen/MR automation/NGY1_FA"),

                       # set parameters globally for all documents
                       parameters = list(
                       # set R code print options
                       printcode = FALSE,
                       printwarning = FALSE,
                       storecache = FALSE,

                       # set report overall parameters
                       set_author = "Jane Doe",
                       # report title comes from the `year` tab in each excel template

                       # select report sections
                       item = TRUE,
                       descriptive = TRUE,
                       ds_plot = TRUE,
                       correlation_matrix_lg = TRUE,
                       correlation_matrix_bivar = TRUE,
                       correlation_matrix_item = FALSE, # BE CAREFUL! This might crash the document.
                       efa_screeplot = TRUE,
                       cfa_model_fit = TRUE,
                       cfa_model_plot = TRUE,
                       cfa_model_parameters = TRUE,
                       cfa_model_thresholds = FALSE, # default is to mute the thresholds as the table can get very long
                       cfa_r2 = TRUE,
                       internal_reliability = TRUE,
                       summary_item_statistics = TRUE,
                       item_total_statistics = TRUE,
                       inv_tx = TRUE,
                       inv_gender = TRUE,
                       inv_age = TRUE,
                       inv_lg = TRUE)
                       )
       }
}
\seealso{
\code{render_report_manual}, \code{render_report_multiple}
}
