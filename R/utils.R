

#' Title
#'
#' @param identifier
#'
#' @return
#' @export
#'
#' @examples
clean_identifier <- function(identifier) {
  if (!all(grepl("https://doi.org", identifier))) {
    identifier <- sub("https://doi.org", "", identifier)
  }
  if (any(grepl("doi:", identifier))) {
    identifier <- sub("doi:", "", identifier)
  }
  return(identifier)
}
