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
  "naniar"
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
  "1.1.0"
)

install.packages(pakkeliste_pakker)

# 
# pakkeliste <- tibble(pakkeliste_pakker, pakkeliste_versioner) |> rename(pakke = pakkeliste_pakker,
#                                                                          version = pakkeliste_versioner)
# 
# for (i in nrow(pakkeliste)) {
#   package <- pakkeliste$pakke[i]
#   version <- pakkeliste$version[i]
#   if (!(package %in% installed.packages())) {
#     install.packages(package, repos = paste0("https://cran.r-project.org/src/contrib/Archive/", package, "/"), version = version)
#   }
# }

## Dropper midlertidig variabel
rm(i, package, pakkeliste_c, version, installerede_pakker, pakkeliste)
