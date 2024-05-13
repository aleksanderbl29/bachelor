library(tidyverse)
library(logger)
library(patchwork)
library(ggthemes)
library(RColorBrewer)
library(cowplot)
library(wesanderson)
library(Manu)
library(sf)
library(Hmisc)

## Indlæser objekter der skal bruges
if (exists("valg_farver")) {
  log_info("Farver er allerede indlæst")
} else {
  log_info("Indlæser farver....")
  source("data/39-farver.r")
  log_info("Farver indlæst korrekt")
}

## Kode bygget ovenpå https://www.linkedin.com/pulse/easy-maps-denmark-r-mikkel-freltoft-krogsholm/
# Here I define the url to get data from DAWA/DAGI for landsdele. I define that the format should be geojson
# url = "https://api.dataforsyningen.dk/landsdele?format=geojson"
url <- "https://api.dataforsyningen.dk/afstemningsomraader?format=geojson"

## Henter stemmesteder der har vindmøller
vind_stemmesteder <- read_csv("data/downloads/mine_data/vind_steder.csv") %>%
  st_as_sf(coords = c("x_koord", "y_koord"), crs = 25832)

## Indsætter default værdi. Henter ikke afstemningssteder fra API. Kan overskrives i miljøet
if (!exists("hent_geodata_afstemningssteder_fra_api")) {
  hent_geodata_afstemningssteder_fra_api <- FALSE
}

if (hent_geodata_afstemningssteder_fra_api == TRUE) {
  ## Forhøjer timeout
  log_info(paste("Timeout er på", getOption("timeout")))
  log_info("Ændrer timeout til 600")
  options(timeout = 600)
  
  ## Gemmer URL til API-kald
  url <- "https://api.dataforsyningen.dk/afstemningsomraader?format=geojson"
  
  # Henter geojson til tempfile
  geofile_afstemningssteder <- tempfile()
  
  log_info("Starter download af geoJSON")
  starttid <- Sys.time()
  download.file(url, geofile_afstemningssteder)
  sluttid <- Sys.time()
  log_info("GeoJSON downloadet")
  
  download_tid <- sluttid - starttid
  log_info(paste("Det tog", download_tid, "minutter at downloade"))
  
  # Læser datafilen ind i R
  geodata_afstemningssteder <- st_read(geofile_afstemningssteder)
  
  vind_afstemningssteder_geodata <- st_as_sf(geodata_afstemningssteder)
  
  ## Gemmer vind_afstemningssteder_geodata til disk
  write_rds(vind_afstemningssteder_geodata, "data/rep_data/31_vind_afstemningssteder_geodata.rds")
  
  ## Nulstiller timeout
  log_info(paste0("Timeout er ", getOption("timeout")))
  options(timeout = 60)
  log_info(paste("Timeout er nulstillet og er nu", getOption("timeout")))
  
  rm(url)
}

rm(hent_geodata_afstemningssteder_fra_api)
  
## Indlæser vind_afstemningssteder_geodata
vind_afstemningssteder_geodata <- read_rds("data/rep_data/31_vind_afstemningssteder_geodata.rds")


## Sikrer der bruges samme CRS mellem de to dataset
vind_stemmesteder <- vind_stemmesteder %>%
  st_transform(st_crs(vind_afstemningssteder_geodata))

aarhus_afstemningssteder <- vind_afstemningssteder_geodata %>%
  filter(kommunenavn == "Aarhus") %>%
  ggplot(aes(fill = navn)) +
  geom_sf() +
  theme_map() +
  theme(legend.position = "none")

bw_afstemningssteder <- ggplot(vind_afstemningssteder_geodata) +
  geom_sf() +
  theme_map() +
  labs(title = "Afstemningssteder i Danmark",
       caption = "Kilde: DAWA/DAGI") +
  theme(legend.position = "none",
        title = element_text(size = 20))

afstemningssteder <- ggplot() +
  geom_sf(data = vind_afstemningssteder_geodata) +
  geom_sf(data = vind_stemmesteder, aes(color = tilslutningsdato)) +
  theme_map() +
  theme(legend.position = "none")

## Indlæser liste over kommunalvalg
kommunalvalg <- read_rds("data/rep_data/13_kommunalvalg.rds")

kommunalvalg_fra_09 <- kommunalvalg %>%
  filter(valg_dato > dmy("01-01-2008"))

vind_stemmesteder <- vind_stemmesteder %>%
  mutate(year = year(tilslutningsdato)) %>%
  filter(year > 2007) %>%
  mutate(valg = case_when(tilslutningsdato < kommunalvalg_fra_09$valg_dato[1] ~ "KV2009",
                          tilslutningsdato >= kommunalvalg_fra_09$valg_dato[1] & tilslutningsdato < kommunalvalg_fra_09$valg_dato[2] ~ "KV2013",
                          tilslutningsdato >= kommunalvalg_fra_09$valg_dato[2] & tilslutningsdato < kommunalvalg_fra_09$valg_dato[3] ~ "KV2017",
                          tilslutningsdato >= kommunalvalg_fra_09$valg_dato[3] & tilslutningsdato < kommunalvalg_fra_09$valg_dato[4] ~ "KV2021")) %>%
  drop_na(valg) %>%
  arrange(year) %>% 
  mutate(valgaar = substr(valg, 3, 6))
  

f_rollout_vind_stemmesteder <- vind_afstemningssteder_geodata %>%
  st_join(vind_stemmesteder,join = st_contains) %>%
  mutate(year = year(tilslutningsdato)) %>%
  filter(year > 2007)


treatment_rollout_map <- ggplot(f_rollout_vind_stemmesteder, aes(fill = valg)) +
  geom_sf() +
  # geom_sf(rollout_vind_stemmesteder, aes(color = year)) +
  # geom_sf(vind_afstemningssteder_geodata, aes(fill = contains_point))
  theme_minimal() +
  theme(legend.position = "right")
treatment_rollout_map

treatment_rollout_map_baggrund <- ggplot() +
  geom_sf(data = vind_afstemningssteder_geodata, alpha=0.1, linewidth = 0.1) +
  geom_sf(data = f_rollout_vind_stemmesteder, mapping = aes(fill = valg), linewidth = 0.1) +
  theme_void() +
  theme(legend.position = "right")
treatment_rollout_map_baggrund


ggplot() +
  geom_sf(data = vind_afstemningssteder_geodata, fill = "white", color = "lightgrey", linewidth = 0.1) +
  geom_sf(data = f_rollout_vind_stemmesteder, mapping = aes(fill = valg), linewidth = 0.00001) +
  theme_map() +
  scale_fill_manual(values = wes_palette("Rushmore1")) +
  theme(legend.position = "right")


aarhus_afstemningssteder
bw_afstemningssteder
afstemningssteder + theme_map() + theme(legend.position = "none")
treatment_rollout_map

getOption("timeout")
options(timeout = 60)
