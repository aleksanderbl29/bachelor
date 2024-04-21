# source("data/12-load-data.r")

library(tidyverse)

## Finder informationer fra valgoversigt
exists("import_valg")
exists("import_stemmer")

# Formaterer variable
valg <- import_valg %>%
  select(Valgdag, ValgId) %>%
  rename(valg_dato = Valgdag,
         valg_id = ValgId) %>%
  mutate(valg_dato = ymd(valg_dato))

valg <- valg %>% arrange(ymd(valg$valg_dato))

head(valg)

gem_kolonner <- c("gruppe", "valgsted_id", "kreds_nr", "storkreds_nr", "landsdel_nr")

## Sammenlægger valg til tidy data
stemmer <- import_stemmer %>%
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
                               parti == "L" ~ "Lokalliste",
                               parti == "O" ~ "Dansk Folkeparti",
                               parti == "V" ~ "Venstre, Danmarks Liberale Parti",
                               parti == "Æ" ~ "Danmarksdemokraterne - Inger Støjberg",
                               parti == "Ø" ~ "Enhedslisten - De Rød-Grønne",
                               parti == "Å" ~ "Alternativet",
                               parti == "Stemmeberettigede" ~ "Stemmeberettigede",
                               parti == "Gyldige stemmer" ~ "Gyldige stemmer"))
head(alle_stemmer)
unique(alle_stemmer$parti)
unique(alle_stemmer$partinavn)
unique(alle_stemmer$valg)

alle_nrow <- nrow(alle_stemmer)

lang_alle_stemmer <- alle_stemmer %>%
  select(!partinavn) %>%
  pivot_wider(names_from = parti, values_from = stemmer)

noget_mere_stemmer <- alle_stemmer %>%
  drop_na(partinavn)
unique(noget_mere_stemmer$parti)
nrow(noget_mere_stemmer)

kmd_stemmer <- stemmer %>%
  select(any_of(gem_kolonner), starts_with("KV")) %>%
  pivot_longer(cols = starts_with("KV"),
               names_to = "valg",
               values_to = "stemmer") %>%
  separate(col = valg, into = c("valg", "parti"), sep = " - ") %>%
  mutate(partinavn = case_when(parti == "A" ~ "Socialdemokratiet",
                               parti == "V" ~ "Venstre, Danmarks Liberale Parti",
                               parti == "C" ~ "Det Konservative Folkeparti",
                               parti == "F" ~ "SF - Socialistisk Folkeparti",
                               parti == "Ø" ~ "Enhedslisten - De Rød-Grønne",
                               parti == "B" ~ "Radikale venstre",
                               parti == "O" ~ "Dansk Folkeparti",
                               parti == "D" ~ "Nye Borgerlige",
                               parti == "I" ~ "Liberal Alliance",
                               parti == "K" ~ "Kristendemokraterne",
                               parti == "Å" ~ "Alternativet",
                               parti == "S" ~ "Slesvigsk Parti",
                               parti == "T" ~ "Tønder Listen",
                               parti == "G" ~ "Veganerpartiet",
                               parti == "L" ~ "Lokalliste",
                               parti == "Q" ~ "Østbroen",
                               parti == "E" ~ "nytgribskov",
                               parti == "H" ~ "Klimapartiet Momentum",
                               parti == "Æ" ~ "Frihedslisten",
                               parti == "N" ~ "Nyt Odsherred",
                               parti == "W" ~ "Bornholmerlisten",
                               parti == "Stemmeberettigede" ~ "Stemmeberettigede",
                               parti == "Gyldige stemmer" ~ "Gyldige stemmer")) %>%
  drop_na(partinavn)

kmd_nrow <- nrow(kmd_stemmer)
head(kmd_stemmer)
unique(kmd_stemmer$parti)
unique(kmd_stemmer$partinavn)
unique(kmd_stemmer$valg)

kmd_nrow - alle_nrow

na_stemmer <- alle_stemmer %>%
  filter(is.na(partinavn))

na_nrow <- nrow(na_stemmer)

na_nrow - alle_nrow

# datasummary_crosstab(data = alle_stemmer, formula = valg~partinavn)

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

