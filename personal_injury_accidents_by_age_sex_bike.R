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
                         language="en") |> 
  janitor::clean_names()

df$value <- as.numeric(df$value)

selection <- df |> 
  filter(x6_variable_attribute_label=="Total",
         x5_variable_attribute_label=="Personal injury accidents",
         x3_variable_attribute_label!="age unknown",
         x3_variable_attribute_label!="Total",
         x2_variable_attribute_label!="Total")  

#age_grp <- as_tibble(unique(df$x3_variable_attribute_label))

agegrp_sort <- c("under 15 years",
                 "15 to under 18 years",
                 "18 to under 21 years",
                 "21 to under 25 years",
                 "25 to under 35 years",
                 "35 to under 45 years",
                 "45 to under 55 years",
                 "55 to under 65 years",
                 "65 to under 75 years",
                 "75 years and over")

selection$x3_variable_attribute_label <- factor(selection$x3_variable_attribute_label, 
                                                levels = rev(agegrp_sort))

selection$x2_variable_attribute_label <- factor(selection$x2_variable_attribute_label,
                                                levels = c("Male","Female"))

biobike_betlgt <- selection |>
  filter(x4_variable_attribute_label=="Cycle without auxiliary motor",
         value_variable_label=="Parties involved in the accident")  

pedelec_betlgt <- selection |>
  filter(x4_variable_attribute_label=="Pedelecs",
         value_variable_label=="Parties involved in the accident")  

plot_bio_betlgt <- biobike_betlgt |>   
  ggauto(x2_variable_attribute_label,x3_variable_attribute_label,value,
         title="Cycle without auxiliary motor", subtitle = "by age and sex",
         base_family = "Statis Sans", base_size=9) +
         guides(fill = guide_colorbar(barwidth = 8, barheight=.5)) +
         theme(legend.ticks = element_blank())

plot_e_betlgt <-   pedelec_betlgt |>   
  ggauto(x2_variable_attribute_label,x3_variable_attribute_label,value,
         title="Pedelecs", subtitle = "by age and sex, scaling!", 
         base_family = "Statis Sans", base_size=9) +
         guides(fill = guide_colorbar(barwidth = 8, barheight=.5)) +
         theme(legend.ticks = element_blank())


title_betlgt <- richtext_grob("Parties involved in personal injury accidents, Germany 2024",
                              hjust=0, x=0, margin = unit(c(6,6,6,6), "pt"),
                              gp = gpar(fontsize = 14, fontfamily = "Statis Sans"))

bottom_grob <- richtext_grob("Genesis Online Table 46241-0011",
                            hjust=0, x=0, margin = unit(c(6,6,6,6), "pt"),
                            gp = gpar(fontsize = 8, fontfamily = "Statis Sans"))

plot <- grid.arrange(grobs = list(plot_bio_betlgt,plot_e_betlgt), 
             top = title_betlgt, 
             bottom= bottom_grob,
             ncol=2)

ggsave("personal_injury_accidents_by_age_sex_bike.svg", plot, width=250, height=150, units="mm")
