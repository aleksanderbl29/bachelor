library(tidyverse)
library(modelsummary)

ols1_data <- analyse_data %>% 
  mutate(ny_tilsluttet = ifelse(ny_tilsluttet == 1, TRUE, FALSE))

ols_1 <- lm(borgmester_stemmer ~ ny_tilsluttet,
                      data = ols1_data)
summary(ols_1)

ols2_data <- analyse_data %>% 
  select(everything()) %>% 
  mutate(tilslutning_aar = case_when(kv09 == 1 & valg_id == "kv09" ~ 1,
                                     kv09 == 1 & valg_id != "kv09" ~ (valgaar - 2009) / 4,
                                     kv13 == 1 & valg_id == "kv13" ~ 1,
                                     kv13 == 1 & valg_id != "kv13" ~ (valgaar - 2009) / 4,
                                     kv17 == 1 & valg_id == "kv17" ~ 1,
                                     kv17 == 1 & valg_id != "kv17" ~ (valgaar - 2009) / 4,
                                     kv21 == 1 & valg_id == "kv21" ~ 1,
                                     kv21 == 1 & valg_id != "kv21" ~ (valgaar - 2009) / 4,
                                     .default = 0))

ols_2 <- lm(borgmester_stemmer ~ tilslutning_aar, data = ols2_data)
summary(ols_2)

msummary(list(ols_1, ols_2), stars = sign_stjerner)

gt_reg_tbl <- msummary(modeller_tbl_1, stars = sign_stjerner, output = "gt", gof_map = c("nobs", "r.squared", "adj.r.squared", "rmse", "vcov.type", "FE: valgsted_id", "FE: valg"), coef_rename = TRUE)
gt_reg_tbl
