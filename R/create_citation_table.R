#' Create a table of citations from an EDI scope (aka for all datasets under a LTER site)
#'
#' @param scope (character) Example "knb-lter-ble"
#' @param file (character) File path to save CSV at. Defaults to NULL, in which case only a R data.frame is returned
#' @param standalone_dois (character) Character vector of standalone dataset DOIs to look up
#' @param meta (list) List object, output from get_meta_for_all_items_in_scope. Used in debugging case where you don't want to get the metadata from the scope every time this function is called, which can be a lengthy process.
#'
#' @return (data.frame) Table of datasets and DOIs that cite them
#' @export
#'
create_citation_table <- function(scope, file = NULL, standalone_dois = NULL, meta= NULL) {
  cols <- c('scope', 'id',
            'revision',
            'pubdate',
            'title',
            'creators',
            'doi',
            'pubtitle',
            'pubid',
            'citation')
  df <- data.frame(matrix(nrow = 0, ncol = length(cols)))
  colnames(df) <- cols
  #print(df)
  if (is.null(meta)) meta <- get_meta_for_all_items_in_scope(scope)
  for (i in seq_along(meta)) {
    for (item in meta[[i]]) {
      message(paste0('Fetching citations for ', scope, '.', i, '.', item$revision, ' ...'))
      citations <- get_citations_for_doi(item$doi)
      for (citation in seq_along(citations)) {
        df[nrow(df) + 1,] <-
          c(
            scope,
            i,
            item$revision,
            item$pubDate,
            item$title,
            item$creator,
            item$doi,
            ifelse(is.na(citations[[citation]]$title) | is.null(citations[[citation]]$title), '', citations[[citation]]$title),
            ifelse(is.na(citations[[citation]]$identifier) | is.null(citations[[citation]]$identifier), '', citations[[citation]]$identifier),
            ifelse(is.na(citations[[citation]]$citation) | is.null(citations[[citation]]$citation), '', citations[[citation]]$citation)
          )
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
