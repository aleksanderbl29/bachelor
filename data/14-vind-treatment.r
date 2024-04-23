library(tidyverse)

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
laveste_dato <- as_date(ymd("1996-01-01"))
expect_true(exists("laveste_dato"))

# vp_01_05 <- as.interval(as.period(kv2005 - kv2001), start = kv2001)
# vp_05_09 <- as.interval(as.period(kv2009 - kv2005), start = kv2005)
# vp_09_13 <- as.interval(as.period(kv2013 - kv2009), start = kv2009)
# vp_13_17 <- as.interval(as.period(kv2017 - kv2013), start = kv2013)
# vp_17_21 <- as.interval(as.period(kv2021 - kv2017), start = kv2017)
# 
# vp_01_05
# vp_05_09
# vp_09_13
# vp_13_17
# vp_17_21


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

