# retrieve citations from datacite REST API

add_citations_from_relationships <-
  function(relationship_child,
           citation_type,
           citations_list,
           clean_identifier) {
    if ('data' %in% names(relationship_child)) {
      for (item in relationship_child$data) {
        if ('id' %in% names(item)) {
          # make sure we dont already have this citation by checking the identifier
          found <- FALSE
          identifier <- clean_identifier(item$id)
          for (citation in citations_list) {
            if (citation$identifier == identifier) {
              found <- TRUE
              break()
            }
          }
          if (found)
            next()

          citation <- list()
          citation$identifier <- identifier
          if ('type' %in% names(item)) {
            if (item$type == 'dois')
              citation$identifier_type <- 'DOI'
            else
              citation$identifier_type <- item$type
          }
          else
            citation$identifier_type <- 'Unknown'
          citation$type <- citation_type
          citations_list <- c(citations_list, citation)
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

get_citations_for_doi <- function(doi) {
  # list of ciations, where each citation is a dictionary
  doi <- clean_identifier(doi)
  citations <- c()
  url <- paste0('https://api.datacite.org/dois/', doi)
  response <- NULL
  tryCatch(expr = {
    response <- jsonlite::fromJSON(url)
  }, error = function(e){
    message(paste0('DataCite API call failed for DOI: ', doi, 'Error: ', e))
  })


  if (!is.null(response)) {
    response_json <- response
    citations <- list()
    if ('data' %in% names(response_json)) {
      # get citations from relatedIdentifiers
      if ('attributes' %in% names(response_json$data)) {
        if ('relatedIdentifiers' %in% names(response_json$data$attributes)) {
          for (item in response_json$data$attributes$relatedIdentifiers) {
            if ('relatedIdentifier' %in% names(item)) {
              citation <- list()
              citation$identifier <-
                clean_identifier(item$relatedIdentifier)
              if ('relationType' %in% names(item)) {
                if (item$relationType == 'IsIdenticalTo') {
                  # skip this citation
                  next()
                }
                citation$type <- item$relationType
              } else
                citation$type <- "Unknown"
              if ('relatedIdentifierType' %in% names(item)) {
                citation$identifier_type <- item$relatedIdentifierType
              } else
                citation$identifier_type <- "Unknown"
              citations <- c(citations, citation)
            }
          }
        }
      }

      # get citations from references and citations within relationships
      if ('relationships' %in% names(response_json$data)) {
        if ('references' %in% names(response_json$data$relationships))
          add_citations_from_relationships(relationship_child =  response_json$data$relationships$references,
                                           citation_type = 'References',
                                           citations_list =  citations,
                                           clean_identifier = doi)
        if ('citations' %in% names(response_json$data$relationships))
          add_citations_from_relationships(relationship_child =  response_json$data$relationships$citations,
                                           citation_type = 'Citations',
                                          citations_list =  citations,
                                          clean_identifier = doi)
      }
    }

    # for each citation, get the author, title, andyear to build citation text
    for (citation in citations) {
      citation$crossref_data <- NULL
      if (citation$identifier_type == 'DOI') {
        tryCatch({
          crossref_citation <- get_citation_for_doi(citation$identifier)
          citation$citation <- crossref_citation$citation
          citation$preprints <- crossref_citation$preprints
        },
        error = function(e) {
          message(e)
          citation$citation <- ''
        })
      } else citation$citation <- ''
    }

    # remove published preprints
    citations <- remove_published_preprints(citations)
    return(citations)
  } else stop()
}
