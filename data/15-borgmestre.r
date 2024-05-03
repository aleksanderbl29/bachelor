## Importer ark med borgmestre fra 1970-2018 og omdøber variable og ændrer typer
borgmester_1970_2018 <- read_xlsx("data/downloads/Borgmestre/1970-2018.xlsx", na = "NA") %>% 
  rename(kommune = Kommunenavn,
         fornavn = Fornavn,
         efternavn = Efternavn,
         parti = Parti,
         periode = Periode) %>% 
  mutate(start_periode = as.double(start_periode),
         slut_periode = as.double(slut_periode),
         d_siddende = case_when(siddende == "Nej" ~ 0,
                                siddende == "Ja" ~ 1,
                                .default = NA))
