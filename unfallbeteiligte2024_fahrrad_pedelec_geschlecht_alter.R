library(tidyverse)
library(restatis)
library(ggauto)
library(gridExtra)
library(grid)
library(gridtext)


#gen_val2var(database = "genesis", code = "VERVB1")

df <- gen_table(database="genesis", name="46241-0011",
                         classifyingvariable1="VERVB1",
                         classifyingkey1="BETEILART08,BETEILART13",
                         classifyingvariable2="GES01",
                         classifyingkey2="GESM,GESW",
                         startyear = 2024,
                         language="de") |> 
  janitor::clean_names()

df$value <- as.numeric(df$value)

selection <- df |> 
  filter(x6_variable_attribute_label=="Insgesamt",
         x5_variable_attribute_label=="Unfälle mit Personenschaden",
         x3_variable_attribute_label!="Alter unbekannt",
         x3_variable_attribute_label!="Insgesamt",
         x2_variable_attribute_label!="Insgesamt")  

#age_grp <- as_tibble(unique(df$x3_variable_attribute_label))

agegrp_sort <- c("unter 15 Jahre",
                 "15 bis unter 18 Jahre",
                 "18 bis unter 21 Jahre",
                 "21 bis unter 25 Jahre",
                 "25 bis unter 35 Jahre",
                 "35 bis unter 45 Jahre",
                 "45 bis unter 55 Jahre",
                 "55 bis unter 65 Jahre",
                 "65 bis unter 75 Jahre",
                 "75 Jahre und mehr")

selection$x3_variable_attribute_label <- factor(selection$x3_variable_attribute_label, 
                                                levels = rev(agegrp_sort))

biobike_betlgt <- selection |>
  filter(x4_variable_attribute_label=="Fahrrad ohne Hilfsmotor",
         value_variable_label=="Unfallbeteiligte")  

pedelec_betlgt <- selection |>
  filter(x4_variable_attribute_label=="Pedelecs",
         value_variable_label=="Unfallbeteiligte")  

plot_bio_betlgt <- biobike_betlgt |>   
  ggauto(x2_variable_attribute_label,x3_variable_attribute_label,value,
         title="Fahrrad ohne Hilfsmotor", subtitle = "nach Geschlecht und Alter",
         base_family = "Fira Sans", base_size=9) +
         guides(fill = guide_colorbar(barwidth = 8, barheight=.5)) +
         theme(legend.ticks = element_blank())

plot_e_betlgt <-   pedelec_betlgt |>   
  ggauto(x2_variable_attribute_label,x3_variable_attribute_label,value,
         title="Pedelecs", subtitle = "nach Geschlecht und Alter, Skalierung!", 
         base_family = "Fira Sans", base_size=9) +
         guides(fill = guide_colorbar(barwidth = 8, barheight=.5)) +
         theme(legend.ticks = element_blank())


title_betlgt <- richtext_grob("Unfallbeteiligte bei Unfällen mit Personenschaden, Deutschland 2024",
                              hjust=0, x=0, margin = unit(c(6,6,6,6), "pt"),
                              gp = gpar(fontsize = 14, fontfamily = "Fira Sans"))

bottom_grob <- richtext_grob("Genesis Online Tabelle 46241-0011",
                            hjust=0, x=0, margin = unit(c(6,6,6,6), "pt"),
                            gp = gpar(fontsize = 8, fontfamily = "Fira Sans"))

plot <- grid.arrange(grobs = list(plot_bio_betlgt,plot_e_betlgt), 
             top = title_betlgt, 
             bottom= bottom_grob,
             ncol=2)

#ggsave("unfallbetlgt2024_fahrrad_pedelec_geschlecht_alter.png", plot, width=1920, height=1080, units="px")
ggsave("unfallbetlgt2024_fahrrad_pedelec_geschlecht_alter.svg", plot, width=250, height=150, units="mm")
