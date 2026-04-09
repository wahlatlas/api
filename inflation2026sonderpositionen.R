library(restatis)
library(tidyverse)
library(janitor)
library(grid)
library(ggtext)


# set to FALSE in case latest data doesn't show up
options(restatis.use_cache = TRUE)


#find <- gen_find(category="cubes", database="genesis", term="61111")
#
#results <- as_tibble(find) |>  
#  filter(grepl("Sonder", Cubes$Content))

cube <- gen_cube(name="61111BM006", database="genesis",
                 startyear=2020, endyear=2036)

cube <- cube |>
  rename(Indexwert = PREIS1_WERT)

meta <- gen_val2var(code="CC13B1", database="genesis", language="de")

umsteiger <- setNames(meta$`Values of CC13B1`$Content, 
                      meta$`Values of CC13B1`$Code)

cube$Name <- sapply(cube$CC13B1, function(x) umsteiger[x])

cube_gesamt <- gen_cube(name="61111BM001", database="genesis",
                        startyear=2020, endyear=2036)

names(cube_gesamt)  <- c("a","MONAT","JAHR","Indexwert", "x","y","z")
cube_gesamt$Name    <- "GesamtIndex"
cube_gesamt$CC13B1  <- "Gesamt"

common_cols <- c("MONAT","JAHR","CC13B1","Indexwert","Name")

df <- rbind(
  cube_gesamt[ , common_cols],
  cube[ , common_cols]
)

# Datumsformat hinzufügen
df <- df |>
  mutate(
    month = as.numeric(sub("MONAT", "", MONAT)),
    date = as.Date(paste(JAHR, month, 1, sep = "-"))
  ) |>
  select(-month, -MONAT, -JAHR)

df_gesamt <- df |> 
  filter(CC13B1 == "Gesamt") |> 
  select(-CC13B1, -Name)

# Ende der Zeitreihe
lastObservation <- max(df$date)
Sys.setlocale("LC_TIME", "de_DE.UTF-8")
month <- format(lastObservation, "%B")
year <- format(lastObservation, "%Y")

auswahl = c("CC13-071A","CC13-071B","CC13-63I","CC13-63K","CC13-65B","CC13-68",
            "CC13-65","CC13-77","CC13-808","CC13-803B","CC13-803C","CC13-073B",
            "CC13-073L","CC13-802A","CC13-807","CC13-73")

# PLOT
p <- df |> 
  mutate(Name = fct_inorder(Name)) |> 
  #filter(CC13B1 != "Gesamt") |>
  filter(CC13B1 %in% auswahl) |>
  ggplot(aes(x=date, y=Indexwert)) +
  geom_hline(yintercept = 100, color="black", linewidth=.15) +
  geom_line(data=df_gesamt, aes(x=date, y=Indexwert), 
            color="#C9C4A8", linewidth = .9, lineend = "round") +
  geom_line(aes(group = Name), color="#e71111", linewidth = .4, lineend = "round") +
  scale_y_continuous(breaks=seq(from=50, to=300, by=25), 
                     labels = function(x) {ifelse(x==100, expression(bold("100")),x)}) +
  labs(x=NULL, y=NULL, 
       title = paste("Verbraucherpreisindex Deutschland bis",month,year),
       subtitle = "Ausgewählte <span style='color:#e71111'>Sonderpositionen</span> vs 
       <span style='color:#888;'>Gesamtindex</span>, 2020 = 100 (Genesis-Tabelle 61111-0006)") +
  facet_wrap(~Name, labeller = label_wrap_gen(width = 40)) 


m <- p+
  theme_minimal(base_family = "Fira Sans", 
                base_size = 7) +
  theme(plot.title = element_text(face = "bold", size=9,
                                  margin = margin(t = 6, b=3)),
        plot.subtitle = element_markdown(margin = margin(b=6)),
        axis.text = element_text(size=5)) +
  theme(strip.text = element_text(hjust = 0),
        panel.spacing.x = unit(.5, "cm"),
        panel.grid.major = element_line(linewidth = .3),
        panel.grid.minor = element_line(linewidth = .15))

ggsave("sonderpositionen.png", m, width=1920, height=1080, units="px")