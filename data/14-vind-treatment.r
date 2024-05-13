library(tidyverse)
library(testthat)

## Indlæser vind_stemmesteder, kommunalvalg og lang_gruppe_steder
vind_stemmesteder <- read_rds("data/rep_data/11_vind_steder.rds")
kommunalvalg <- read_rds("data/rep_data/13_kommunalvalg.rds")
lang_gruppe_steder <- read_rds("data/rep_data/13_lang_gruppe_steder.rds")


## Sikrer at de nødvendige dataframes og objekter findes
expect_true(exists("vind_stemmesteder"))
expect_true(exists("kommunalvalg"))

vind_stemmesteder
kommunalvalg

## Finder datoen for alle valg
kv2001 <- kommunalvalg$valg_dato[1]
kv2005 <- kommunalvalg$valg_dato[2]
kv2009 <- kommunalvalg$valg_dato[3]
kv2013 <- kommunalvalg$valg_dato[4]
kv2017 <- kommunalvalg$valg_dato[5]
kv2021 <- kommunalvalg$valg_dato[6]

## Sætter en nedre grænse for, hvornår vindmøller må være sat op
# laveste_dato <- as_date(ymd("1996-01-01"))
# laveste_dato <- as_date(kv2001)
laveste_dato <- as_date("1900-01-01")
expect_true(exists("laveste_dato"))

vind_treatment <- vind_stemmesteder %>%
  select(everything()) %>%
  filter(tilslutningsdato > laveste_dato) %>%
  mutate(kv01 = if_else(tilslutningsdato <= kv2001, 1, 0),
         kv05 = if_else(tilslutningsdato > kv2001 & tilslutningsdato <= kv2005, 1, 0),
         kv09 = if_else(tilslutningsdato > kv2005 & tilslutningsdato <= kv2009, 1, 0),
         kv13 = if_else(tilslutningsdato > kv2009 & tilslutningsdato <= kv2013, 1, 0),
         kv17 = if_else(tilslutningsdato > kv2013 & tilslutningsdato <= kv2017, 1, 0),
         kv21 = if_else(tilslutningsdato > kv2017 & tilslutningsdato <= kv2021, 1, 0))
colnames(vind_treatment)

## Fjerner midlertidige variable
rm(kv2001, kv2005, kv2009, kv2013, kv2017, kv2021)

kv01_treatment <- vind_treatment %>%
  select(everything()) %>%
  filter(kv01 == 1) %>%
  distinct(valgsted_id, .keep_all = TRUE)

kv05_treatment <- vind_treatment %>%
  select(everything()) %>%
  filter(kv05 == 1) %>%
  distinct(valgsted_id, .keep_all = TRUE)

kv09_treatment <- vind_treatment %>%
  select(everything()) %>%
  filter(kv09 == 1) %>%
  distinct(valgsted_id, .keep_all = TRUE)

kv13_treatment <- vind_treatment %>%
  select(everything()) %>%
  filter(kv13 == 1) %>%
  distinct(valgsted_id, .keep_all = TRUE)

kv17_treatment <- vind_treatment %>%
  select(everything()) %>%
  filter(kv17 == 1) %>%
  distinct(valgsted_id, .keep_all = TRUE)

kv21_treatment <- vind_treatment %>%
  select(everything()) %>%
  filter(kv21 == 1) %>%
  distinct(valgsted_id, .keep_all = TRUE)

treatment_list <- list(kv01_treatment, kv05_treatment, kv09_treatment, kv13_treatment,
                       kv17_treatment, kv21_treatment)
treatment <- treatment_list %>% reduce(full_join)

nye_01 <- nrow(kv01_treatment)
nye_05 <- nrow(kv05_treatment)
nye_09 <- nrow(kv09_treatment)
nye_13 <- nrow(kv13_treatment)
nye_17 <- nrow(kv17_treatment)
nye_21 <- nrow(kv21_treatment)

nye_mller <- c(nye_01, nye_05, nye_09, nye_13, nye_17, nye_21)


auto_distinct_analyse_data <- vind_treatment %>%
  full_join(lang_gruppe_steder, by = "valgsted_id") %>%
  mutate(ny_tilsluttet = case_when(valg == "KV2001" & kv01 == 1 ~ 1,
                                  valg == "KV2005" & kv05 == 1 ~ 1,
                                  valg == "KV2009" & kv09 == 1 ~ 1,
                                  valg == "KV2013" & kv13 == 1 ~ 1,
                                  valg == "KV2017" & kv17 == 1 ~ 1,
                                  valg == "KV2021" & kv21 == 1 ~ 1,
                                  .default = 0),
         valg = as.factor(valg))

analyse_data <- lang_gruppe_steder %>%
  left_join(treatment, by = "valgsted_id", unmatched = "drop") %>%
  mutate(ny_tilsluttet = case_when(valg == "KV2001" & kv01 == 1 ~ 1,
                                   valg == "KV2005" & kv05 == 1 ~ 1,
                                   valg == "KV2009" & kv09 == 1 ~ 1,
                                   valg == "KV2013" & kv13 == 1 ~ 1,
                                   valg == "KV2017" & kv17 == 1 ~ 1,
                                   valg == "KV2021" & kv21 == 1 ~ 1,
                                   .default = 0)) %>% 
  mutate(valg = as.factor(valg)) %>% 
  select(!c("1", "2", "3", "4", "5", "6", "0", "01", "02", "03", "04", "05", "06", "7",
            "K1", "K2", "T", "W", "Æ", "Å1")) %>% 
  select(!c("stemmeberettigede", "S", "mll_num", "x_koord", "y_koord", "afssted",
            "tilslutningsdato"))

### https://www.statology.org/r-unique-multiple-columns/
auto_distinct_analyse_data <- auto_distinct_analyse_data[!duplicated(
  auto_distinct_analyse_data[c("valg", "valgsted_id")]),]
