library(tidyverse)

## Indlæser analyse data
analyse_data <- read_rds("data/rep_data/15_analyse_data.rds")

## Laver dynamisk tilslutningsvariabel
analyse_data <- analyse_data %>% 
  select(everything()) %>%
  mutate(tilslutning_aar = case_when(kv09 == 1 & valg_id == "kv09" ~ 1,
                                     kv09 == 1 & valg_id != "kv09" ~ (((valgaar - 2009) / 4) + 1),
                                     kv13 == 1 & valg_id == "kv13" ~ 1,
                                     kv13 == 1 & valg_id != "kv13" ~ (((valgaar - 2013) / 4) + 1),
                                     kv17 == 1 & valg_id == "kv17" ~ 1,
                                     kv17 == 1 & valg_id != "kv17" ~ (((valgaar - 2017) / 4) + 1),
                                     kv21 == 1 & valg_id == "kv21" ~ 1,
                                     kv21 == 1 & valg_id != "kv21" ~ (((valgaar - 2021) / 4) + 1),
                                     .default = 0))

## Gemmer analyse data
write_rds(analyse_data, "data/rep_data/16_analyse_data.rds")

## Rydder miljøet
rm(list = ls())
