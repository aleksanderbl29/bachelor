source_pakker <- TRUE


if (exists("source_pakker")) {
  if (source_pakker == TRUE) {
    source("data/00-pakker.r")
  } else {
    print("Pakker indlæses ikke")
  }} else {
  print("Alle pakker er indlæst")
  }

if (exists("analyse_data")) {
  print("Data allerede indlæst")
} else {
  analyse_data <- read_csv("data/downloads/mine_data/replikation.csv")
}

sign_stjerner <- c("*" = .1, "**" = .05, "***" = .01)

antal_obs_samlet <- nrow(analyse_data)

## Sikrer at alt nødvendigt forarbejde er gjort
expect_true(exists("analyse_data"))
expect_true(exists("sign_stjerner"))

## Indlæser ols fil
source("data/21-ols.r")

## Indlæser FE fil
source("data/22-fixedeffects.r")

## Indlæser test fil
source("data/88-leg-med-regres.r")
