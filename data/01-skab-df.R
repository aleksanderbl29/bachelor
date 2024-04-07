library(httr)
library(tidyverse)
library(jsonlite)

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
