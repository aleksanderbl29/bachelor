library(tidyverse)

## Finder informationer fra valgoversigt
exists("valg")
# Formaterer variable
colnames(valg)
valg <- valg %>% 
  select(Valgdag, ValgId) %>% 
  rename(valg_dato = Valgdag,
         valg_id = ValgId) %>% 
  mutate(valg_dato = ymd(valg_dato))

head(valg)

gem_kolonner <- c("gruppe", "valgsted_id", "kreds_nr", "storkreds_nr", "landsdel_nr")

## Sammenlægger valg til tidy data
tidy_stemmer <- stemmer %>% 
  select(!ends_with(c("Afgivne stemmer", "Andre ugyldige stemmer", "Gyldige stemmer", "Blanke stemmer", "Stemmeberettigede"))) %>% 
  rename(gruppe = Gruppe,
         valgsted_id = ValgstedId,
         kreds_nr = KredsNr,
         storkreds_nr = StorKredsNr,
         landsdel_nr = LandsdelsNr)

colnames(tidy_stemmer)

partinavne <- tidy_stemmer %>% select(!any_of(gem_kolonner)) %>% colnames() %>% list()
partinavne

partinavne <- gsub('[KV2013957 -]', '', partinavne)


head(stemmer, 2)

## Stemmer for Socialdemokratiet
a_stemmer <- stemmer %>% 
  select(any_of(gem_kolonner), ends_with("A")) %>% 
  pivot_longer(cols = starts_with("KV"),
               names_to = "valg",
               values_to = "stemmer") %>% 
  mutate(valg = str_remove(valg, " - A"))
colnames(a_stemmer)
head(a_stemmer, 3)


  

colnames(stemmer)
head(stemmer, 2)
