## Forsøger at indlæse data, hvis den findes i mappen
## ellers skaber den data fra ny

# Skal der skabes ny DF med api-data?
# sikrer at dummy_var findes
# expect_true(exists("api_call_enable"))

if (exists("api_call_enable")) {
  if (api_call_enable == TRUE) {

  ## Skabelse af dataset
  source("data/11-skab-df.r")

} else {

  ## Indlæsning af dataset
  source("data/12-load-data.r")

}}

## Formater data fra DST
source("data/13-dst.r")

## Omform vindmølleplacering til treatment-dataframe
source("data/14-vind-treatment.r")

## Rydder op i data og gør df brugbare
source("data/15-data-cleanup.r")

## Give labels til variablene i analyse_data
source("data/16-var-labels.r")

## Dropper midlertidige variable
rm(api_call_enable)
