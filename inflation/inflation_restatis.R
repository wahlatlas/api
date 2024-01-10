library(tidyverse)
library(restatis)

# Bekannte Tabelle abrufen
inflation <- gen_table("61111-0001", startyear=1998, language="en")

select(inflation, 5, 10:11)

ggplot(data=inflation, aes(x=time, y=PREIS1__CH0004)) +
  geom_col()

# Beschreibung zur Tabelle
gen_metadata(code = "61111-0001", category = "Table")

# Aktualisierungen
gen_modified_data(code = "61*",    date = "30.06.2023")
gen_modified_data(type = "tables", date = "month_before")

# Recherche
gen_alternative_terms(term = "*preis*")

gen_find(
  term = "erzeugerpreise",
  detailed = FALSE,
  ordering = TRUE,
  category = "all"
)

# Verwendungszwecke des Individualkonsums
gen_find(term = "COICOP", category = "variables")

# Alle Ausprägungen des COICOP 10-Steller
gen_val2var("CC13Z1", pagelength = 800, language = "en")
