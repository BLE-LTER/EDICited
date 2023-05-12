#' Returns a dictionary of metadata for all packages in a given scope.
#'
#' @param scope (character) The scope of the package, e.g., knb-lter-ble
#'
#' @return (list) A dictionary of metadata for all packages in the given scope, indexed by package
#' @export

get_meta_for_all_items_in_scope <- function(scope) {
  result <- list()
  ids <- EDIutils::list_data_package_identifiers(scope)

  message(paste('Found', length(ids), 'packages in scope', scope))
  for (id in ids) {
    meta_list <- c()
    revisions <- EDIutils::list_data_package_revisions(scope = scope, identifier = id)
    for (revision in revisions) {
      message(paste0('Getting metadata for: ', scope, '.', id, '.', revision, '...'))
      meta <- get_package_info(scope, id, revision)
      meta_list[[as.character(revision)]] <- meta
    }
    result[[as.character(id)]] <- meta_list
  }
  return(result)
}

#' Returns a dictionary of metadata for a given package revision.
#' @param scope (character) The scope of the package, e.g., knb-lter-ble
#' @param id (numeric) The package ID, e.g., 1
#' @param revision (numeric) The revision number, e.g., 1
#'
#' @return (list) A dictionary of metadata for the given package revision
#' @export
get_package_info <- function(scope, id, revision) {
  package <- as.character(id)
  revision <- as.character(revision)
  packageId <- paste0(scope, '.', id, '.', revision)
  meta <- list()
  meta$scope <- scope
  meta$package <- package
  meta$revision <- revision
  meta$xml <- EDIutils::read_metadata(packageId = packageId)
  meta$xml <- emld::as_emld(meta$xml)
  meta$title <- meta$xml$dataset$title
  meta$pubDate <- meta$xml$dataset$pubDate
  meta$doi <- EDIutils::read_data_package_doi(packageId = packageId)
  meta$doi <- substr(meta$doi, start = 5, stop = nchar(meta$doi))

  creators <- meta$xml$dataset$creator
  creator_string <- ''
  if (!is.null(names(creators))) creators <- list(creators)
  for (creator in creators)
    # If there is a surName, use it. Otherwise, use organizationName.
    if ('individualName' %in% names(creator)) {
      creator_name <- creator$individualName$surName
      creator_string <- paste0(creator_string, creator_name, ', ')
    } else {
      creator_name <- creator$organizationName
      creator_string <- paste0(creator_string, creator_name, ', ')
    }
  meta$creator <- substr(creator_string, start = 1, stop = nchar(creator_string) - 2)

  return(meta)
}
