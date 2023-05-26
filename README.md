EDICited is a R package that queries the DataCite API to look up citations of datasets from the Environmental Data Initiative (EDI).

# Installation
`remotes::install_github("BLE-LTER/EDICited")`

# Usage

## Look up citations for all datasets under an Environmental Data Initiative scope
`create_citation_table(scope = "knb-lter-ble")`

## Look up citations for a single DOI

The example DOI is for the dataset ID "knb-lter-ble.3.1"
`get_citations_for_doi("https://api.datacite.org/dois/10.6073/pasta/e0e71c2d59bf7b08928061f546be6a9a")`
