library(fixest)
library(tidyverse)
library(modelsummary)


m1 <- feols(red_pct ~ ny_tilsluttet | valgsted_id + valg,
            data = analyse_data)

m2 <- feols(blue_pct ~ ny_tilsluttet | valgsted_id + valg,
            data = analyse_data)

m3 <- feols(red ~ ny_tilsluttet | valgsted_id + valg,
            data = analyse_data)

m4 <- feols(blue ~ ny_tilsluttet | valgsted_id + valg,
            data = analyse_data)

m5_data <- analyse_data %>%
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

## Skab reg tbl 1
modeller_tbl_1 <- list("Rød blok pct" = m1,"Blå blok pct" = m2,"Rød blok" = m3,"Blå blok" = m4)
gt_reg_tbl <- msummary(modeller_tbl_1, stars = sign_stjerner, output = "gt", gof_map = c("nobs", "r.squared", "adj.r.squared", "rmse", "vcov.type", "FE: valgsted_id", "FE: valg"), coef_rename = TRUE)
gt_reg_tbl

gt_reg_tbl  %>%  opt_stylize(style = 1, color = "pink", add_row_striping = FALSE) # %>% gt::as_latex()

kable_reg_tbl <- msummary(modeller_tbl_1, stars = sign_stjerner, output = "kableExtra", gof_map = c("nobs", "r.squared", "adj.r.squared", "rmse", "vcov.type", "FE: valgsted_id", "FE: valg"), coef_rename = TRUE)
kable_reg_tbl

markdown_reg_tbl <- msummary(modeller_tbl_1, stars = sign_stjerner, output = "markdown", gof_map = c("nobs", "r.squared", "adj.r.squared", "rmse", "vcov.type", "FE: valgsted_id", "FE: valg"), coef_rename = TRUE)
markdown_reg_tbl
