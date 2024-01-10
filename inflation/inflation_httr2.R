library(httr2)
#library(jsonlite)


# Zugangsdaten ausprobieren

response <- httr2::request("https://www-genesis.destatis.de/genesisWS/rest/2020") %>%
    httr2::req_url_path_append("helloworld/logincheck") %>%
    httr2::req_url_query(username="xxx", password="xxx") %>%
    httr2::req_perform() %>%
    httr2::resp_body_json()

response


# Tabelle 61111-0001 als ffcsv ab 1998 in deutscher Sprache abrufen

response <- httr2::request("https://www-genesis.destatis.de/genesisWS/rest/2020") %>%
  httr2::req_url_path_append("data/tablefile") %>%
  httr2::req_url_query(username= "xxx", password="xxx", 
                       name="61111-0001", 
                       startyear=1998, 
                       format="ffcsv",
                       language="de") %>% 
  httr2::req_perform()

response |> resp_raw()
