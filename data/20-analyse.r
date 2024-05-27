library(tidyverse)
library(testthat)
library(logger)
 
# ## Rydder miljøet inden kørsel
rm(list = ls())

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

## Indlæser ols fil
source("data/21-ols.r")

## Indlæser FE fil
source("data/22-fixedeffects.r")

## Indlæser test fil
# source("data/88-leg-med-regres.r")
