#' Title
#'
#' @param scope
#' @param file
#' @param standalone_dois
#'
#' @return
#' @export
#'
#' @examples
create_citation_table <- function(scope, file = NULL, standalone_dois = NULL, meta= NULL) {
  df <- data.frame(scope = c(),
                   id = c(),
                   revision = c(),
                   pubdate = c(),
                   title = c(),
                   creators = c(),
                   doi = c(),
                   citation = c())
  if (is.null(meta)) meta <- get_meta_for_all_items_in_scope(scope)
  for (i in seq_along(meta)) {
    for (item in meta[[i]]) {
      message(paste0('Getting citations for ', scope, '.', i, '.', item$revision, ' ...'))
      citations <- get_citations_for_doi(item$doi)
      for (citation in citations) {
        df[nrow(df) + 1, ] <- c(scope, meta[[i]], item$revision, item$pubDate, item$title, item$creator, item$doi, citation$citation)
      }
    }
  }

  # # Get citations for datasets that are not in EDI, but for which we have a DOI
  # I would read these in from a table. But here's a simple example with only one item in the list
  if (!is.null(standalone_dois) & length(standalone_dois) > 0) {
    message('Getting citations for standalone DOIs...')
    for (doi in standalone_dois) {
      message(paste('Getting citations for', doi))
      citations <- get_citations_for_doi(doi)
      for (citation in citations) {
        df[nrow(df) + 1] <- c(scope, NA, NA, NA, NA, NA, doi, citation$citation)
      }
    }

  }
  if (nrow(df) > 0) {

    if (!is.null(file)) {
      message('Writing to file...')
    write.csv(df, file = file, row.names = F)
    }
    return(df)
  } else message('No citations found.')
}
