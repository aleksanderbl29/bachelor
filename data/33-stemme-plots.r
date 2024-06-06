library(tidyverse)
library(logger)
library(patchwork)
library(ggthemes)
library(RColorBrewer)
library(cowplot)
library(sf)
library(rmapshaper)
library(cowplot)

## Indlæser objekter der skal bruges
if (exists("valg_farver") & exists("partier_farver")) {
  log_info("Farver er tidligere indlæst")
} else {
  log_info("Indlæser farver....")
  source("data/39-farver.r")
  log_info("Farver indlæst korrekt")
}

log_info("Skaber stemme-plots")
# First we load the tidyverse
## Indsætter default værdi. Henter ikke kommuner fra API. Kan overskrives i miljøet
if (!exists("hent_geodata_kommuner_fra_api")) {
  log_info("Kommuner skal hentes fra disk")
  hent_geodata_kommuner_fra_api <- FALSE
}

if (hent_geodata_kommuner_fra_api == TRUE) {
  ## Forhøjer timeout
  log_info(paste("Timeout er på", getOption("timeout")))
  log_info("Ændrer timeout til 600")
  options(timeout = 600)

  ## Gemmer URL til API-kald
  url <- "https://api.dataforsyningen.dk/kommuner?format=geojson"

  # Henter geojson til tempfile
  geofile_kommuner <- tempfile()

  log_info("Starter download af geoJSON")
  starttid <- Sys.time()
  download.file(url, geofile_kommuner)
  sluttid <- Sys.time()
  log_info("GeoJSON downloadet")

  download_tid <- sluttid - starttid
  log_info(paste("Det tog", download_tid, "minutter at downloade"))

  # Læser datafilen ind i R
  geodata_kommuner <- st_read(geofile_kommuner)

  kommuner_geodata <- st_as_sf(geodata_kommuner)

  ## Gemmer kommuner_geodata til disk
  write_rds(kommuner_geodata, "data/rep_data/33_kommuner_geodata.rds")

  ## Nulstiller timeout
  log_info(paste0("Timeout er ", getOption("timeout")))
  options(timeout = 60)
  log_info(paste("Timeout er nulstillet og er nu", getOption("timeout")))

  rm(url, geodata_kommuner)
}

rm(hent_geodata_kommuner_fra_api)


## Indlæser kommuner_geodata
log_info("Henter kommuner fra disk...")
kommuner_geodata <- read_rds("data/rep_data/33_kommuner_geodata.rds")
log_info("Success")

## Indlæser borgmester fra disk
log_info("Henter borgmester data fra disk...")
analyse_data <- read_rds("data/rep_data/rep_analyse_data.rds")
log_info("Success")

laveste_dato <- as_date("2005-11-15")

## Indlæser vindmøller fra disk
log_info("Henter vindmøller placering fra disk...")
vind_stemmesteder <- read_rds("data/rep_data/31_vind_stemmesteder.rds") %>%
  filter(tilslutningsdato > laveste_dato) %>%
  mutate(kommune = substr(valgsted_id, 1, 3)) %>%
  filter(kommune != 400) %>% arrange(tilslutningsdato)
log_info("Success")

f_rollout_vind_stemmesteder <- read_rds("data/rep_data/31_rollout_stemmesteder.rds")

vind_stemmesteder <- vind_stemmesteder[match(unique(vind_stemmesteder$afssted), vind_stemmesteder$afssted),]

kommuner_geodata <- ms_simplify(kommuner_geodata, keep = 0.01, keep_shapes = TRUE)

join_kommuner_geodata <- kommuner_geodata %>%
  right_join(analyse_data, by = c("navn" = "kommunenavn"))

map_1_33 <- kommuner_geodata %>%
  ggplot() +
  geom_sf() +
  theme_map() +
  theme(legend.position = "none")

map_2_33 <- join_kommuner_geodata %>%
  filter(valgaar == 2009) %>%
  ggplot(aes(fill = Parti), color = "grey40") +
  geom_sf() +
  theme_map() +
  theme(legend.position = "right")

valg_parti_kort <- ggplot() +
  geom_sf(data = join_kommuner_geodata, color = "grey", aes(fill = Parti)) +
  geom_sf(data = vind_stemmesteder, size = 0.5, color = "black") +
  theme_map() +
  scale_fill_manual(values = partier_farver) +
  theme(legend.position = "left") +
  labs(fill = "") +
  facet_wrap(vars(valgaar))
valg_parti_kort

f2_rollout_vind_stemmesteder <- f_rollout_vind_stemmesteder[match(unique(f_rollout_vind_stemmesteder$afssted), f_rollout_vind_stemmesteder$afssted),]

parti_aar_valgsted_kort <- ggplot() +
  geom_sf(data = kommuner_geodata, fill = "#f9f9f9") +
  geom_sf(data = f2_rollout_vind_stemmesteder, aes(fill = Parti)) +
  theme_map() +
  scale_fill_manual(values = partier_farver) +
  labs(fill = "") +
  theme(legend.position = "bottom") +
  guides(fill = guide_legend(nrow = 2, byrow = TRUE)) +
  facet_wrap(~valgaar)
parti_aar_valgsted_kort
