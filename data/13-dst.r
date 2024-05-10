# source("data/12-load-data.r")

library(tidyverse)

## Finder informationer fra valgoversigt
exists("import_valg")
exists("import_stemmer")

# Formaterer variable
kommunalvalg <- import_valg %>%
  select(Valgdag, ValgId) %>%
  rename(valg_dato = Valgdag,
         valg_id = ValgId) %>%
  mutate(valg_dato = ymd(valg_dato)) %>% 
  arrange(ymd(valg_dato))

write_rds(kommunalvalg, "data/rep_data/kommunalvalg.rds")
head(kommunalvalg)
rm(import_valg, kommunalvalg)

## Skaber df med kommuneid og navn
kommuner <- geografi %>% 
  select(kommunenavn, kommunenr, valgsted_id) %>% 
  distinct(kommunenavn, kommunenr) %>% 
  arrange(kommunenavn)

rm(geografi)

gem_kolonner <- c("gruppe", "valgsted_id", "kreds_nr", "storkreds_nr", "landsdel_nr")

## Sammenlægger stemmer til tidy data
stemmer <- import_stemmer %>%
  select(!ends_with(c("Afgivne stemmer", "Andre ugyldige stemmer", "Blanke stemmer"))) %>%
  rename(gruppe = Gruppe,
         valgsted_id = ValgstedId,
         kreds_nr = KredsNr,
         storkreds_nr = StorKredsNr,
         landsdel_nr = LandsdelsNr) %>%
  naniar::replace_with_na_all(condition = ~.x == "-") %>%
  mutate(across(!c("valgsted_id"), ~ str_replace_all(., ",", "."))) %>%
  mutate(across(!c("valgsted_id"), as.double))

rm(import_stemmer)

head(stemmer, 2)

alle_stemmer <- stemmer %>%
  select(any_of(gem_kolonner), starts_with("KV")) %>%
  pivot_longer(cols = starts_with("KV"),
               names_to = "valg",
               values_to = "stemmer") %>%
  separate(col = valg, into = c("valg", "parti"), sep = " - ") %>%
  mutate(valg = as.factor(valg)) %>%
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

lang_gruppe_steder <- lang_alle_stemmer %>%
  select(everything()) %>%
  mutate(valgsted_id = as.double(gruppe)) %>%
  select(!c("gruppe", "kreds_nr", "storkreds_nr", "landsdel_nr")) %>%
  rename(stemmeberettigede = "Stemmeberettigede",
         stemmer = "Gyldige stemmer") %>%
  # type_convert(across(!c("valgsted_id", "valg")))
  mutate(across(!c("valgsted_id", "valg"), as.double)) %>%
  mutate(valg = as_factor(valg)) %>%
  mutate(red = rowSums(pick(A, B, F, Ø, Å, G), na.rm = TRUE),
         blue = rowSums(pick(C, I, O, D, I, V), na.rm = TRUE)) %>%
  mutate(red_pct = red / stemmer,
         blue_pct = blue / stemmer)

# datasummary_crosstab(data = alle_stemmer, formula = valg~partinavn)

## Ryd op i midlertidige variable
rm(alle_stemmer,
   stemmer,
   lang_alle_stemmer)

rm(alle_nrow)
