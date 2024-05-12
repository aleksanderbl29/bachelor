## Forsøger at indlæse data, hvis den findes i mappen
## ellers skaber den data fra ny

# Skal der skabes ny DF med api-data?
# sikrer at dummy_var findes
# expect_true(exists("api_call_enable"))

api_call_enable <- FALSE

if (api_call_enable == TRUE) {

  ## Skabelse af dataset
  source("data/11-skab-df.r")

} else {

  ## Indlæsning af dataset
  source("data/12-load-data.r")

}

## Formater data fra DST
source("data/13-dst.r")

## Omform vindmølleplacering til treatment-dataframe
source("data/14-vind-treatment.r")

## Inkluder borgmestre og borgmesterparti
source("data/15-borgmestre.r")

## Forbereder data til dynamisk DID
source("data/16-did-prep.r")

## Give labels til variablene i analyse_data
source("data/17-var-labels.r")

## Rydder op i data og gør df brugbare
source("data/18-data-cleanup.r")

## Gemmer data i produktionsfiler
source("data/19-analyse-prep.r")

## Dropper midlertidige variable
rm(api_call_enable)
