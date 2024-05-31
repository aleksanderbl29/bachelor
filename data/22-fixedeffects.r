library(tidyverse)
library(testthat)
library(fixest)
library(did)
library(modelsummary)
library(bacondecomp)
library(kableExtra)
library(gt)

venstre_analyse_data <- analyse_data %>%
  mutate(Parti = case_when(Parti == "Venstre" ~ ".Venstre",
                           .default = Parti))

test1 <- analyse_data %>%
  filter(!Parti %in% c("Dansk Folkeparti", "Alternativet"))
test2 <- venstre_analyse_data %>%
  filter(!Parti %in% c("Dansk Folkeparti", "Alternativet"))

analyse_data_uden <- analyse_data %>%
  filter(borgmester_stemmer > 1)


## Sikrer analyse data findes
expect_true(exists("analyse_data"))

fe_m1 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg, data = analyse_data)
fe_m1
summary(fe_m1, cluster = "valgsted_id")

fe_m2 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg + sunab(tilslutning_bin, tilslutning_aar_valg), data = analyse_data)
fe_m2

fe_m3 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg + sunab(tilslutning_bin, tilslutning_aar_valg), data = analyse_data_uden)
fe_m3

fe_m4 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg | valgsted_id + valg, data = analyse_data_uden)
fe_m4


## Borgmesterparti som kontrolvariabel
borgmester_analyse_data <- analyse_data %>%
  filter(!Parti %in% c("Socialistisk Folkeparti", "Alternativet", "Dansk Folkeparti"))
#   filter(Parti != "Lokalliste")

analyse_data %>% filter(Parti == "Lokalliste") %>% distinct(kommune_valg_id) %>% nrow

fe_m5 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg + Parti | valgsted_id + valg,
               data = analyse_data)
fe_m5

fe_m5_uden <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg + Parti | valgsted_id + valg,
               data = analyse_data_uden)
fe_m5_uden

fe_m6 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg * Parti | valgsted_id + valg,
               data = analyse_data)
fe_m6

fe_m6_uden <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg * Parti | valgsted_id + valg,
               data = analyse_data_uden)
fe_m6_uden

fe_m7 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg * blue_blok | valgsted_id + valg, data = analyse_data)
fe_m7

fe_m8 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg * Parti | valgsted_id + valg, data = analyse_data)
fe_m8

analyse_data_plt <- analyse_data %>% 
  filter(!Parti %in% c("Dansk Folkeparti", "Alternativet", "Socialistisk Folkeparti"))

fe_m8_plt <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg * Parti | valgsted_id + valg, data = analyse_data_plt)
fe_m8_plt

fe_m10 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg + Parti, data = analyse_data)
fe_m10

fe_m10_uden <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg + Parti, data = analyse_data_uden)
fe_m10_uden

## Her tester jeg sunab() modellen fra Sun og Abraham 2021

test_fe_m1 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg +
                      sunab(tilslutning_bin, tilslutning_aar_valg) | valgsted_id + valg, data = analyse_data)
test_fe_m1


test_fe_m7 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg * blue_blok +
                      sunab(tilslutning_bin, tilslutning_aar_valg) | valgsted_id + valg, data = analyse_data)
test_fe_m7

test_fe_m8 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg * Parti +
                      sunab(tilslutning_bin, tilslutning_aar_valg) | valgsted_id + valg, data = analyse_data)
test_fe_m8


appendix_a_modeller <- list(fe_m10, fe_m5, fe_m6)
appendix_a_modeller_uden <- list(fe_m10_uden, fe_m5_uden, fe_m6_uden)
msummary(appendix_a_modeller, stars = TRUE)

bacon_data <- slice_sample(analyse_data, n = 50, by = c("valgsted_id", "valg"))

cont_table <- table(bacon_data$valgsted_id, bacon_data$valg)

filtered_cont_table <- cont_table[rowSums(cont_table) != 4, ]

valgsteder_med_fejl <- filtered_cont_table %>% rownames()

filtered_analyse_data <- bacon_data[bacon_data$valgsted_id %in% valgsteder_med_fejl, ]

expect_true(nrow(filtered_analyse_data) == 0)

feols(borgmester_stemmer_pct ~ tilslutning_aar_valg | valgsted_id + valg, data = analyse_data)


tbl_borgmester_modeller <- list("Model 1" = fe_m1,
                                "Fixed Effects" = fe_m4,
                                "Kun genopstillede partier" = fe_m3)

tbl_borgmester_interaktion_modeller <- list("Simpel m parti" = fe_m10,
                                            "Interak. 1" = fe_m7,
                                            "S og A interak. 1" = test_fe_m7,
                                            "Interak. 2" = fe_m8,
                                            "S og A interak. 2" = test_fe_m8)



tbl_borgmester_modeller_gof_map <- tribble(
  ~raw, ~clean, ~fmt,
  "nobs", "Obs.", 0,
  "adj.r.squared", "R2 adj.", 3,
  "r2.within.adjusted", "R2 within adj.", 3,
  "rmse", "RMSE", 2,
  "FE: valgsted_id", "Fixed Effects", 20,
  "FE: valg", "Fixed Effects", 20
)

tbl_borgmester_interaktion_modeller_gof_map <- tribble(
  ~raw, ~clean, ~fmt,
  "nobs", "Obs.", 0,
  "adj.r.squared", "R2 adj.", 3,
  "r2.within.adjusted", "R2 within adj.", 3,
  "rmse", "RMSE", 2,
  # "vcov.type", "Std. fejl klynge", 20,
  # "FE: valgsted_id", "FE: Valgsted", 20,
  # "FE: valg", "FE: Valg", 20
  "FE: valgsted_id", "Fixed Effects", 20,
  "FE: valg", "Fixed Effects", 20
)



tbl_borgmester <- msummary(tbl_borgmester_modeller,
                           output = "kableExtra", gof_omit = "AIC|BIC",
                           coef_map = c(
                             "(Intercept)" = "Skæring",
                             "tilslutning_aar_valg" = "Vindmølle tilsluttet"
                           ), vcov = ~valgsted_id,
                           gof_map = tbl_borgmester_modeller_gof_map,
                           estimate = "{estimate}{stars}", escape = FALSE) %>%
  kable_styling(full_width = TRUE, latex_options = c("repeat_header"), latex_table_env = "fonttable", font_size = 10) %>%
  column_spec(1, width = "5cm") %>% 
  add_header_above(c(" " = 1, "Afhængig: Stemmeandel til borgmesterparti i %" = 3))
tbl_borgmester

tbl_borgmester_interaktion <- msummary(tbl_borgmester_interaktion_modeller,
                                       output = "kableExtra", gof_omit = "AIC|BIC",
                                       coef_map = c(
                                         "tilslutning_aar_valg" = "Vindmølle tilsluttet",
                                         "blue_blok" = "Blå blok",
                                         "PartiVenstre" = "Venstre",
                                         "tilslutning_aar_valg:blue_blok" = "Vindmølle tilsluttet x Blå blok",
                                         "tilslutning_aar_valg:PartiVenstre" = "Vindmølle tilsluttet x Venstre",
                                         "tilslutning_aar_valg:PartiSocialdemokratiet" = "Vindmølle tilsluttet x Socialdemokratiet"
                                       ), gof_map = tbl_borgmester_interaktion_modeller_gof_map,
                                       estimate = "{estimate}{stars}", escape = FALSE) %>%
  kable_styling(full_width = TRUE, latex_options = c("repeat_header"), latex_table_env = "fonttable", font_size = 10) %>%
  column_spec(1, width = "5cm") %>% 
  add_header_above(c(" " = 1, "Afhængig: Stemmeandel til borgmesterparti i %" = 5))
tbl_borgmester_interaktion


msummary(tbl_borgmester_interaktion_modeller,
         output = "kableExtra", gof_omit = "AIC|BIC",
         gof_map = tbl_borgmester_interaktion_modeller_gof_map,
         estimate = "{estimate}{stars}") %>%
  kable_styling(full_width = TRUE, latex_options = c("repeat_header"), latex_table_env = "fonttable", font_size = 10) %>%
  column_spec(1, width = "5cm") %>%
  add_header_above(c(" " = 1, "Afhængig: Stemmeandel til borgmesterparti i %" = 8))


msummary(tbl_borgmester_interaktion_modeller,
         output = "gt", stars = TRUE,
         coef_map = c(
           "tilslutning_aar_valg" = "Vindmølle tilsluttet",
           "blue_blok" = "Blå blok",
           "PartiVenstre" = "Venstre",
           "tilslutning_aar_valg:blue_blok" = "Vindmølle tilsluttet x Blå blok",
           "tilslutning_aar_valg:PartiVenstre" = "Vindmølle tilsluttet x Venstre",
           "tilslutning_aar_valg:PartiSocialdemokratiet" = "Vindmølle tilsluttet x Socialdemokratiet"
         ), gof_map = tbl_borgmester_interaktion_modeller_gof_map)  %>%
  tab_spanner(label = "Afhængig: Stemmeandel til borgmesterparti i %", columns = -1) %>%
  cols_align_decimal() %>%
  tab_style(style = cell_borders(sides = c("bottom"), weight = px(0.5)), locations = cells_body(rows = c(10))) %>%
  fmt_number(columns = everything(), locale = "da") %>%
  fmt_auto(locale = "da")
