## Set defualt pakke repo
options(repos = c(CRAN = "https://cloud.r-project.org"))

## Her er liste over alle de pakker der skal bruges for at reproducere dette arbejde
pakkeliste <- c(
  "tidyverse",
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
  "rmarkdown"
)

## Derudover er der brugt enkelte funktioner fra disse pakker
enkelt_pakker <- c(
  "haven",
  "naniar"
)

## Installerer disse pakker men indlæser ikke
install.packages(enkelt_pakker, dependencies = TRUE, quiet = TRUE)

## Tjekker om alle pakker fra liste er i de installerede pakker
mangler_pakker <- pakkeliste[!(pakkeliste %in% installed.packages()[,"Package"])]

## Installerer pakker hvis de mangler
if (length(mangler_pakker) > 0) {
  install.packages(mangler_pakker, dependencies = TRUE)
}

## Indlæser alle pakker
for (pakke.i in pakkeliste) {
  suppressPackageStartupMessages(
    library(
      pakke.i,
      character.only = TRUE
      )
  )
}


## Dropper midlertidig variabel
rm(pakkeliste, mangler_pakker, pakke.i, enkelt_pakker)
