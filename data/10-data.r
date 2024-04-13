## Forsøger at indlæse data, hvis den findes i mappen
## ellers skaber den data fra ny

# Skal der skabes ny DF med api-data?
# sikrer at dummy_var findes
expect_true(exists("api_call_enable"))

if (api_call_enable == TRUE) {
  
  ## Skabelse af dataset
  source("data/01-skab-df.R")
  
} else {
  
  ## Indlæsning af dataset
  source("data/02-load-data.R")
  
}

## Formater data fra DST
source("data/13-dst.r")

## Dropper midlertidige variable
rm(api_call_enable)
