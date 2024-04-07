library(httr)
library(tidyverse)
library(jsonlite)

## Definer URL der skal bruges
url_DAWA <- "https://api.dataforsyningen.dk/afstemningsomraader"

## Sammensæt passende reverse lookup
x_koord <- "888039.1715"
y_koord <- "6126756.211"
url_DAWA_1 <- paste0(url_DAWA, "/reverse", "?", "x=", x_koord, "&y=", y_koord, "&srid=25832")

# https://api.dataforsyningen.dk/afstemningsomraader/reverse?x=&y=


## Udfør GET request på URL
response <- content(GET(url_DAWA_1))

response$afstemningssted$navn
response$nummer
response$kommune$kode
