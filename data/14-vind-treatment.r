library(tidyverse)
library(logger)
library(testthat)

## Rydder miljøet inden kørsel
rm(list = ls())

## Indlæser vind_stemmesteder, kommunalvalg og lang_gruppe_steder
vind_stemmesteder <- read_rds("data/rep_data/11_vind_steder.rds")
kommunalvalg <- read_rds("data/rep_data/13_kommunalvalg.rds")
lang_gruppe_steder <- read_rds("data/rep_data/13_lang_gruppe_steder.rds")

# lang_gruppe_steder <- lang_gruppe_steder %>% 
#   mutate(valgsted_id = as.factor(valgsted_id))

## Sikrer at de nødvendige dataframes og objekter findes
expect_true(exists("vind_stemmesteder"))
expect_true(exists("kommunalvalg"))

## Finder datoen for alle valg
kv2009 <- kommunalvalg$valg_dato[1]
kv2013 <- kommunalvalg$valg_dato[2]
kv2017 <- kommunalvalg$valg_dato[3]
kv2021 <- kommunalvalg$valg_dato[4]

## Sætter en nedre grænse for, hvornår vindmøller må være sat op
# laveste_dato <- as_date(ymd("1996-01-01"))
# laveste_dato <- as_date(kv2009)
laveste_dato <- as_date("2005-11-15")
expect_true(exists("laveste_dato"))

vind_treatment <- vind_stemmesteder %>%
  select(everything()) %>%
  filter(tilslutningsdato > laveste_dato) %>%
  mutate(kv09 = if_else(tilslutningsdato <= kv2009, 1, 0),
         kv13 = if_else(tilslutningsdato > kv2009 & tilslutningsdato <= kv2013, 1, 0),
         kv17 = if_else(tilslutningsdato > kv2013 & tilslutningsdato <= kv2017, 1, 0),
         kv21 = if_else(tilslutningsdato > kv2017 & tilslutningsdato <= kv2021, 1, 0))
colnames(vind_treatment)

## Fjerner midlertidige variable
rm(kv2009, kv2013, kv2017, kv2021)

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

treatment_list <- list(kv09_treatment, kv13_treatment,
                       kv17_treatment, kv21_treatment)
treatment <- treatment_list %>% reduce(full_join)

log_info("Sorterer gamle møller fra")
treatment <- treatment %>% 
  filter(tilslutningsdato > laveste_dato) %>% 
  arrange(tilslutningsdato)

log_info("Beholder kun første vindmølle ved valgsted")
treatment <- treatment[match(unique(treatment$tilslutningsdato), treatment$tilslutningsdato),]

treatment <- treatment %>% 
  mutate(tilsluttet_i = case_when(kv09 == 1 ~ "kv09",
                                  kv13 == 1 ~ "kv13",
                                  kv17 == 1 ~ "kv17",
                                  kv21 == 1 ~ "kv21",
                                  .default = NA))

treatment <- treatment[match(unique(treatment$valgsted_id), treatment$valgsted_id),]

nye_09 <- nrow(kv09_treatment)
nye_13 <- nrow(kv13_treatment)
nye_17 <- nrow(kv17_treatment)
nye_21 <- nrow(kv21_treatment)

nye_mller <- c(nye_09, nye_13, nye_17, nye_21)

auto_distinct_analyse_data <- vind_treatment %>%
  full_join(lang_gruppe_steder, by = "valgsted_id") %>%
  mutate(ny_tilsluttet = as.numeric(case_when(valg == "KV2009" & kv09 == 1 ~ 1,
                                              valg == "KV2013" & kv13 == 1 ~ 1,
                                              valg == "KV2017" & kv17 == 1 ~ 1,
                                              valg == "KV2021" & kv21 == 1 ~ 1,
                                              .default = 0)),
         valg = as.factor(valg),
         valgsted_id = as.factor(valgsted_id)) %>% 
  mutate(kommunenr = as.double(substr(valgsted_id, 1, 3)))

analyse_data <- lang_gruppe_steder %>%
  # left_join(treatment, by = "valgsted_id", unmatched = "error") %>%
  left_join(treatment, by = "valgsted_id", unmatched = "drop") %>%
  mutate(ny_tilsluttet = case_when(valg == "KV2009" & kv09 == 1 ~ 1,
                                   valg == "KV2013" & kv13 == 1 ~ 1,
                                   valg == "KV2017" & kv17 == 1 ~ 1,
                                   valg == "KV2021" & kv21 == 1 ~ 1,
                                   kv09 == 0 & kv13 == 0 & kv17 == 0 & kv21 == 0 ~ 0,
                                   .default = NA)) %>%
  mutate(valg = as.factor(valg),
         valgsted_id = as.factor(valgsted_id)) %>%
  mutate(across(4:21, ~replace_na(.x, 0))) %>% 
  select(!c("stemmeberettigede", "S", "mll_num", "x_koord", "y_koord", "afssted",
            "tilslutningsdato"))

unikke_obs <- analyse_data %>%
  distinct(across(c("valg", "valgsted_id")), .keep_all = TRUE)

unik_analyse_data <- analyse_data %>%
  rowwise() %>%
  mutate(kombineret = paste0(valg, valgsted_id, ny_tilsluttet)) %>%
  distinct(kombineret)

unique(unik_analyse_data$kombineret)
n_distinct(unik_analyse_data$kombineret)

### https://www.statology.org/r-unique-multiple-columns/
auto_distinct_analyse_data <- auto_distinct_analyse_data[!duplicated(
  auto_distinct_analyse_data[c("valg", "valgsted_id")]),]

## Finder kommunenr til df
analyse_data <- analyse_data %>% 
  mutate(kommunenr = as.double(substr(valgsted_id, 1, 3)))

## Gemmer objekter
write_rds(analyse_data, "data/rep_data/14_analyse_data.rds")

cont_table <- table(analyse_data$valgsted_id, analyse_data$valg)

filtered_cont_table <- cont_table[rowSums(cont_table) != 4, ]

valgsteder_med_fejl <- filtered_cont_table %>% rownames()

filtered_analyse_data <- analyse_data[analyse_data$valgsted_id %in% valgsteder_med_fejl, ]

expect_true(nrow(filtered_analyse_data) == 0)


## Rydder miljøet
rm(list = ls())
