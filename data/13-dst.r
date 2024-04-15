source("data/12-load-data.r")

library(tidyverse)
library(modelsummary)

## Finder informationer fra valgoversigt
exists("import_valg")
exists("import_stemmer")

# Formaterer variable
valg <- import_valg %>% 
  select(Valgdag, ValgId) %>% 
  rename(valg_dato = Valgdag,
         valg_id = ValgId) %>% 
  mutate(valg_dato = ymd(valg_dato))

head(valg)

gem_kolonner <- c("gruppe", "valgsted_id", "kreds_nr", "storkreds_nr", "landsdel_nr")

## Sammenlægger valg til tidy data
stemmer <- import_stemmer %>% 
  # select(!ends_with(c("Afgivne stemmer", "Andre ugyldige stemmer", "Gyldige stemmer", "Blanke stemmer", "Stemmeberettigede"))) %>% 
  select(!ends_with(c("Afgivne stemmer", "Andre ugyldige stemmer", "Blanke stemmer"))) %>% 
  rename(gruppe = Gruppe,
         valgsted_id = ValgstedId,
         kreds_nr = KredsNr,
         storkreds_nr = StorKredsNr,
         landsdel_nr = LandsdelsNr)

stemmer[] <- lapply(stemmer, as.character)

# rm(import_stemmer, import_valg)

head(stemmer, 2)

alle_stemmer <- stemmer %>% 
  select(any_of(gem_kolonner), starts_with("KV")) %>% 
  pivot_longer(cols = starts_with("KV"),
               names_to = "valg",
               values_to = "stemmer") %>% 
  separate(col = valg, into = c("valg", "parti"), sep = " - ") %>% 
  mutate(partinavn = case_when(parti == "A" ~ "Socialdemokratiet",
                               parti == "B" ~ "Radikale venstre",
                               parti == "C" ~ "Det Konservative Folkeparti",
                               parti == "D" ~ "Nye Borgerlige",
                               parti == "F" ~ "Socialistisk Folkeparti",
                               parti == "G" ~ "Veganerpartiet",
                               parti == "I" ~ "Liberal Alliance",
                               parti == "J" ~ "Junibevægelsen",
                               parti == "K" ~ "Kristendemokraterne",
                               parti == "L" ~ "Lokalliste"))
         # partinavn = case_when(parti == "M" & (valg == "KV20")))

head(alle_stemmer)
unique(alle_stemmer$parti)
unique(alle_stemmer$partinavn)
unique(alle_stemmer$valg)

datasummary_crosstab(data = alle_stemmer, formula = valg~partinavn)

## Stemmer for Socialdemokratiet
a_stemmer <- stemmer %>% 
  select(any_of(gem_kolonner), ends_with("A")) %>% 
  pivot_longer(cols = starts_with("KV"),
               names_to = "valg",
               values_to = "stemmer") %>% 
  mutate(valg = str_remove(valg, " - A"))
colnames(a_stemmer)
head(a_stemmer, 3)


partistemmer <- function(partibogstav, output_df, gemme_kolonner)

  

colnames(stemmer)
head(stemmer, 2)







