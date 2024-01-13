library(tidyverse)

library(restatis)
# https://correlaid.github.io/restatis/articles/restatis.html


# Bekannte Tabelle abrufen
inflation <- gen_table("61111-0001")
select(inflation, 5, 10:11)

inflation <- gen_table("61111-0001", startyear=1998)
select(inflation, 5, 10:11)

#inflation_de <- gen_table("61111-0001", language="de")
#select(inflation_de, 5, 10:11)
# https://github.com/CorrelAid/restatis/issues/22

ggplot(data=inflation, aes(x=time, y=PREIS1__CH0004)) +
  geom_col()


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
            selection = "Damen*", searchcriterion = "Inhalt", 
            language = "de")

# Tabellen, die den COICOP-10-Steller enthalten
gen_find(term = "CC13Z1", category = "tables")


# Code: 61111-0006
# Verbraucherpreisindex: Deutschland, Monate, 
# Klassifikation der Verwendungszwecke des Individualkonsums 
# (COICOP 2-/3-/4-/5-/10-Steller/Sonderpositionen)
# https://www-genesis.destatis.de/datenbank/beta/table/61111-0006


# Anwendungsbeispiel classifyingvariable & classifyingkey
# Verbraucherpreisindex "Damenjacke oder Damenmantel" (CC13-0312210200) 

iKonsum = gen_table("61111-0006", 
          startyear = 2020, 
          classifyingvariable1 = "CC13Z1",
          classifyingkey1 = "CC13-0312210200",
          compress = TRUE,
          language = "en")

title = iKonsum$`3_variable_code...17`[1]

select(iKonsum, 5,12,13,17,18)


# Visualisierung von Saisonfiguren (Modeartikel, Sommerschlussverkauf)

# Datum erzeugen:
# aus 2020 MONAT01 wird 2020-01-01
iKonsum <- transform(iKonsum, 
                     dateObj=as.Date(paste(time,
                                           substr(`2_variable_code...12`, 6,7),
                                           "01",
                                           collapse = NULL, sep="-")))

#select(iKonsum,dateObj,PREIS1__Consumer_price_index__2020.100)

ggplot(data=iKonsum, aes(x=dateObj, 
                         y=PREIS1__Consumer_price_index__2020.100, 
                         group=1)) +
  geom_line() +
  geom_line(linewidth=1.5) +
  ggtitle(title) +
  scale_x_date(date_breaks = "3 months", 
               date_minor_breaks = "1 month",
               labels = scales::label_date_short()) +
  xlab("") + 
  ylab("Consumer Price Index (2020=100)") +
  theme(text = element_text(size=15)) 


# Aktualisierungen
gen_modified_data(code = "61111",    date = "30.06.2023")
gen_modified_data(type = "tables", date = "month_before")

# Beschreibung zur Tabelle
gen_metadata(code = "61111-0006", category = "Table")



# LÄNGERE ZEITREIHEN
# Visualisierung Herren-, Damen-, Kinderbekleidung

# COICOP-5-Steller (2020=100) ab 2015 verfügbar
PreiseBekleidung = gen_table("61111-0006", 
                    startyear = 2015, 
                    classifyingvariable1 = "CC13A5",
                    classifyingkey1 = "CC13-0312*",
                    compress = TRUE,
                    language = "en")

PreiseBekleidung <- transform(PreiseBekleidung, 
                     dateObj=as.Date(paste(time,
                                           substr(`2_variable_code...12`,6,7),
                                           "01",
                                           collapse = NULL, sep="-")))

ggplot(data=PreiseBekleidung, aes(x=dateObj, 
                         y=PREIS1__Consumer_price_index__2020.100, 
                         colour=`X3_variable_code...17`)) +
  geom_line() +
  scale_color_manual(values=c("chocolate1", "blue3", "cyan4")) +
  geom_line(linewidth=1) +
  ggtitle("CC13-0312*") +
  scale_x_date(date_breaks = "1 year", 
               date_minor_breaks = "3 months",
               date_labels = "%Y") +
  xlab("") + 
  ylab("Consumer Price Index (2020=100)") +
  theme(legend.position=c(0.1, 0.86)) +
  theme(legend.title=element_blank()) +
  theme(text = element_text(size=15)) 
