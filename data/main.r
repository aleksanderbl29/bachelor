library(tidyverse)

# options(scipen = 999)
antal_obs_samlet <- as.numeric(4269)
sign_stjerner <- c("*" = .1, "**" = .05, "***" = .01)

##########################################
############# Forbered miljø #############
##########################################

source("data/00-pakker.r")

## Konfiguration af kørsel
# Skabelse af dataset fra DAWA api-kald
api_call_enable <- FALSE

##########################################
############ Initialiser data ############
##########################################

source("data/10-data.r")

##########################################
############## Udforsk data ##############
##########################################


##########################################
############# Analyser data ##############
##########################################

source("data/20-analyse.r")

##########################################
#### Tjek at alt er klar til dokument ####
##########################################

source("data/99-objekt-tjek.r")
