library(tidyverse)
library(logger)

log_info("Skaber farvepalette til valg")
valg_farver <- c("KV2009" = "#E69F00", 
                 "KV2013" = "#56B4E9",
                 "KV2017" = "#009E73",
                 "KV2021" = "#F0E442")

log_info("Skaber farvepalette til partier")
partier_farver <- c("Socialdemokratiet" = "#f04d46",
                    "Venstre" = "#00639E",
                    "Det Konservative Folkeparti" = "#00583C",
                    "Lokalliste" = "grey40",
                    "Radikale Venstre" = "#EC008C",
                    "Socialistisk Folkeparti" = "#C4151C",
                    "Alternativet" = "#00FF00",
                    "Dansk Folkeparti" = "#0F3459")

