library(tidyverse)
library(here)

##########################################
############# Forbered miljø #############
##########################################

source("data/00-pakker.r")

## Konfiguration af kørsel
# Skabelse af dataset fra DAWA api-kald
api_call_enable = FALSE

##########################################
############ Initialiser data ############
##########################################

source("data/10-data.r")

##########################################
############## Udforsk data ##############
##########################################

## Test
source("data/plots.r")
