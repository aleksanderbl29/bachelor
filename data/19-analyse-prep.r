library(tidyverse)
library(logger)
library(testthat)

## Gemmer analyse data
analyse_data <- read_rds("data/rep_data/16_analyse_data.rds")
write_rds(analyse_data, "data/rep_data/rep_analyse_data.rds")

## Rydder miljøet
rm(list = ls())
