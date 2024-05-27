library(tidyverse)
## Set defualt pakke repo
options(repos = c(CRAN = "https://cloud.r-project.org"))

## Her er liste over alle de pakker der skal bruges for at reproducere dette arbejde
pakkeliste_pakker <- c(
  "tidyverse",
  "ggthemes",
  "httr",
  "jsonlite",
  "readxl",
  "testthat",
  "here",
  "modelsummary",
  "fixest",
  "gt",
  "kableExtra",
  "knitr",
  "rmarkdown",
  "sf",
  "haven",
  "naniar",
  "logger",
  "DIDmultiplegtDYN",
  "did"
)

## Finder de brugte versioner
pakkeliste_versioner <- c(
  "2.0.0",
  "1.4.7",
  "1.8.8",
  "1.4.3",
  "3.2.1.1",
  "1.0.1",
  "2.0.0",
  "0.12.0",
  "0.10.1",
  "1.4.0",
  "1.46",
  "2.26",
  "1.0-16",
  "2.5.4",
  "1.1.0",
  "0.3.0",
  "1.0.10",
  "2.1.2"
)

install.packages(pakkeliste_pakker)

## Dropper midlertidig variabel
rm(list = ls())
