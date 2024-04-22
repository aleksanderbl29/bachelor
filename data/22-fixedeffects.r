library(fixest)
library(tidyverse)
library(modelsummary)

m1 <- feols(blue ~ ny_tilsluttet | valgsted_id + valg,
            data = analyse_data, verbose = 999)

m2 <- feols(blue ~ ny_tilsluttet | valgsted_id + valg,
            data = manuel_distinct_analyse_data, verbose = 999)

m3_data <- manuel_distinct_analyse_data %>% 
  group_by(valgsted_id) %>% 
  mutate(ny_tilsluttet_within = ny_tilsluttet - mean(ny_tilsluttet),
         red_within = red - mean(red)) %>% 
  ungroup() %>% 
  drop_na(red_within) %>% 
  drop_na(ny_tilsluttet)

m3 <- lm(red_within ~ ny_tilsluttet_within, data = m3_data, na.action = na.omit)
m4 <- lm(red_within ~ ny_tilsluttet, data = m3_data)
msummary(list(m3, m4), stars = sign_stjerner)
msummary(list(m1, m2), stars = sign_stjerner)
