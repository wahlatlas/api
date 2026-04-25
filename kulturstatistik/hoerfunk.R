library(tidyverse)
library(ggtext)
library(scales)

setwd("~/Documents/R/kulturstatistik")

# Code: 21611-0020
# Sendezeit (Hörfunk): Deutschland, Jahre, 
# Öffentlich-rechtliche Rundfunkanstalten, Art der Hörfunksendung
# https://www-genesis.destatis.de/datenbank/online/statistic/21611/table/21611-0020

df <- read.csv2("21611-0020_de_flat.csv") |> janitor::clean_names()
df$value <- as.numeric(df$value)


df |> 
  mutate(sender = sub("RFA-","",x2_variable_attribute_code)) |> 
  filter(x3_variable_attribute_code %in% c("SEND-WORT","SEND-MUSIK"),
         #x3_variable_attribute_label != "Insgesamt",
         sender != "DWISSEN") |> 
  ggplot(aes(x = time, y = value, color = x3_variable_attribute_label)) +
    facet_wrap(~sender) +
    geom_line(linewidth = 1.25, lineend = "round", show.legend = FALSE) +
    scale_color_manual(values = c("Musiksendungen" = "#ff7f0e", "Wortsendungen" = "#1f77b4")) +
    scale_y_continuous(breaks = seq(0,50000,10000), labels = label_number(scale = 1e-3)) +
    scale_x_continuous(minor_breaks = "none") +
    labs(title="Öffentlich-rechtliche Rundfunkanstalten, Art der Hörfunksendung, Deutschland",
         subtitle = "Sendezeit in Tausend Stunden, <span style='color:#ff7f0e'>**Musik-**</span> vs. 
                                              <span style='color:#1f77b4'>**Wort**</span>sendungen",
         caption = "Genesis Online Tabelle 21611-0020",
         x=NULL, y=NULL, color=NULL) +
    theme_minimal(base_family = "Helvetica Neue") +
    theme(plot.subtitle = element_markdown(),
          plot.caption = element_text(hjust =0, margin = margin(t = 16)),
          #panel.spacing.x = unit(.5, "cm"),
          strip.text = element_text(face="bold"))

#ggsave("hoerfunk.svg", width=250, height=150, units="mm")
ggsave("hoerfunk.png", width=3640, height=2160, units="px")


