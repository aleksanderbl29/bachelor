library(tidyverse)
library(logger)
library(testthat)

analyse_data <- read_rds("data/rep_data/15_analyse_data.rds")
write_rds(analyse_data, "data/rep_data/rep_analyse_data.rds")
