library(tidyverse)
library(here)

## Config for hele projektet
create_df <- FALSE


##########################################
############ Initialiser data ############
##########################################

if (create_df == TRUE) {
  
  ## Skabelse af dataset
  source("data/01-skab-df.R")  
  
} else {
  
  ## Indlæsning af dataset
  source("data/02-load-data.R")
  
}

##########################################
############## Udforsk data ##############
##########################################

## Test
source("data/plots.r")
