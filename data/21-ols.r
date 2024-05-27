library(tidyverse)
library(modelsummary)
library(marginaleffects)
library(fixest)

did_bin_data <- analyse_data %>% 
  filter(tilslutning_aar_valg == 0 | tilslutning_aar_valg == 1)

ols_1 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg, data = did_bin_data)
summary(ols_1)

ols_2 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg + Parti, data = did_bin_data)
summary(ols_2)

ols_3 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg * Parti, data = did_bin_data)
summary(ols_3)

ols_4 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg * blok, data = did_bin_data)
summary(ols_4)

modeller_ols_tbl_1 <- list(ols_1, ols_2, ols_3)

msummary(modeller_ols_tbl_1, stars = TRUE)

ols_tbl_1_gof_map <- tribble(
  ~raw, ~clean, ~fmt,
  "nobs", "Obs.", 0,
  # "adj.r.squared", "R2 just.", 3,
  # "r2.within.adjusted", "R2 within just.", 3,
  "rmse", "RMSE", 2,
  # "vcov.type", "Std. fejl klynge", 20,
  "FE: valgsted_id", "FE: Valgsted", 20,
  "FE: valg", "FE: Valg", 20
)

ols_tbl_1 <- msummary(modeller_ols_tbl_1, stars = TRUE, output = "kableExtra",
                      gof_map = ols_tbl_1_gof_map, coef_map = c(
                        "(Intercept)" = "Skæring",
                        "blue_blok" = "Blå blok",
                        "PartiVenstre" = "Venstre",
                        "tilslutning_aar_valg:blue_blok" = "Vindmølle tilsluttet x Blå blok",
                        "tilslutning_aar_valg:PartiVenstre" = "Vindmølle tilsluttet x Venstre"
                      ),
                      vcov = ~valgsted_id)
ols_tbl_1

plot_predictions(ols_3, condition = c("tilslutning_aar_valg", "Parti"))

plot_slopes(ols_3, variables = "tilslutning_aar_valg", by = "Parti")


