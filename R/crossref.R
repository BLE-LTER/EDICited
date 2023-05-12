get_citation_for_doi <- function(doi) {
  url <- paste0('https://api.crossref.org/works/', doi)
  response <- httr::GET(url)
  citation <- list()

  if (response$status_code == 200) {
    data <- response$message
    citation$doi <- doi

    # The author names are in the 'family' field if present, otherwise use the 'name' field
    authors <- c()
    for (i in seq_along(data$author)) {
      if ('family' %in% names(author)) {
        authors <- c(authors, author$family)
      } else if ('name' %in% names(author)) {
        authors <- c(authors, author$name)
      } else
        stop("Error: author name not found")
    }

    citation$authors <- paste(authors, collapse = ", ")
    citation$title <- data$title[[1]]
    citation$year <- data$created[['date-parts']][[1]][[1]]
    citation$citation <-
      paste0(
        citation$authors,
        " (",
        citation$year,
        "). ",
        citation$title,
        ". doi:",
        citation$doi
      )

    # # Add preprint if present, to help spot them later if the client wants to filter out preprints
    preprints <- c()
    if ('relation' %in% names(data)) {
      if ('has-preprint' %in% names(data$relation)) {
        for (i in seq_along(data$relation[['has-preprint']])) {
          preprints <-
            c(preprints, clean_identifier(data$relation[["has-preprint"]][[i]]$id))
        }
      }
    }
  } else
    stop(paste("Error:", response$status_code, response$reason))

  return(citation)
}
