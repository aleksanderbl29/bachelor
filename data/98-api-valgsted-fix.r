library(tidyverse)
library(testthat)
library(httr)
library(jsonlite)

## Sikrer at treatment uden plads findes som df
expect_true(exists("homeless_treatment"))
## Og at df indeholder rækker
expect_false(nrow(homeless_treatment) == 0)

## Træk kommune id ud af valgsted id og separerer stednavn
homeless_treatment <- homeless_treatment %>% 
  select(everything()) %>% 
  mutate(kommunekode = substr(valgsted_id, 1, 3))

homeless_treatment <- homeless_treatment %>% 
  filter(valgsted_id != 482011)

homeless_treatment <- separate(homeless_treatment, afssted, "stednavn", ",")

## Definer URL til DAWA der skal bruges
url_DAWA <- "https://api.dataforsyningen.dk/afstemningsomraader"

## UNIT TEST
#### Hvis testen ikke giver nogle fejl returnerer API'en de forventede data
## Sammensæt passende reverse lookup
test_x_koord <- "888039.1715"
test_y_koord <- "6126756.211"
test_url_DAWA <- paste0(url_DAWA, "/reverse", "?", "x=", test_x_koord, "&y=", test_y_koord, "&srid=25832")
# https://api.dataforsyningen.dk/afstemningsomraader/reverse?x=&y=
## Udfør GET request på URL og print til vector til test
test_response <- content(GET(test_url_DAWA))
test_value <- c(test_response$afstemningssted$navn, test_response$nummer, test_response$kommune$kode)
test_expect <- c("Østermarie Hallen", "2", "0400")
expect_identical(test_value, test_expect)

stednavn <- homeless_treatment[1, ]$stednavn
kmkode <- homeless_treatment[1, ]$kommunekode

url <- paste0(url_DAWA, "/autocomplete", "?", "navn=", stednavn, "&", "kommunekode=", kmkode)
url <- paste0(url_DAWA, "/autocomplete", "?", "q=", stednavn)
response <- content(GET(url = url))


###############

### API der kalder med kommune nummer og navn og finder en adresse eller andet. Matcher navn fra DST med valgsted id hos DAWA
fejl_api_vind_steder <- nrow(homeless_treatment)

starttid <- Sys.time()

for (i in 1:nrow(homeless_treatment)) {
  afssted <- homeless_treatment[i, ]$afssted
  kmkode <- homeless_treatment[i, ]$kommunekode
  
  url <- paste0(url_DAWA, "/autocomplete", "?", "navn=", afssted, "&", "kommunekode=", kmkode)
  response <- content(GET(url = url))
  
  print()
  
  afssted = response$afstemningssted$navn
  afssted_nr = as.numeric(response$nummer)
  kommunekode = as.numeric(response$kommune$kode)
  vind_steder <- add_row(vind_steder,
                         x_koord = koord_x,
                         y_koord = koord_y,
                         afssted = afssted,
                         afssted_nr = afssted_nr,
                         kommunekode = kommunekode,
                         mll_num = møllenummer,
                         tilslutningsdato = tilslutningsdato)
  print(paste(i, "af", antal_obs, "er:",response$afstemningssted$navn))
  rm(koord_x, koord_y, url, response)
}

sluttid <- Sys.time()
