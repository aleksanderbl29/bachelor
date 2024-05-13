library(fixest)
library(did)
library(tidyverse)
library(modelsummary)
library(bacondecomp)

att_gt(yname = "borgmester_stemmer_pct",
       gname = "tislutning_aar",
       idname = "valgsted_id",
       tname = "valgaar",
       xformla ~1,
       data = analyse_data,
       est_method = "reg")

## manuel FE
within <- analyse_data %>% 
  select(everything()) %>% 
  group_by(valgsted_id) %>% 
  mutate(borgmester_stemmer_within = borgmester_stemmer - mean(borgmester_stemmer),
         borgmester_stemmer_pct_within = borgmester_stemmer_pct - mean(borgmester_stemmer_pct))

rigtig_model <- feols(borgmester_stemmer ~ tilslutning_aar | valgsted_id + valg, data = analyse_data)
summary(rigtig_model)
manuel_rigtig <- feols(borgmester_stemmer ~ tilslutning_aar | valgsted_id, data = within)
summary(manuel_rigtig)
rigtig_ols <- lm(borgmester_stemmer ~ tilslutning_aar, data = analyse_data)
summary(rigtig_ols)

pct_feols <- feols(borgmester_stemmer_pct ~ tilslutning_aar | valgsted_id + valg, data = analyse_data)
summary(pct_feols)
pct_manuel <- lm(borgmester_stemmer_pct_within ~ tilslutning_aar, data = within)
summary(pct_manuel)
pct_ols <- lm(borgmester_stemmer_pct ~ tilslutning_aar, data = analyse_data)
summary(pct_ols)



msummary(list(rigtig_model, manuel_rigtig, rigtig_ols, pct_feols, pct_manuel, pct_ols), stars = sign_stjerner, gof_map = c("nobs", "r.squared", "adj.r.squared", "rmse", "vcov.type", "FE: valgsted_id", "FE: valg"), coef_rename = TRUE)

bacon(borgmester_stemmer_pct ~ tilslutning_aar, analyse_data, "valgsted_id", "valg")

