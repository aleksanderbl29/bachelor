library(fixest)
library(did)
library(tidyverse)
library(modelsummary)
library(bacondecomp)

## manuel FE
within <- analyse_data %>% 
  select(everything()) %>% 
  group_by(valgsted_id) %>% 
  mutate(borgmester_stemmer_within = borgmester_stemmer - mean(borgmester_stemmer),
         borgmester_stemmer_pct_within = borgmester_stemmer_pct - mean(borgmester_stemmer_pct))


placebo_data_1 <- analyse_data %>% 
  select(everything()) %>% 
  mutate(tilslutning_aar_valg = tilslutning_aar_valg + 6)

analyse_data <- analyse_data %>%
  mutate(tilslutning_aar = as_factor(tilslutning_aar))
# 
# analyse_data$tilslutning_aar <- fct_relevel(analyse_data$tilslutning_aar, "0", after = 0)

rigtig_model <- feols(borgmester_stemmer ~ tilslutning_aar | valgsted_id + valg, data = analyse_data)
rigtig_model <- feols(borgmester_stemmer ~ tilslutning_aar | kommunenr + valg, data = analyse_data)
summary(rigtig_model)
within_rigtig_model <- feols(borgmester_stemmer ~ tilslutning_aar | valgsted_id + valg, data = within)
summary(within_rigtig_model)
manuel_rigtig <- lm(borgmester_stemmer_within ~ tilslutning_aar + as.factor(valg), data = within)
summary(manuel_rigtig)
rigtig_ols <- lm(borgmester_stemmer ~ tilslutning_aar, data = analyse_data)
summary(rigtig_ols)

within_pct_feols <- feols(borgmester_stemmer_pct ~ tilslutning_aar | valgsted_id + valg, data = within)
summary(within_pct_feols)
pct_feols <- feols(borgmester_stemmer_pct ~ tilslutning_aar | valgsted_id + valg, data = analyse_data)
summary(pct_feols)
pct_manuel <- lm(borgmester_stemmer_pct_within ~ tilslutning_aar + as.factor(valg), data = within)
summary(pct_manuel)
pct_ols <- lm(borgmester_stemmer_pct ~ tilslutning_aar, data = analyse_data)
summary(pct_ols)

fe_m1 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg | valgsted_id + valg, data = analyse_data)
summary(fe_m1)
summary(pct_feols)

placebo_1 <- feols(borgmester_stemmer ~ tilslutning_aar_valg | valgsted_id + valg, data = placebo_data_1)
summary(placebo_1)

msummary(list(within_rigtig_model, manuel_rigtig, within_pct_feols, pct_manuel), stars = sign_stjerner, gof_map = c("nobs", "r.squared", "adj.r.squared", "rmse", "vcov.type", "FE: valgsted_id", "FE: valg"), coef_rename = TRUE)

msummary(list(rigtig_model, manuel_rigtig, rigtig_ols, pct_feols, pct_manuel, pct_ols), stars = sign_stjerner, gof_map = c("nobs", "r.squared", "adj.r.squared", "rmse", "vcov.type", "FE: valgsted_id", "FE: valg"), coef_rename = TRUE)

fe_tbl_1_modeller <- list(rigtig_model, manuel_rigtig, rigtig_ols, pct_feols, pct_manuel, pct_ols)
fe_tbl_1 <- msummary(fe_tbl_1_modeller, stars = sign_stjerner, output = "gt", gof_map = c("nobs", "r.squared", "adj.r.squared", "rmse", "vcov.type", "FE: valgsted_id", "FE: valg"), coef_rename = TRUE)
fe_tbl_1

fe_tbl_2_modeller <- list(within_rigtig_model, manuel_rigtig, within_pct_feols, pct_manuel)
fe_tbl_2 <- msummary(fe_tbl_2_modeller, stars = sign_stjerner, output = "gt", gof_map = c("nobs", "r.squared", "adj.r.squared", "rmse", "vcov.type", "FE: valgsted_id", "FE: valg"), coef_rename = TRUE)
fe_tbl_2
