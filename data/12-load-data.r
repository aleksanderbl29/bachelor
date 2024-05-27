library(tidyverse)
library(logger)

## Option
options(readr.show_progress = TRUE)
options(readr.show_col_types = FALSE)

## Indlæser csv data over vindmøllernes afstemningssteder
log_info("Indlæser stemmester og vindmøller")
# vind_stemmesteder <- read_csv("data/downloads/mine_data/vind_steder.csv")
vind_stemmesteder <- read_rds("data/rep_data/11_vind_steder.rds")

## Indlæser stemmedata fra valgdatabasen
log_info("Indlæser stemmedata")
import_stemmer <- read_csv2("data/downloads/ValgData.csv")
# import_stemmer <- read_csv2("data/downloads/udforskning/alle-kv-1-øko-baggrund/ValgData.csv")

## Indlæser geografisk opgørelse fra valgdatabasen
log_info("Indlæser geografisk opgørelse fra valgdatabasen")
geografi <- read_csv2("data/downloads/Geografi.csv") %>% 
  rename(kommunenavn = "Kommune navn",
         valgsted_id = "Valgsted Id",
         kommunenr = "KommuneNr")

## Indlæser referenceopgørelse over valg og id fra valgdatabsen
log_info("Indlæser opgørelse over valg og id fra valgdatabasen")
import_valg <- read.csv2(file = "data/downloads/Valg.csv")

befolkning_1 <- read.csv2("data/downloads/dst/baggrund-1/Befolkning.csv")

befolkning_2 <- read.csv2("data/downloads/dst/baggrund-2/Befolkning.csv")
