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

analyse_data <- analyse_data %>% 
  mutate(tilslutning_aar = as_factor(tilslutning_aar))

analyse_data$tilslutning_aar <- fct_relevel(analyse_data$tilslutning_aar, "0", after = 0)

rigtig_model <- feols(borgmester_stemmer ~ tilslutning_aar | valgsted_id + valg, data = analyse_data)
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

msummary(list(within_rigtig_model, manuel_rigtig, within_pct_feols, pct_manuel), stars = sign_stjerner, gof_map = c("nobs", "r.squared", "adj.r.squared", "rmse", "vcov.type", "FE: valgsted_id", "FE: valg"), coef_rename = TRUE)

msummary(list(rigtig_model, manuel_rigtig, rigtig_ols, pct_feols, pct_manuel, pct_ols), stars = sign_stjerner, gof_map = c("nobs", "r.squared", "adj.r.squared", "rmse", "vcov.type", "FE: valgsted_id", "FE: valg"), coef_rename = TRUE)


## Did pakken
att_gt(yname = "borgmester_stemmer_pct",
       gname = "tislutning_aar",
       idname = "valgsted_id",
       tname = "valgaar",
       xformla ~1,
       data = analyse_data,
       est_method = "reg")

## Bacon decomp
bacon(borgmester_stemmer_pct ~ tilslutning_aar, analyse_data, "valgsted_id", "valg")

