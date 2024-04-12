## Forsøger at indlæse data, hvis den findes i mappen
## ellers skaber den data fra ny

# Tjekker om "vind" findes i miljøet

vind_findes <- exists("vind")

if (vind_findes && ) {
  print("Vind findes")
} else {
  print("Vind findes IKKE")
}




if (create_df == TRUE) {

  ## Skabelse af dataset
  source("data/01-skab-df.R")

} else {

  ## Indlæsning af dataset
  source("data/02-load-data.R")

}


## Dropper midlertidige variable
# rm(vind_findes)
