library(httr)
library(tidyverse)
library(jsonlite)
library(readxl)
library(testthat)

## Definer URL der skal bruges
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


## Fjern ting fra test
rm(test_response, test_url_DAWA, test_x_koord, test_y_koord)

#### Indlæs excel fil med vindmølledata og omdøber kolonnenavne med det samme
vind <- read_xlsx("data/downloads/vind.xlsx") %>%
  select(everything()) %>%
  rename(x_koord = "X (øst) koordinat \r\nUTM 32 Euref89",
         y_koord = "Y (nord) koordinat \r\nUTM 32 Euref89",
         tilslutningsdato = "Dato for oprindelig nettilslutning")

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
vind_steder <- tibble(mll_num = 0,
                      x_koord = 0,
                      y_koord = 0,
                      afssted = "sample data",
                      afssted_nr = 0,
                      kommunekode = 0,
                      tilslutningsdato = as_date(0))
vind_steder
colnames(vind_steder)

antal_obs <- nrow(vind)

starttid <- Sys.time()

for (i in 1:nrow(vind)) {
  koord_x <- vind[i, ]$x_koord
  koord_y <- vind[i, ]$y_koord
  møllenummer <- as.numeric(vind[i, ]$`Møllenummer (GSRN)`)
  tilslutningsdato <- vind[i, ]$tilslutningsdato
  
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
          kommunekode = kommunekode,
          mll_num = møllenummer,
          tilslutningsdato = tilslutningsdato)
  print(paste(i, "af", antal_obs, "er:",response$afstemningssted$navn))
  rm(koord_x, koord_y, url, response)
}

sluttid <- Sys.time()

## Fjerner første tomme kolonne
vind_steder <- vind_steder %>% 
  select(everything()) %>% 
  filter(!afssted == "sample data")

loop_tid <- sluttid - starttid
print(loop_tid)
print(paste("Det tog", round(loop_tid, 2), "minutter at hente data"))


vind_steder <- vind_steder %>% 
  mutate(valgsted_id = if_else(nchar(afssted_nr) == 1, sprintf("%003d", afssted_nr),
                               if_else(nchar(afssted_nr) == 2, sprintf("%03d", afssted_nr),
                                       if_else(nchar(afssted_nr) == 3, sprintf("%3d", afssted_nr), NA)))) %>% 
  mutate(valgsted_id = paste0(kommunekode, valgsted_id)) %>% 
  select(!c("kommunekode", "afssted_nr"))

head(vind_steder)
write_excel_csv(vind_steder, "data/downloads/mine_data/vind_steder.csv")

## Fjern objekter der ikke skal bruges videre
rm(loop_tid, sluttid, starttid, vind, vind_steder,
   afssted, afssted_nr, møllenummer, test_expect,
   test_value, url_DAWA, i, antal_obs, kommunekode)

