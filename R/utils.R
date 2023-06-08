#' Reformat DOI to a standard format
#'
#' @param identifier (character) DOI string
#'
#' @return (character) DOI string in standard format, e.g. 10.1029/2020gb006552. Without URL heads like "https://doi.org" or the "doi:" prefix.
#' @export
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
