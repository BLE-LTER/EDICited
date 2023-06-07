

#' Title
#'
#' @param identifier
#'
#' @return
#' @export
#'
#' @examples
clean_identifier <- function(identifier) {
  identifier <- trimws(sub(" ", "", identifier))

  if (any(grepl("https://doi.org", identifier))) {
    identifier <- sub("https://doi.org/", "", identifier)
  }
  if (any(grepl("doi:", identifier))) {
    identifier <- sub("doi:", "", identifier)
  }
  identifier <- trimws(sub(" ", "", identifier))
  return(identifier)
}
