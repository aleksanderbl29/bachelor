library(tidyverse)
library(testthat)
library(logger)
library(labelled)

analyse_data <- read_rds("data/rep_data/16_analyse_data.rds")

expect_true(exists("analyse_data"))

####################################
log_info("Giver labels til variable")
analyse_data <- analyse_data %>% 
  set_variable_labels(
    valgsted_id = "Valgsted",
    valg = "Kommunalvalg",
    stemmer = "Gyldige stemmer",
    kv09 = "Vindmølle opsat inden kommunalvalget 2009",
    kv13 = "Vindmølle opsat inden kommunalvalget 2013",
    kv17 = "Vindmølle opsat inden kommunalvalget 2017",
    kv21 = "Vindmølle opsat inden kommunalvalget 2021",
    ny_tilsluttet = "Vindmølle tilsluttet op til valg",
    kommune_valg_id = "ID for kommune og valg",
    kommunenavn = "Kommune",
    Parti = "Partinavn",
    valg_id = "Valg",
    value = "Borgmesterparti findes",
    valgaar = "Årstal",
    kommunenr = "Kommunens ID",
    borgmester_stemmer = "Stemmer på borgmesterens parti",
    borgmester_stemmer_pct = "Borgmesterens andel af samlede stemmer",
    tilslutning_aar_valg = "Vindmølle tilsluttet",
    tilslutning_aar = "Vindmølle tilsluttet",
    tilslutning_treat = "Treatmentindikator for vindmøller",
    tilslutning_bin = "Dikotom indikator for vindmølle ved valg"
  )

log_info("Giver partier navne")
analyse_data <- analyse_data %>% 
  set_variable_labels(
    A = "Socialdemokratiet",
    B = "Radikale Venstre",
    C = "Det Konservative Folkeparti",
    D = "Nye Borgerlige",
    F = "Socialistisk Folkeparti",
    I = "Liberal Alliance",
    O = "Dansk Folkeparti",
    L = "Lokalliste",
    V = "Venstre",
    Ø = "Enhedslisten",
    Å = "Alternativet",
    Æ = "Frihedslisten",
    diverse_parti = "Andre partier",
    red = "Rød blok",
    blue = "Blå blok",
    red_pct = "Rød blok procentandel",
    blue_pct = "Blå blok procentandel",
    blok = "Blok",
    blue_blok = "Blå blok"
  )
  


####################################
log_info("Gemmer dataset til disk")
write_rds(analyse_data, "data/rep_data/17_analyse_data.rds")

## Rydder miljøet
rm(list = ls())
