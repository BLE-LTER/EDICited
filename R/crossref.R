#' Query the CrossRef API to get the details of a publication
#'
#' @param doi (character) A publication's DOI
#'
#' @return (list) A list format with the citation, title, authors, and pubdate. These are empty strings if the API call is unsuccessful.
#' @export
get_citation_for_doi <- function(doi) {
  url <- paste0('https://api.crossref.org/works/', doi)
  citation <- list()

  tryCatch(
    expr = {
      response <- jsonlite::fromJSON(url)
      if (!exists('response') | !is.null(response)) {
        data <- response$message
        citation$doi <- doi

        # The author names are in the 'family' field if present, otherwise use the 'name' field
        authors <- c()
        author_df <- data$author
        for (i in seq_along(nrow(author_df))) {
          if ('family' %in% colnames(author_df)) {
            authors <- c(authors, author_df[i, 'family'])
          } else if ('name' %in% colnames(author_df)) {
            authors <- c(authors, author_df[i, 'name'])
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
                c(preprints, clean_identifier(data$relation[["has-preprint"]][i, 'id']))
            }
          }
        }

        return(citation)
      } else {
        citation$title <- ''
        citation$citation <- ''
        citation$identifier <- ''
        message(paste("Error:", response$status_code, response$reason))
        return(citation)
      }
    },
    # return empty everything if the API fails
    error = function(e) {
      citation$title <- ''
      citation$citation <- ''
      citation$identifier <- ''
      message(paste0('CrossRef API call failed for DOI: ', doi, '\n', e))
      return(citation)
    }
  )
}
