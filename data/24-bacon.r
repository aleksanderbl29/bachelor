library(bacondecomp)
library(tidyverse)

bacon_analyse_data <- analyse_data %>% 
  filter(valg %in% c("KV2009", "KV2013", "KV2017", "KV2021"))

bacon(red_pct ~ ny_tilsluttet, bacon_analyse_data, "valgsted_id", "valg")
