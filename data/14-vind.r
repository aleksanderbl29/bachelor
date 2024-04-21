library(tidyverse)

source("data/00-pakker.r")

## Indlæser alle data
source("data/12-load-data.r")

## Formater data fra DST
source("data/13-dst.r")

## Sikrer at de nødvendige dataframes findes
expect_true(exists("vind_stemmesteder"))
expect_true(exists("valg"))

vind_stemmesteder
