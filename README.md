# Latest additions

## Plot monthly inflation data for Germany using {restatis} for easy API access to the Genesis database
Example Code (R, ggplot) for [facets of timeseries](https://github.com/wahlatlas/api/blob/main/inflation2026sonderpositionen.R) using the {[restatis](https://github.com/CorrelAid/restatis)} package.  
Genesis [Table 61111-0006](https://www-genesis.destatis.de/datenbank/online/table/61111-0006) lets you browse through Consumer price index:  
Germany, months, individual consumption by purpose (COICOP 2-/3-/4-/5-/10-digit codes/ special items)  

You can get [.ics files for all release dates](https://github.com/wahlatlas/api/blob/main/vpi_ical.ipynb) of inflation data, poperly formatted to 8am Berlin time zone with some Python.
  
## Plot monthly timeseries for electricity trade between Germany and its neighbors
Research official statistics using the API of their public database.
Then decide on a table, e.g. `43312-0002` and plot it using matplotlib for each neighbor  
https://github.com/wahlatlas/api/blob/main/stromhandel-genesis.ipynb

## German Census 2022 results for general election districts
https://github.com/wahlatlas/api/blob/main/Zensus2022Wahlkreise2025.ipynb
  
  
*not yet updated*  

## German Census Database - Efficiently Download Data
Latest info on API changes (responses are zip-compressed as of Feb 5th, 2024) and the structure of the flatfile-csv-format (ffcsv).  
Contains tested and documented sample code using Pandas/Python  
https://github.com/wahlatlas/api/blob/main/census_table_via_api.ipynb  

## German Census Database - Table of contents
Use `catalogue` and `metadata` services from the Genesis API to build a table of contents of the public database.
https://github.com/wahlatlas/api/blob/main/census_database_toc.ipynb  
Since this may run for about 90 minutes, the resulting Excel files in German/English are provided here as well.

## What's new today in the Genesis Database
Evaluate updated statistics using the Genesis rss-feed and then download the respective tables as Excel files  
https://github.com/wahlatlas/api/blob/main/genesis_heute_neu.ipynb
