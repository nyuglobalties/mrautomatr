#' Calculate omega squared from CFA models
#'
#' @description
#' `calc.omega()`takes loadings and residuals from a CFA model
#' to calculate McDonald's Omega (see Revelle & Zinbarg, 2008). It is an intermediate function for
#' `get.omega.bywave()` and `get.omega.lg()`, and therefore shouldn't be run alone.
#'
#' @param loadings Factor loadings from a CFA model
#' @param resid Residuals from a CFA model
#'
#' @return A single omega value
#' @export
#' @seealso `get.omega.bywave()` and `get.omega.lg()`
#'
#' @note Revelle, W., & Zinbarg, R. E. (2008). Coefficients Alpha, Beta, Omega, and the glb: Comments on Sijtsma. Psychometrika, 74(1), 145. https://doi.org/10.1007/s11336-008-9102-z

calc.omega <- function(loadings, resid){

  omega <- (sum(loadings, na.rm = T))^2 / ( (sum(loadings, na.rm = T))^2 + sum(resid, na.rm = T) )
  omega <- round(omega, digits = 3)

  return(omega)

}
