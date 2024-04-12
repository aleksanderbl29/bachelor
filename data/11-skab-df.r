library(httr)
library(tidyverse)
library(jsonlite)
library(readxl)

## Definer URL der skal bruges
url_DAWA <- "https://api.dataforsyningen.dk/afstemningsomraader"

## Sammensæt passende reverse lookup
test_x_koord <- "888039.1715"
test_y_koord <- "6126756.211"
test_url_DAWA <- paste0(url_DAWA, "/reverse", "?", "x=", test_x_koord, "&y=", test_y_koord, "&srid=25832")

# https://api.dataforsyningen.dk/afstemningsomraader/reverse?x=&y=


## Udfør GET request på URL
test_response <- content(GET(test_url_DAWA))

test_response$afstemningssted$navn
test_response$nummer
test_response$kommune$kode

## Fjern ting fra test
rm(test_response, test_url_DAWA, test_x_koord, test_y_koord)

#### Indlæs excel fil med vindmølledata og omdøber kolonnenavne med det samme
vind <- read_xlsx("data/downloads/vind.xlsx") %>%
  select(everything()) %>%
  rename(x_koord = "X (øst) koordinat \r\nUTM 32 Euref89",
         y_koord = "Y (nord) koordinat \r\nUTM 32 Euref89")

colnames(vind)

## Fjerner rækker med missing values i x og y koordinater
nrow(vind)
vind <- vind %>%
  drop_na(x_koord, y_koord)

vind[1, ]$x_koord
vind[1, ]$y_koord

vind[nrow(vind), ]$x_koord
vind[nrow(vind), ]$y_koord

nrow(vind)
colnames(vind)

## Variable der skal hentes fra loopet
vind_steder <- tibble(x_koord = 0,
                      y_koord = 0,
                      afssted = "navn",
                      afssted_nr = 0,
                      kommunekode = 0)
vind_steder
colnames(vind_steder)

antal_obs <- nrow(vind)

starttid <- Sys.time()

for (i in 1:nrow(vind)) {
  koord_x <- vind[i, ]$x_koord
  koord_y <- vind[i, ]$y_koord
  url <- paste0(url_DAWA, "/reverse", "?", "x=", koord_x, "&y=", koord_y, "&srid=25832")
  response <- content(GET(url = url))
  afssted = response$afstemningssted$navn
  afssted_nr = as.numeric(response$nummer)
  kommunekode = as.numeric(response$kommune$kode)
  vind_steder <- add_row(vind_steder,
          x_koord = koord_x,
          y_koord = koord_y,
          afssted = afssted,
          afssted_nr = afssted_nr,
          kommunekode = kommunekode)
  print(paste(i, "af", antal_obs, "er:",response$afstemningssted$navn))
  rm(koord_x, koord_y, url, response)
}

sluttid <- Sys.time()

loop_tid <- sluttid - starttid
print(loop_tid)
print(paste("Det tog", round(loop_tid, 2), "minutter at hente data"))

head(vind_steder)

