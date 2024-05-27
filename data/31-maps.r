library(tidyverse)
library(logger)
library(patchwork)
library(ggthemes)
library(RColorBrewer)
library(cowplot)
library(wesanderson)
library(Manu)
library(sf)
library(rmapshaper)
library(Hmisc)

## Indlæser objekter der skal bruges
if (exists("valg_farver")) {
  log_info("Farver er tidligere indlæst")
} else {
  log_info("Indlæser farver....")
  source("data/39-farver.r")
  log_info("Farver indlæst korrekt")
}

## Kode bygget ovenpå https://www.linkedin.com/pulse/easy-maps-denmark-r-mikkel-freltoft-krogsholm/
# Here I define the url to get data from DAWA/DAGI for landsdele. I define that the format should be geojson
# url = "https://api.dataforsyningen.dk/landsdele?format=geojson"

## Henter stemmesteder der har vindmøller
vind_stemmesteder <- read_csv("data/downloads/mine_data/vind_steder.csv") %>%
  st_as_sf(coords = c("x_koord", "y_koord"), crs = 25832)

## Indsætter default værdi. Henter ikke afstemningssteder fra API. Kan overskrives i miljøet
if (!exists("hent_geodata_afstemningssteder_fra_api")) {
  log_info("Afstemningssteder skal hentes fra disk")
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
log_info("Henter afstemningssteder fra disk...")
vind_afstemningssteder_geodata <- read_rds("data/rep_data/31_vind_afstemningssteder_geodata.rds")
log_info("Success")

sf_use_s2(FALSE)

vind_afstemningssteder_geodata <- ms_simplify(vind_afstemningssteder_geodata, keep = 0.01, keep_shapes = TRUE)

## Sikrer der bruges samme CRS mellem de to dataset
vind_stemmesteder <- vind_stemmesteder %>%
  st_transform(st_crs(vind_afstemningssteder_geodata))

write_rds(vind_stemmesteder, "data/rep_data/31_vind_stemmesteder.rds")

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
  geom_sf(data = vind_stemmesteder, aes(color = as.factor(year(tilslutningsdato)))) +
  theme_map() +
  theme(legend.position = "right")
afstemningssteder

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
  filter(year > 2007) %>% 
  arrange(tilslutningsdato)

borgmestre <- read_rds("data/rep_data/15_borgmestre.rds") %>%
  mutate(kommunenavn = case_when(kommunenavn == "Halsnæs" ~ "Frederiksværk-Hundested",
                                 kommunenavn == "Lyngby-Taarbæk" ~ "Lyngby-Tårbæk",
                                 kommunenavn == "Vesthimmerland" ~ "Vesthimmerlands",
                                 kommunenavn == "Bornholms Region" ~ "Bornholm",
                                 .default = kommunenavn))

f_rollout_vind_stemmesteder <- f_rollout_vind_stemmesteder %>%
  mutate(valgaar = as.double(valgaar)) %>% 
  left_join(borgmestre, by = c("kommunenavn" = "kommunenavn", "valgaar" = "valgaar"), relationship = "many-to-many")


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
  geom_sf(
    data = vind_afstemningssteder_geodata,
    fill = "white",
    color = "lightgrey",
    linewidth = 0.1
  ) +
  geom_sf(data = f_rollout_vind_stemmesteder,
          mapping = aes(fill = valg),
          linewidth = 0.00001) +
  ggthemes::theme_map() +
  theme(legend.position = "right")

ggplot() +
  geom_sf(
    data = vind_afstemningssteder_geodata,
    fill = "white",
    color = "lightgrey",
    linewidth = 0.1
  ) +
  geom_sf(data = f_rollout_vind_stemmesteder,
          mapping = aes(fill = valg),
          linewidth = 0.00001) +
  cowplot::theme_map() +
  theme(legend.position = "right")

bornholm_vind_afstemningssteder_geodata <- vind_afstemningssteder_geodata %>%
  filter(kommunenavn %in% c("Bornholm", "Christiansø"))

vind_afstemningssteder_geodata_u_bhlm <- vind_afstemningssteder_geodata %>%
  filter(kommunenavn %nin% c("Bornholm", "Christiansø"))

if (!exists("find_granser")) {
  find_granser <- FALSE
}

if (find_granser == TRUE) {
  log_info("Sammenlægger grænser og skaber omrids")
  dk_granser <- vind_afstemningssteder_geodata %>%
    filter(kommunenavn %nin% c("Bornholm", "Christiansø")) %>%
    st_union()

  write_rds(dk_granser, "data/rep_data/31_dk_granser.rds")
  log_info("Grænser er fundet og gemt")
} else {
  log_info("Indlæser gemte grænsedata")
  dk_granser <- read_rds("data/rep_data/31_dk_granser.rds")
}


bornholm_rollout <- f_rollout_vind_stemmesteder %>%
  filter(kommunenavn %in% c("Bornholm", "Christiansø"))

rollout_u_bhlm <- f_rollout_vind_stemmesteder %>%
  filter(kommunenavn %nin% c("Bornholm", "Christiansø"))


dk_map_1 <- ggplot() +
  geom_sf(data = dk_granser, color = "black") +
  geom_sf(
    data = vind_afstemningssteder_geodata_u_bhlm,
    fill = "white",
    color = "lightgrey",
    linewidth = 0.1
  ) +
  geom_sf(
    data = rollout_u_bhlm,
    mapping = aes(fill = valg),
    linewidth = 0.1,
    color = "black"
  ) +
  cowplot::theme_map() +
  theme(legend.position = "right") +
  scale_fill_manual(values = valg_farver) +
  labs(fill = "Valgår")

bhlm_map_1 <- ggplot() +
  geom_sf(
    data = bornholm_vind_afstemningssteder_geodata,
    fill = "white",
    color = "lightgrey",
    linewidth = 0.1
  ) +
  geom_sf(
    data = bornholm_rollout,
    mapping = aes(fill = valg),
    linewidth = 0.1,
    color = "black"
  ) +
  cowplot::theme_map() +
  labs(subtitle = "Bornholm") +
  theme(
    legend.position = "none",
    panel.background = element_rect(color = "black"),
    plot.subtitle = element_text(size = 8),
    text = element_text(family = "Times New Roman")
  ) +
  scale_fill_manual(values = valg_farver)

valgsteder_map_valg <- dk_map_1 + inset_element(
  bhlm_map_1,
  left = 0.85,
  bottom = 0.65,
  right = 1,
  top = 0.9
)

log_info("Gemmer valgsteder_map_valg til rds")
write_rds(valgsteder_map_valg, "data/rep_data/31_valgsteder_map_valg.rds")

valgsteder_map_valg

## Gemmer plot til disk
log_info("Gemmer valgkort til png")
# ggsave("output/billeder/valgsteder-map-1.png", valgsteder_map_valg,
#        dpi = 720, width = 24, height = 12, units = "cm", create.dir = TRUE)

ggsave("output/billeder/valgsteder-map-1.png", valgsteder_map_valg,
       dpi = 720, width = 30, height = 20, units = "cm", create.dir = TRUE)

# ggsave("output/billeder/valgsteder-map-1.png", valgsteder_map_valg,
#        dpi = 720, width = 25, height = 10, units = "cm", create.dir = TRUE)

# ggsave("output/billeder/valgsteder-map-1.png", valgsteder_map_valg,
#        dpi = 720, width = 5.5, height = 3.5, create.dir = TRUE)

# ggsave("output/billeder/valgsteder-map-1.png", valgsteder_map_valg,
#        dpi = 720, width = 12.5, height = 5, create.dir = TRUE)

# ggsave("output/billeder/valgsteder-map-1.png", valgsteder_map_valg, create.dir = TRUE, dpi = 700)

aarhus_afstemningssteder
bw_afstemningssteder
afstemningssteder
treatment_rollout_map

## Gemmer data brugt
write_rds(f_rollout_vind_stemmesteder, "data/rep_data/31_rollout_stemmesteder.rds")

