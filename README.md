EDICited is a R package that queries the Environmental Data Initiative (EDI), DataCite, and CrossRef APIs to look up publications that cite EDI datasets. This package can be of use to data managers looking to monitor usage of their project data and to build reports. 

This is the R version of the Python library at  https://github.com/BLE-LTER/citations_for_data.

# Installation

```r
remotes::install_github("BLE-LTER/EDICited")
```

# Usage

## Look up citations for all datasets under an Environmental Data Initiative scope

```r
df <- create_citation_table(scope = "knb-lter-ble")
```

The result:

| scope | id | revision | pubdate | title | creators | doi | pubtitle | pubid | citation |
|---|---|---|---|---|---|---|---|---|---|
| knb-lter-ble | 1 | 6 | 2019 | Carbon flux from aquatic ecosystems of the Arctic Coastal Plain along the Beaufort Sea, Alaska, 2010-2018 | Beaufort Lagoon Ecosystems LTER, Lougheed | 10.6073/pasta/ee1b0056e741169a24c11afce777eb84 | Patterns and Drivers of Carbon Dioxide Concentrations in Aquatic Ecosystems of the Arctic Coastal Tundra | 10.1029/2020gb006552 | Lougheed (2020). Patterns and Drivers of Carbon Dioxide Concentrations in Aquatic Ecosystems of the Arctic Coastal Tundra. doi:10.1029/2020gb006552 |
| knb-lter-ble | 2 | 4 | 2019 | Dissolved organic carbon (DOC) and total dissolved nitrogen (TDN) from river, lagoon, and open ocean sites along the Alaska Beaufort Sea coast, 2018-ongoing | Beaufort Lagoon Ecosystems LTER, Core Program | 10.6073/pasta/4dcefec5d550301065619ed15b2192cc | The Genomic Capabilities of Microbial Communities Track Seasonal Variation in Environmental Conditions of Arctic Lagoons | 10.3389/fmicb.2021.601901 | Baker (2021). The Genomic Capabilities of Microbial Communities Track Seasonal Variation in Environmental Conditions of Arctic Lagoons. doi:10.3389/fmicb.2021.601901 |
| knb-lter-ble | 3 | 1 | 2020 | Physiochemical water column parameters and hydrographic time series from river, lagoon, and open ocean sites along the Alaska Beaufort Sea coast, 2018-ongoing | Beaufort Lagoon Ecosystems LTER, Core Program | 10.6073/pasta/e0e71c2d59bf7b08928061f546be6a9a | The seasonal phases of an Arctic lagoon reveal the discontinuities of pH variability and CO&amp;lt;sub&amp;gt;2&amp;lt;/sub&amp;gt; flux at the air–sea interface | 10.5194/bg-18-1203-2021 | Miller (2021). The seasonal phases of an Arctic lagoon reveal the discontinuities of pH variability and CO&amp;lt;sub&amp;gt;2&amp;lt;/sub&amp;gt; flux at the air–sea interface. doi:10.5194/bg-18-1203-2021 |
| knb-lter-ble | 3 | 1 | 2020 | Physiochemical water column parameters and hydrographic time series from river, lagoon, and open ocean sites along the Alaska Beaufort Sea coast, 2018-ongoing | Beaufort Lagoon Ecosystems LTER, Core Program | 10.6073/pasta/e0e71c2d59bf7b08928061f546be6a9a | Observed and forecasted global warming pressure on coastal hypoxia | 10.5194/bg-2021-285 | Whitney (2021). Observed and forecasted global warming pressure on coastal hypoxia. doi:10.5194/bg-2021-285 |
| knb-lter-ble | 3 | 1 | 2020 | Physiochemical water column parameters and hydrographic time series from river, lagoon, and open ocean sites along the Alaska Beaufort Sea coast, 2018-ongoing | Beaufort Lagoon Ecosystems LTER, Core Program | 10.6073/pasta/e0e71c2d59bf7b08928061f546be6a9a | Slow Community Development Enhances Abiotic Limitation of Benthic Community Structure in a High Arctic Kelp Bed | 10.3389/fmars.2021.592295 | Bonsell (2021). Slow Community Development Enhances Abiotic Limitation of Benthic Community Structure in a High Arctic Kelp Bed. doi:10.3389/fmars.2021.592295 |
| knb-lter-ble | 3 | 1 | 2020 | Physiochemical water column parameters and hydrographic time series from river, lagoon, and open ocean sites along the Alaska Beaufort Sea coast, 2018-ongoing | Beaufort Lagoon Ecosystems LTER, Core Program | 10.6073/pasta/e0e71c2d59bf7b08928061f546be6a9a | The Seasonal Phases of an Arctic Lagoon Reveal Non-linear pH Extremes | 10.5194/bg-2020-358 | Miller (2020). The Seasonal Phases of an Arctic Lagoon Reveal Non-linear pH Extremes. doi:10.5194/bg-2020-358 |
| knb-lter-ble | 3 | 1 | 2020 | Physiochemical water column parameters and hydrographic time series from river, lagoon, and open ocean sites along the Alaska Beaufort Sea coast, 2018-ongoing | Beaufort Lagoon Ecosystems LTER, Core Program | 10.6073/pasta/e0e71c2d59bf7b08928061f546be6a9a | Observed and projected global warming pressure on coastal hypoxia | 10.5194/bg-19-4479-2022 | Whitney (2022). Observed and projected global warming pressure on coastal hypoxia. doi:10.5194/bg-19-4479-2022 |
| knb-lter-ble | 3 | 1 | 2020 | Physiochemical water column parameters and hydrographic time series from river, lagoon, and open ocean sites along the Alaska Beaufort Sea coast, 2018-ongoing | Beaufort Lagoon Ecosystems LTER, Core Program | 10.6073/pasta/e0e71c2d59bf7b08928061f546be6a9a | Monitoring Alaskan Arctic Shelf Ecosystems Through Collaborative Observation Networks | 10.5670/oceanog.2022.119 | Danielson (2022). Monitoring Alaskan Arctic Shelf Ecosystems Through Collaborative Observation Networks. doi:10.5670/oceanog.2022.119 |
| knb-lter-ble | 3 | 1 | 2020 | Physiochemical water column parameters and hydrographic time series from river, lagoon, and open ocean sites along the Alaska Beaufort Sea coast, 2018-ongoing | Beaufort Lagoon Ecosystems LTER, Core Program | 10.6073/pasta/e0e71c2d59bf7b08928061f546be6a9a | Marine Pelagic Ecosystem Responses to Climate Variability and Change | 10.1093/biosci/biac050 | Ducklow (2022). Marine Pelagic Ecosystem Responses to Climate Variability and Change. doi:10.1093/biosci/biac050 |
| knb-lter-ble | 5 | 2 | 2019 | Model simulated hydrological estimates for the North Slope drainage basin, Alaska, 1980-2010 | Beaufort Lagoon Ecosystems LTER, Rawlins | 10.6073/pasta/bb7d76017b8a8534c4960346705bcb77 | Changing characteristics of runoff and freshwater export from watersheds draining northern Alaska | 10.5194/tc-13-3337-2019 | Rawlins (2019). Changing characteristics of runoff and freshwater export from watersheds draining northern Alaska. doi:10.5194/tc-13-3337-2019 |
| knb-lter-ble | 6 | 1 | 2019 | Photosynthetically active radiation (PAR) time series from lagoon sites along the Alaska Beaufort Sea coast, 2018-ongoing | Beaufort Lagoon Ecosystems LTER, Core Program | 10.6073/pasta/ced2cedd430d430d9149b9d7f1919729 | The seasonal phases of an Arctic lagoon reveal the discontinuities of pH variability and CO&amp;lt;sub&amp;gt;2&amp;lt;/sub&amp;gt; flux at the air–sea interface | 10.5194/bg-18-1203-2021 | Miller (2021). The seasonal phases of an Arctic lagoon reveal the discontinuities of pH variability and CO&amp;lt;sub&amp;gt;2&amp;lt;/sub&amp;gt; flux at the air–sea interface. doi:10.5194/bg-18-1203-2021 |

## Look up citations for a single DOI

The example DOI is for the dataset ID "knb-lter-ble.3.1"

```r
get_citations_for_doi("10.6073/pasta/e0e71c2d59bf7b08928061f546be6a9a")
```
