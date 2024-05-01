library(fixest)
library(tidyverse)
library(modelsummary)


m1_did <- feols(red_pct ~ i(ny_tilsluttet, valg) | valgsted_id,
            data = analyse_data)

m2_did <- feols(blue_pct ~ i(ny_tilsluttet, valg) | valgsted_id,
            data = analyse_data)

m3_did <- feols(red ~ ny_tilsluttet | valgsted_id + valg,
            data = analyse_data)

m4_did <- feols(blue ~ ny_tilsluttet | valgsted_id + valg,
            data = analyse_data)
msummary(list(m3_did, m4_did), stars = sign_stjerner)
msummary(list(m1_did, m2_did), stars = sign_stjerner)
msummary(list(m1_did, m2_did, m3_did, m4_did), stars = sign_stjerner)


# 
# ## Skab reg tbl 1
# modeller_tbl_did <- list("Rød blok pct" = m1,"Blå blok pct" = m2,"Rød blok" = m3,"Blå blok" = m4)
# gt_reg_tbl <- msummary(modeller_tbl_1, stars = sign_stjerner, output = "gt", gof_map = c("nobs", "r.squared", "adj.r.squared", "rmse", "vcov.type", "FE: valgsted_id", "FE: valg"), coef_rename = TRUE)
# gt_reg_tbl
# 
# gt_reg_tbl  %>%  opt_stylize(style = 1, color = "pink", add_row_striping = FALSE) # %>% gt::as_latex()
# 
# kable_reg_tbl <- msummary(modeller_tbl_1, stars = sign_stjerner, output = "kableExtra", gof_map = c("nobs", "r.squared", "adj.r.squared", "rmse", "vcov.type", "FE: valgsted_id", "FE: valg"), coef_rename = TRUE)
# kable_reg_tbl
# 
# markdown_reg_tbl <- msummary(modeller_tbl_1, stars = sign_stjerner, output = "markdown", gof_map = c("nobs", "r.squared", "adj.r.squared", "rmse", "vcov.type", "FE: valgsted_id", "FE: valg"), coef_rename = TRUE)
# markdown_reg_tbl
