library(tidyverse)

## Indlæser analyse data
analyse_data <- read_rds("data/rep_data/15_analyse_data.rds")

## Laver dynamisk tilslutningsvariabel
analyse_data <- analyse_data %>%
  select(everything()) %>%
  mutate(tilslutning_aar_valg = case_when(kv09 == 1 & valg_id == "kv09" ~ 1,
                                          kv09 == 1 & valg_id != "kv09" ~ (((valgaar - 2009) / 4) + 1),
                                          kv13 == 1 & valg_id == "kv13" ~ 1,
                                          kv13 == 1 & valg_id != "kv13" ~ (((valgaar - 2013) / 4) + 1),
                                          kv17 == 1 & valg_id == "kv17" ~ 1,
                                          kv17 == 1 & valg_id != "kv17" ~ (((valgaar - 2017) / 4) + 1),
                                          kv21 == 1 & valg_id == "kv21" ~ 1,
                                          kv21 == 1 & valg_id != "kv21" ~ (((valgaar - 2021) / 4) + 1),
                                          .default = 0)) %>%
  mutate(tilslutning_aar = case_when(kv09 == 1 & valg_id == "kv09" ~ 1,
                                     kv09 == 1 & valg_id != "kv09" ~ (valgaar - 2009),
                                     kv13 == 1 & valg_id == "kv13" ~ 1,
                                     kv13 == 1 & valg_id != "kv13" ~ (valgaar - 2013),
                                     kv17 == 1 & valg_id == "kv17" ~ 1,
                                     kv17 == 1 & valg_id != "kv17" ~ (valgaar - 2017),
                                     kv21 == 1 & valg_id == "kv21" ~ 1,
                                     kv21 == 1 & valg_id != "kv21" ~ (valgaar - 2021),
                                     .default = 0),
         tilslutning_treat = case_when(kv09 == 1 & valg_id == "kv09" ~ 1,
                                       kv09 == 1 & valg_id != "kv09" ~ (((valgaar - 2009) / 4) + 1),
                                       kv13 == 1 & valg_id == "kv13" ~ 1,
                                       kv13 == 1 & valg_id != "kv13" ~ (((valgaar - 2013) / 4) + 1),
                                       kv17 == 1 & valg_id == "kv17" ~ 1,
                                       kv17 == 1 & valg_id != "kv17" ~ (((valgaar - 2017) / 4) + 1),
                                       kv21 == 1 & valg_id == "kv21" ~ 1,
                                       kv21 == 1 & valg_id != "kv21" ~ (((valgaar - 2021) / 4) + 1),
                                       .default = NA),
         tilslutning_bin = as.factor(case_when(tilslutning_aar_valg == 1 ~ 1,
                                     tilslutning_aar_valg != 1 ~ 0)))

log_info("Laver variabel med borgmesterens blok")
analyse_data <- analyse_data %>%
  mutate(blok = as.factor(case_match(Parti,
                           c("Socialdemokratiet", "Radikale Venstre", "Alternativet", "Socialistisk Folkeparti") ~ "Rød blok",
                           c("Venstre", "Det Konservative Folkeparti", "Dansk Folkeparti") ~ "Blå blok",
                           "Lokalliste" ~ NA)))
analyse_data <- analyse_data %>%
  mutate(blue_blok = if_else(blok == "Blå blok", 1, 0))

log_info("Ændrer levels på parti og blok")
analyse_data$Parti <- fct_relevel(analyse_data$Parti, "Socialdemokratiet", "Venstre", "Det Konservative Folkeparti", "Lokalliste", "Radikale Venstre", "Socialistisk Folkeparti", "Alternativet", "Dansk Folkeparti")
analyse_data$blok <- fct_relevel(analyse_data$blok, "Rød blok", "Blå blok")


log_info("Forberedeer til CS21")
analyse_data <- analyse_data %>%
  mutate(time = valgaar - 2005) %>% 
  mutate(time = time / 4) %>% 
  mutate(index_valgsted = as.double(valgsted_id))



## Gemmer analyse data
write_rds(analyse_data, "data/rep_data/16_analyse_data.rds")

## Rydder miljøet
rm(list = ls())
