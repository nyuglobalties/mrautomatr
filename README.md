# Measurement Report Automation Project (`mrautomatr`)

## 1. Project overview

This project is developed to generate lengthy but informative measurement reports from survey data and Mplus measurement models. Typically, a research institute has the obligation to generate detailed measurement reports to better inform the funders and the cooperating agencies. However, even with a Word template, the process from analysis results to a publishable report is unnecessarily long and prone to mistakes for the most careful research assistant. Therefore, we develop a solution in `R` and `Rstudio` to address this need. Currently, the project only suits the need of NYU Global TIES, where we can impose naming rules for files and variables, and most people use Mplus for measurement modeling and STATA for other analyses. Future adaptations are needed as people move their analysis to `R`.

The project workflow is shown below: the users specify parameters in an excel sheet and move several files to a destined folder, run a command in R, and (boom!) there is a well-formatted measurement report.

[MR Automatization Flowchart_detailed.pdf](https://github.com/nyuglobalties/MR-automation/files/5293216/MR.Automatization.Flowchart_detailed.pdf) <img src="https://user-images.githubusercontent.com/26876926/94450457-509cf180-017b-11eb-97e1-dc297ba55d1a.png" alt="Screen Shot 2020-09-28 at 11 11 00 AM" width="1017"/>

## 2. How to use it?

### Step 0: Install the necessary softwares

You need to set up `R` and `Rstudio` on your computer before everything. `R` is the programming language that powers this project, and `Rstudio` is the interface that allows you better interact with your R code. Please follow the steps below:

-   Download `R` [here](https://cran.r-project.org/mirrors.html) and install it before you install `Rstudio`.
-   Download `Rstudio` [here](https://rstudio.com/products/rstudio/download/#download) and install it.
-   Open Rstudio, and click the first icon from the left on the Rstudio toolbar, and select R Markdown. Rstudio will prompt you to install several packages, just follow the instructions and install them.

### Step 1: Download the package

-   Run the following lines:

```
    install.packages("devtools")
    devtools::install_github("nyuglobalties/mrautomatr")
```
-   Check out the functions by running `?function_name`:
```
    ?mrautomatr
```

### Step 2: Set the parameters

Before you run any R codes, you need to make sure that the parameters for the report are correctly specified.

-   First, copy and paste all **currently available** final Mplus models (only the `.out` files) into a separate folder (e.g. on Box). This includes:

    -   EFA models
    -   CFA models
    -   Longitudinal invariance models
    -   Treatment invariance models
    -   Age invariance models
    -   Gender invariance models

-   Second, fill in the excel sheet in the `Template` folder. Currently there are two test excel sheets that have the same template, which correspond to the two Word documents in the project folder. For your own purposes, please fill in your own parameters according to the template and delete the two excel sheets. We will update the project to an R package structure, which won't have you delete anything. Specifically, you need to set the following parameters. For any parameters that are not available temporarily, you can leave blank and still be able to generate the report (with errors in the Word document telling you that you need to specify more parameters to have a full report).

    -   **Tab 1:** `path` (A shorthand to get file path on Mac: go to the path/file and hit `command + option + C`)

        -   `year` will show up in the first line of your document (not the title).

        -   `measure` will show up in the first line of your document.

        -   `data_file_path` should be wherever the final master data is located. It will be used to calculate summary statistics and bivariate correlations. Our tool currently takes the following data formats: `.csv`, `.xlsx`, `.dta`.

        -   `fs_data_file_path` refers to the file path where the tabular data of the Mplus-generated factor scores is saved. Because Mplus **does not** generate a spreadsheet, you will need to:

            -   **(1) copy and paste the factor scores into an excel sheet, and**
            -   **(2) insert the first row and name the variables exactly the same as they are in your master dataset and in your other Mplus models.**
            -   **(3) save the sheet either as a .csv or an .xlsx file.**

        -   `model_file_path` leads you to all the Mplus outputs.

    -   **Tab 2:** `subscale`

        -   The first row should contain the subscale/factor names. They should be the same as the ones in your Mplus models.
        -   For each subscale/factor, list the items. The rows can be of unequal length (i.e. you can leave blanks for subscales with smaller number of items).
        -   These are specified to generate reliability estimates from the master dataset.

    -   **Tab 3:** `model`

        -   This specifies all necessary Mplus model names (i.e. `xxx.out`).
        -   List all available models in the order of waves (e.g. wave 1 before wave 2).
        -   There is no restrictions on the file names, but please follow the naming rules for reproducibility purposes.

    -   **Tab 4:** `description`

        -   This is specified to have a description of the items at the beginning of the report.
        -   You can format this tab in any ways that you like, but the caveat is that (1) the first row will be taken as the header and set to bold, and (2) you cannot merge cells.

| Variable name       | Description                                                      |
|:--------------------|:-----------------------------------------------------------------|
| `year`              | Study site and year                                              |
| `measure`           | Measure name                                                     |
| `data_file_path`    | Local file path to the master dataset on your own computer       |
| `fs_data_file_path` | Local file path to the factor score dataset on your own computer |
| `model_file_path`   | Local file path to all the Mplus .out files                      |
| `subscale`          | Subscales and their corresponding items                          |
| `model_efa`         | EFA models                                                       |
| `model_cfa`         | CFA models                                                       |
| `model_inv_tx`      | Treatment invariance models                                      |
| `model_inv_gender`  | Gender invariance models                                         |
| `model_inv_age`     | Age invariance models                                            |
| `model_inv_lg`      | Longitudinal invariance model                                    |
| `description`       | Detailed item descriptions                                       |

### Step 3: Generate the report

After carefully setting your parameters, you can now generate your report!

There are three ways to generate reports:

1.  Generate one report for one measure using the default settings `render_report()`

2.  Generate one report for one measure using customized settings by the users `render_report_manual()`

3.  Generate multiple separate reports for multiple measures using default settings `render_report_multiple()`

<img src="https://user-images.githubusercontent.com/26876926/102844602-c52da800-43d9-11eb-9900-1d23663a327a.png" alt="Screen Shot 2020-12-21 at 10 13 31 PM" width="236"/>

| Parameters                 | Description                                                                                                                                                                               |
|:---------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `printcode`                | whether you'd like R codes to be printed in your document                                                                                                                                 |
| `printwarning`             | whether you'd like to print warnings in running the codes                                                                                                                                 |
| `storecache`               | whether you'd like to store `knitr` cache (only for programming purposes, see [here](https://bookdown.org/yihui/rmarkdown-cookbook/cache.html))                                           |
| `set_title`                | title                                                                                                                                                                                     |
| `set_author`               | author                                                                                                                                                                                    |
| `template`                 | parameter template file path                                                                                                                                                              |
| `item`                     | print item descriptions                                                                                                                                                                   |
| `descriptive`              | print descriptive statistics table                                                                                                                                                        |
| `ds_plot`                  | print descriptive statistics histograms                                                                                                                                                   |
| `correlation_matrix_lg`    | print factor-level correlation matrix from longitudinal invariance model                                                                                                                  |
| `correlation_matrix_bivar` | print factor-level correlation matrix from master dataset                                                                                                                                 |
| `correlation_matrix_item`  | print item-level correlation matrix from master dataset (set to `FALSE` because correlations among dozens of items may be unnecessary)                                                    |
| `efa_screeplot`            | print EFA screeplot at all waves                                                                                                                                                          |
| `cfa_model_fit`            | print CFA model fits at all waves                                                                                                                                                         |
| `cfa_model_plot`           | print CFA model path diagram (for the first specified CFA model; i.e. Time 1; assuming factor structure does not change)                                                                  |
| `cfa_model_parameters`     | print CFA model parameters at all waves (factor loadings and thresholds)                                                                                                                  |
| `cfa_r2`                   | print CFA model R-squared at all wave                                                                                                                                                     |
| `internal_reliability`     | print estimates of internal reliability (Cronbach's Alpha and McDonald's Omega, descriptions of the other indices can be found [here](https://personality-project.org/r/html/alpha.html)) |
| `summary_item_statistics`  | print summary item statistics (descriptions of the other indices can be found [here](https://personality-project.org/r/html/alpha.html))                                                  |
| `item_total_statistics`    | print total item statistics (descriptions of the other indices can be found [here](https://personality-project.org/r/html/alpha.html))                                                    |
| `inv_tx`                   | print model fits for treatment invariance models at all waves                                                                                                                             |
| `inv_gender`               | print model fits for gender invariance models at all waves                                                                                                                                |
| `inv_age`                  | print model fits for age invariance models at all waves                                                                                                                                   |
| `inv_lg`                   | print model fit for the longitudinal invariance model                                                                                                                                     |
