library(tidyverse)
library(logger)
library(testthat)

## Gemmer analyse data
analyse_data <- read_rds("data/rep_data/17_analyse_data.rds") %>% 
  filter(valg != "KV2005")

## Sikrer at ingen duplikerede data findes
unikke_obs <- analyse_data %>%
  distinct(across(c("valg", "valgsted_id", "kommune_valg_id")), .keep_all = TRUE)

test <- analyse_data %>% 
  anti_join(unikke_obs)

expect_true(nrow(test) == 0)

log_info("Gemmer analyse_data til disk")
write_rds(analyse_data, "data/rep_data/rep_analyse_data.rds")

## Rydder miljøet
rm(list = ls())
