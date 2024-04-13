library(tidyverse)

## Indlæser csv data over vindmøllernes afstemningssteder
vind_stemmesteder <- read_csv("data/downloads/mine_data/vind_steder.csv")

## Indlæser stemmedata fra valgdatabasen
stemmer <- read_csv2("data/downloads/ValgData.csv")

## Indlæser geografisk opgørelse fra valgdatabasen
geografi <- read_csv2("data/downloads/Geografi.csv")

## Indlæser referenceopgørelse over valg og id fra valgdatabsen
valg <- read.csv2("data/downloads/Valg.csv")

