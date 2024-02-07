# api
Beispiele zur API Nutzung öffentlicher Datenbanken

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

## Plot monthly timeseries for electricity trade between Germany and its neighbors
Research official statistics using the API of their public database.
Then decide on a table, e.g. `43312-0002` and plot it using matplotlib for each neighbor  
https://github.com/wahlatlas/api/blob/main/stromhandel-genesis.ipynb
