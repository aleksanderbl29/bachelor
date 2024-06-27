library(tidyverse)
library(testthat)
library(logger)
 
# ## Rydder miljøet inden kørsel
if (!exists("quarto")) {
  quarto <- FALSE
}

if (isFALSE(quarto)) {
  rm(list = ls())
}

if (!exists("installer_pakker")) {
  installer_pakker <- FALSE
}

if (installer_pakker == TRUE) {
  source("data/00-pakker.r")
}
rm(installer_pakker)

if (exists("analyse_data")) {
  log_info("Data allerede indlæst")
} else {
  analyse_data <- read_rds("data/rep_data/rep_analyse_data.rds")
}

if (!exists("sign_stjerner")) {
  sign_stjerner <- c("+" = .1, "*" = .05, "**" = .01, "***" = .001)
  log_info(paste("Signifikansniveau sættes med stjerner til:", "* = .1, ** = .05, *** = .01"))
}

antal_obs_samlet <- nrow(analyse_data)

## Sikrer at alt nødvendigt forarbejde er gjort
expect_true(exists("analyse_data"))
expect_true(exists("sign_stjerner"))

## Deklarerer custom nummer formaterings funktion
log_info("Deklarerer custom nummer formaterings funktion")
nm_fm <- function(x) {
  format(round(x, 2), big.mark = ".", decimal.mark = ",", scientific = FALSE)
}


if (!exists("analyse_separate_filer")) {
  analyse_separate_filer <- FALSE
}

if (analyse_separate_filer == FALSE) {
  
  ## Indlæser ols fil
  source("data/21-ols.r")
  
  ## Indlæser FE fil
  source("data/22-fixedeffects.r")
  
}


## Indlæser test fil
# source("data/88-leg-med-regres.r")

# ## Rydder miljøet efter kørsel
# rm(list = ls())

# Find unikke kombinationer
unique_combinations <- analyse_data %>%
  distinct(kommunenr, Parti, .keep_all = TRUE) %>% 
  group_by(kommunenr) %>% 
  filter(n() > 1) %>% 
  ungroup() %>% 
  # filter(!is.na(tilslutning_treat)) %>% 
  filter(tilslutning_treat == 1 | tilslutning_treat == 2) %>% 
  select(valgsted_id, valg, kommunenavn, Parti, blue_blok, borgmester_stemmer_pct) %>% 
  arrange(kommunenavn) %>% 
  group_by(kommunenavn) %>% 
  filter(n() > 1) %>% 
  ungroup()

# Print resultatet
print(unique_combinations)











