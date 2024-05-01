# source("data/00-pakker.r")

## Sikrer at alt nødvendigt forarbejde er gjort
expect_true(exists("analyse_data"))

## Indlæser ols fil
source("data/21-ols.r")

## Indlæser FE fil
source("data/22-fixedeffects.r")

## Indlæser test fil
source("data/88-leg-med-regres.r")
