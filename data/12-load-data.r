library(tidyverse)

## Indlæser csv data over vindmøllernes afstemningssteder
# vind_stemmesteder <- read_csv("data/downloads/mine_data/vind_steder.csv")
vind_stemmesteder <- read_rds("data/rep_data/11_vind_steder.rds")

## Indlæser stemmedata fra valgdatabasen
import_stemmer <- read_csv2("data/downloads/ValgData.csv")
# import_stemmer <- read_csv2("data/downloads/udforskning/alle-kv-1-øko-baggrund/ValgData.csv")

## Indlæser geografisk opgørelse fra valgdatabasen
geografi <- read_csv2("data/downloads/Geografi.csv") %>% 
  rename(kommunenavn = "Kommune navn",
         valgsted_id = "Valgsted Id",
         kommunenr = "KommuneNr")

## Indlæser referenceopgørelse over valg og id fra valgdatabsen
import_valg <- read.csv2("data/downloads/Valg.csv")
