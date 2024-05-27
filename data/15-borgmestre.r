library(tidyverse)
library(testthat)
library(readxl)

## Indlæser analyse_data
analyse_data <- read_rds("data/rep_data/14_analyse_data.rds")

## Indlæser borgmester data fra excel og omformer
borgmestre <- read_xlsx("data/downloads/Borgmestre/borgmestre_samlet.xlsx", sheet = "import_til_r") %>% 
  select(1:12) %>% 
  select(!siddende) %>% 
  pivot_longer(starts_with("kv"), names_to = "valg_id") %>% 
  filter(value == 1) %>%
  arrange(valg_id) %>% 
  rename(kommunenavn = Kommunenavn) %>% 
  mutate(valgaar = as.numeric(paste0(20, substr(valg_id, 3, 4)))) %>% 
  mutate(kommunenavn = case_when(kommunenavn == "Bornholm" ~ "Bornholms Region",
                                 .default = kommunenavn)) %>% 
  arrange(kommunenavn) %>% 
  filter(valgaar > 2006)

## Indlæser geografi
geografi <- read_rds("data/rep_data/13_geografi.rds")

## Indlæser liste over kommuner
kommuner <- read_rds("data/rep_data/13_kommuner.rds")

## Tester at der ingen fejl matches er på kommunenavn og alle kommuner findes.
## Fjerner df efter brug
anti_borgmestre <- borgmestre %>% 
  anti_join(kommuner, by = "kommunenavn") %>% 
  filter(valgaar > 2006)
expect_true(nrow(anti_borgmestre) == 0)
expect_true(n_distinct(borgmestre$kommunenavn) == 98)
rm(anti_borgmestre)

## Sammensætter borgmestre med kommuneid
borgmestre <- borgmestre %>% 
  left_join(kommuner, by = "kommunenavn") 
## Skaber identifikator til sammenlægning med valgsted
borgmestre <- borgmestre %>% 
  mutate(kommune_valg_id = paste0(kommunenr, valg_id))

## Laver valg_id
analyse_data <- analyse_data %>% 
  select(everything()) %>% 
  mutate(valg_id = paste0("kv", substr(valg, 5, 6))) %>% 
  mutate(kommune_valg_id = paste0(kommunenr, valg_id),
         valgaar = paste0(20, substr(valg_id, 3, 4))) %>% 
  filter(valgaar > 2004)

## Tjekker at alle valgsteder matcher en kommune
anti_tjek_analyse <- analyse_data %>% 
  anti_join(borgmestre, by = "kommune_valg_id") %>% 
  filter(valgaar > 2006)
expect_true(nrow(anti_tjek_analyse) == 0)
rm(anti_tjek_analyse)

## Sammensætter valgsteder med kommuner
analyse_data <- analyse_data %>% 
  select(!c("valgaar", "kommunenr", "valg_id")) %>% 
  left_join(borgmestre, by = "kommune_valg_id") %>% 
  select(!c("Periode", "start_periode", "slut_periode"))

## Laver dep_var kolonne til borgmesterparti stemmer
analyse_data <- analyse_data %>% 
  select(everything()) %>% 
  mutate(borgmester_stemmer = case_when(Parti == "Socialdemokratiet"           ~ A,
                                        Parti == "Det Konservative Folkeparti" ~ C,
                                        Parti == "Venstre"                     ~ V,
                                        Parti == "Lokalliste"                  ~ L,
                                        Parti == "Radikale Venstre"            ~ B,
                                        Parti == "Socialistisk Folkeparti"     ~ F,
                                        Parti == "Alternativet"                ~ Å,
                                        Parti == "Dansk Folkeparti"            ~ O,
                                        .default = NA)) %>% 
  mutate(borgmester_stemmer_pct = borgmester_stemmer / stemmer * 100) %>% 
  mutate(Parti = as.factor(Parti))


write_rds(analyse_data, "data/rep_data/15_analyse_data.rds")
write_rds(borgmestre, "data/rep_data/15_borgmestre.rds")
