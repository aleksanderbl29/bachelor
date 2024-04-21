library(tidyverse)

options(scipen = 999)

source("data/00-pakker.r")

## Indlæser alle data
source("data/12-load-data.r")

## Formater data fra DST
source("data/13-dst.r")

## Sikrer at de nødvendige dataframes findes
expect_true(exists("vind_stemmesteder"))
expect_true(exists("valg"))

## Fjerner ting der ikke skal bruges til udarbejdelse af funktioner
rm(a_stemmer, alle_stemmer, geografi, import_stemmer, import_valg,
   kmd_stemmer, noget_mere_stemmer, lang_alle_stemmer, na_stemmer,
   stemmer, alle_nrow, gem_kolonner, kmd_nrow, na_nrow, partistemmer)

vind_stemmesteder
valg

kv2001 <- valg$valg_dato[3]
vp_01_05 <- as.interval(as.period(valg$valg_dato[4] - valg$valg_dato[3]), start = valg$valg_dato[3])
vp_05_09 <- as.interval(as.period(valg$valg_dato[1] - valg$valg_dato[4]), start = valg$valg_dato[4])

vp_01_05
vp_05_09
vp_09_13
vp_13_17
vp_17_21

vind_treatment <- vind_stemmesteder %>% 
  select(everything()) %>% 
  mutate()
