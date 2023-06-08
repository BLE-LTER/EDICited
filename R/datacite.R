#' retrieve citations from datacite REST API
#'
#' @param relationship_child (list)
#' @param citation_type (character)
#' @param citations_list (list)
#' @param clean_identifier (character)
#'
#' @return
#' @export
add_citations_from_relationships <-
  function(relationship_child,
           citation_type,
           citations_list,
           clean_identifier) {
    if ('data' %in% names(relationship_child)) {
      # this is a df too instead of a list
      # so this deviates a bit from the python
      df <- relationship_child$data
      if (class(df) != "data.frame")
        df <- as.data.frame(df)
      for (row in seq_len(nrow(df))) {
        if ('id' %in% colnames(df)) {
          # make sure we dont already have this citation by checking the identifier
          found <- FALSE
          identifier <- clean_identifier(df[row, 'id'])
          for (citation in seq_along(citations_list)) {
            if (is.na(citations_list[[citation]]$identifier) |
                citations_list[[citation]]$identifier == identifier) {
              found <- TRUE
              break
            }
          }
          if (found)
            next

          citation <- list()
          citation$identifier <- identifier
          if ('type' %in% colnames(df)) {
            if (df[row, 'type'] == 'dois')
              citation$identifier_type <- 'DOI'
            else
              citation$identifier_type <- df[row, 'type']
          }
          else
            citation$identifier_type <- 'Unknown'
          citation$type <- citation_type
          citations_list <- c(citations_list, list(citation))
        }
      }
    }
  }


remove_published_preprints <- function(citations) {
  result <- c()
  preprints <- c()
  for (citation in citations) {
    for (preprint in citations$preprints) {
      preprints <- c(preprints, preprint)
    }
  }

  for (citation in citations) {
    if (!citation$identifier %in% preprints)
      result <- c(result, citation)
  }
  return(result)
}

#' Query the DataCite API for publications that have cited a given data DOI
#'
#' @param doi (character) Data package DOI, taken from EDI for example
#'
#' @return (list) Unnamed list of citations
#' @export
#'
get_citations_for_doi <- function(doi) {
  # list of ciations, where each citation is a dictionary
  doi <- clean_identifier(doi)
  citations <- c()
  url <- paste0('https://api.datacite.org/dois/', doi)
  tryCatch(
    expr = {
      response <- jsonlite::fromJSON(url)
    },
    error = function(e) {
      message(paste0('DataCite API call failed for DOI: ', doi, 'Error: ', e))
    }
  )


  if (!is.null(response)) {
    response_json <- response
    citations <- list()
    if ('data' %in% names(response_json)) {
      # get citations from relatedIdentifiers
      if ('attributes' %in% names(response_json$data)) {
        if ('relatedIdentifiers' %in% names(response_json$data$attributes)) {
          # related identifiers is a data frame not a list
          # so this deviates from the python a little bit
          relid_df <-
            response_json$data$attributes$relatedIdentifiers
          if (class(relid_df) != "data.frame")
            relid_df <- as.data.frame(relid_df)
          for (row in seq_len(nrow(relid_df))) {
            if ('relatedIdentifier' %in% colnames(relid_df)) {
              citation <- list()
              citation$identifier <-
                clean_identifier(relid_df[row, 'relatedIdentifier'])
              if ('relationType' %in% names(relid_df)) {
                if (relid_df[row, 'relationType'] == 'IsIdenticalTo') {
                  # skip this citation
                  next()
                }
                citation$type <- relid_df[row, 'relationType']
              } else
                citation$type <- "Unknown"
              if ('relatedIdentifierType' %in% colnames(relid_df)) {
                citation$identifier_type <- relid_df[row, 'relatedIdentifierType']
              } else
                citation$identifier_type <- "Unknown"
              citations <- c(citations, list(citation))
            }
          }
        }
      }

      # get citations from references and citations within relationships
      if ('relationships' %in% names(response_json$data)) {
        if ('references' %in% names(response_json$data$relationships))
          add_citations_from_relationships(
            relationship_child =  response_json$data$relationships$references,
            citation_type = 'References',
            citations_list =  citations,
            clean_identifier = doi
          )
        if ('citations' %in% names(response_json$data$relationships))
          add_citations_from_relationships(
            relationship_child =  response_json$data$relationships$citations,
            citation_type = 'Citations',
            citations_list =  citations,
            clean_identifier = doi
          )
      }
    }

    # for each citation, get the author, title, andyear to build citation text
    for (i in seq_along(citations)) {
      if (toupper(citations[[i]]$identifier_type) == 'DOI' && !is.na(citations[[i]]$identifier)) {
        tryCatch({
          crossref_citation <- get_citation_for_doi(citations[[i]]$identifier)
          citations[[i]]$citation <- crossref_citation$citation
          citations[[i]]$preprints <- crossref_citation$preprints
          citations[[i]]$title <- crossref_citation$title
        },
        error = function(e) {
          message(e)
          citations[[i]]$citation <- 'Citation not fetched'
          citations[[i]]$title <- ''
        })
      } else {
        citations[[i]]$citation <- 'Citation not fetched'
        citations[[i]]$title <- ''
      }

    }

    # remove published preprints
    #citations <- remove_published_preprints(citations)
    #print(citations)
    return(citations)
  } else
    stop()
}
