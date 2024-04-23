library(fixest)
library(tidyverse)
library(modelsummary)


m1 <- feols(red_pct ~ ny_tilsluttet | valgsted_id + valg,
            data = analyse_data, verbose = 999)

m2 <- feols(blue_pct ~ ny_tilsluttet | valgsted_id + valg,
            data = analyse_data, verbose = 999)

m3 <- feols(red ~ ny_tilsluttet | valgsted_id + valg,
            data = analyse_data, verbose = 999)

m4 <- feols(blue ~ ny_tilsluttet | valgsted_id + valg,
            data = analyse_data, verbose = 999)

m3 <- lm(red_pct ~ ny_tilsluttet, data = analyse_data)

m4 <- lm(blue_pct ~ ny_tilsluttet, data = analyse_data)

m5_data <- auto_distinct_analyse_data %>% 
  group_by(valgsted_id) %>% 
  mutate(ny_tilsluttet_within = ny_tilsluttet - mean(ny_tilsluttet),
         red_within = red - mean(red)) %>% 
  ungroup() %>% 
  drop_na(red_within) %>% 
  drop_na(ny_tilsluttet)

m5 <- m5_data %>% mutate(ny_tilsluttet = ny_tilsluttet_within) %>% 
  lm(red_within ~ ny_tilsluttet, data = ., na.action = na.omit)
m6 <- lm(red_within ~ ny_tilsluttet, data = m5_data)

msummary(list(m3, m4), stars = sign_stjerner)
msummary(list(m1, m2), stars = sign_stjerner)
msummary(list(m1, m2, m3, m4), stars = sign_stjerner)
msummary(list(m1, m2, m3, m4, m5, m6), stars = sign_stjerner)
