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




