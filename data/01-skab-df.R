library(httr)
library(tidyverse)
library(jsonlite)
library(readxl)

## Definer URL der skal bruges
url_DAWA <- "https://api.dataforsyningen.dk/afstemningsomraader"

## Sammensæt passende reverse lookup
test_x_koord <- "888039.1715"
test_y_koord <- "6126756.211"
test_url_DAWA <- paste0(url_DAWA, "/reverse", "?", "x=", x_koord, "&y=", y_koord, "&srid=25832")

# https://api.dataforsyningen.dk/afstemningsomraader/reverse?x=&y=


## Udfør GET request på URL
test_response <- content(GET(test_url_DAWA))

test_response$afstemningssted$navn
test_response$nummer
test_response$kommune$kode

## Refactor til loop og med data fra DF

csv_vind <- read_csv("data/downloads/vind.csv")
colnames(csv_vind)
head(csv_vind$"X (øst) koordinat \r\nUTM 32 Euref89")

#### Indlæs excel fil med vindmølledata og omdøber kolonnenavne med det samme
vind <- read_xlsx("data/downloads/vind.xlsx") %>%
  select(everything()) %>%
  rename(x_koord = "X (øst) koordinat \r\nUTM 32 Euref89",
         y_koord = "Y (nord) koordinat \r\nUTM 32 Euref89")

colnames(vind)

## Fjerner rækker med missing values i x og y koordinater
vind <- vind %>%
  drop_na(x_koord, y_koord)

vind[1, ]$x_koord

nrow(vind)
colnames(vind)

for (i in 1:nrow(vind)) {
  x_koord <- vind[i, ]$x_koord
  y_koord <- vind[i, ]$y_koord
}
