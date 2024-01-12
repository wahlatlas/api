library(tidyverse)
library(restatis)
# https://correlaid.github.io/restatis/articles/restatis.html

# Bekannte Tabelle abrufen
inflation <- gen_table("61111-0001")
select(inflation, 5, 10:11)

inflation <- gen_table("61111-0001", startyear=1998)
select(inflation, 5, 10:11)

#inflation <- gen_table("61111-0001", language="de")
#select(inflation, 5, 10:11)
# https://github.com/CorrelAid/restatis/issues/22

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

# Ausgewählte Ausprägungen des COICOP 10-Steller
gen_val2var("CC13Z1", 
            selection = "Kinder*", searchcriterion = "Inhalt", 
            language = "de")

PreisKinderschuhe = gen_table("61111-0006", 
          startyear = 2020, 
          classifyingvariable1 = "CC13Z1",
          classifyingkey1 = "CC13-0321310300",
          compress = TRUE,
          language = "en")

select(PreisKinderschuhe, 5,13,17,18)

PreisKinderschuhe <- transform(PreisKinderschuhe, 
                               date=interaction(time,
                                                `2_variable_code...13`, 
                                                sep="_"))

select(PreisKinderschuhe,date,PREIS1__Consumer_price_index__2020.100)

ggplot(data=PreisKinderschuhe, aes(x=date , 
                                   y=PREIS1__Consumer_price_index__2020.100, 
                                   group=1)) +
  geom_line()
