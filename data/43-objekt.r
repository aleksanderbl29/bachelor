library(tidyverse)
library(logger)
library(kableExtra)

log_info("Indlæser analyse_data")
analyse_data <- read_rds("data/rep_data/rep_analyse_data.rds")
analyse_data_2009 <- analyse_data %>%
  filter(valgaar == 2009)
analyse_data_2013 <- analyse_data %>%
  filter(valgaar == 2013)
analyse_data_2017 <- analyse_data %>%
  filter(valgaar == 2017)
analyse_data_2021 <- analyse_data %>%
  filter(valgaar == 2021)

total_vind <- analyse_data %>%
  filter(tilslutning_bin == 1) %>%
  nrow

venstre_vind <- analyse_data %>%
  filter(Parti == "Venstre") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

soc_dem_vind <- analyse_data %>%
  filter(Parti == "Socialdemokratiet") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

kons_vind <- analyse_data %>%
  filter(Parti == "Det Konservative Folkeparti") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

radikale_vind <- analyse_data %>%
  filter(Parti == "Radikale Venstre") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

lokalliste_vind <- analyse_data %>%
  filter(Parti == "Lokalliste") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

alternativet_vind <- analyse_data %>%
  filter(Parti == "Alternativet") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

sf_vind <- analyse_data %>%
  filter(Parti == "Socialistisk Folkeparti") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

df_vind <- analyse_data %>%
  filter(Parti == "Dansk Folkeparti") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

venstre_vind_pct <- paste0(format(round((venstre_vind / total_vind) * 100, digits = 1), nsmall = 1, decimal.mark = ","), "%")
soc_dem_vind_pct <- paste0(format(round((soc_dem_vind / total_vind) * 100, digits = 1), nsmall = 1, decimal.mark = ","), "%")
kons_vind_pct <- paste0(format(round((kons_vind / total_vind) * 100, digits = 1), nsmall = 1, decimal.mark = ","), "%")
radikale_vind_pct <- paste0(format(round((radikale_vind / total_vind) * 100, digits = 1), nsmall = 1, decimal.mark = ","), "%")
lokalliste_vind_pct <- paste0(format(round((lokalliste_vind / total_vind) * 100, digits = 1), nsmall = 1, decimal.mark = ","), "%")
alternativet_vind_pct <- paste0(format(round((alternativet_vind / total_vind) * 100, digits = 1), nsmall = 1, decimal.mark = ","), "%")
sf_vind_pct <- paste0(format(round((sf_vind / total_vind) * 100, digits = 1), nsmall = 1, decimal.mark = ","), "%")
df_vind_pct <- paste0(format(round((df_vind / total_vind) * 100, digits = 1), nsmall = 1, decimal.mark = ","), "%")


total_vind_2009 <- analyse_data_2009 %>%
  filter(tilslutning_bin == 1) %>%
  nrow

venstre_vind_2009 <- analyse_data_2009 %>%
  filter(Parti == "Venstre") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

soc_dem_vind_2009 <- analyse_data_2009 %>%
  filter(Parti == "Socialdemokratiet") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

kons_vind_2009 <- analyse_data_2009 %>%
  filter(Parti == "Det Konservative Folkeparti") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

radikale_vind_2009 <- analyse_data_2009 %>%
  filter(Parti == "Radikale Venstre") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

lokalliste_vind_2009 <- analyse_data_2009 %>%
  filter(Parti == "Lokalliste") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

alternativet_vind_2009 <- analyse_data_2009 %>%
  filter(Parti == "Alternativet") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

sf_vind_2009 <- analyse_data_2009 %>%
  filter(Parti == "Socialistisk Folkeparti") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

df_vind_2009 <- analyse_data_2009 %>%
  filter(Parti == "Dansk Folkeparti") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

total_vind_2013 <- analyse_data_2013 %>%
  filter(tilslutning_bin == 1) %>%
  nrow
venstre_vind_2013 <- analyse_data_2013 %>%
  filter(Parti == "Venstre") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
soc_dem_vind_2013 <- analyse_data_2013 %>%
  filter(Parti == "Socialdemokratiet") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
kons_vind_2013 <- analyse_data_2013 %>%
  filter(Parti == "Det Konservative Folkeparti") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
radikale_vind_2013 <- analyse_data_2013 %>%
  filter(Parti == "Radikale Venstre") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
lokalliste_vind_2013 <- analyse_data_2013 %>%
  filter(Parti == "Lokalliste") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
alternativet_vind_2013 <- analyse_data_2013 %>%
  filter(Parti == "Alternativet") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
sf_vind_2013 <- analyse_data_2013 %>%
  filter(Parti == "Socialistisk Folkeparti") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
df_vind_2013 <- analyse_data_2013 %>%
  filter(Parti == "Dansk Folkeparti") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

total_vind_2017 <- analyse_data_2017 %>%
  filter(tilslutning_bin == 1) %>%
  nrow
venstre_vind_2017 <- analyse_data_2017 %>%
  filter(Parti == "Venstre") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
soc_dem_vind_2017 <- analyse_data_2017 %>%
  filter(Parti == "Socialdemokratiet") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
kons_vind_2017 <- analyse_data_2017 %>%
  filter(Parti == "Det Konservative Folkeparti") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
radikale_vind_2017 <- analyse_data_2017 %>%
  filter(Parti == "Radikale Venstre") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
lokalliste_vind_2017 <- analyse_data_2017 %>%
  filter(Parti == "Lokalliste") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
alternativet_vind_2017 <- analyse_data_2017 %>%
  filter(Parti == "Alternativet") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
sf_vind_2017 <- analyse_data_2017 %>%
  filter(Parti == "Socialistisk Folkeparti") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
df_vind_2017 <- analyse_data_2017 %>%
  filter(Parti == "Dansk Folkeparti") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

total_vind_2021 <- analyse_data_2021 %>%
  filter(tilslutning_bin == 1) %>%
  nrow
venstre_vind_2021 <- analyse_data_2021 %>%
  filter(Parti == "Venstre") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
soc_dem_vind_2021 <- analyse_data_2021 %>%
  filter(Parti == "Socialdemokratiet") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
kons_vind_2021 <- analyse_data_2021 %>%
  filter(Parti == "Det Konservative Folkeparti") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
radikale_vind_2021 <- analyse_data_2021 %>%
  filter(Parti == "Radikale Venstre") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
lokalliste_vind_2021 <- analyse_data_2021 %>%
  filter(Parti == "Lokalliste") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
alternativet_vind_2021 <- analyse_data_2021 %>%
  filter(Parti == "Alternativet") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
sf_vind_2021 <- analyse_data_2021 %>%
  filter(Parti == "Socialistisk Folkeparti") %>%
  filter(tilslutning_bin == 1) %>%
  nrow
df_vind_2021 <- analyse_data_2021 %>%
  filter(Parti == "Dansk Folkeparti") %>%
  filter(tilslutning_bin == 1) %>%
  nrow

tbl_vindmølle_parti <- tibble(parti = c("Venstre", "Socialdemokratiet", "Det Konservative Folkeparti", "Radikale Venstre", "Lokalliste", "Alternativet", "Socialistisk Folkeparti", "Dansk Folkeparti"),
                              pct_vind = c(venstre_vind_pct, soc_dem_vind_pct, kons_vind_pct, radikale_vind_pct, lokalliste_vind_pct, alternativet_vind_pct, sf_vind_pct, df_vind_pct),
                              vind = c(venstre_vind, soc_dem_vind, kons_vind, radikale_vind, lokalliste_vind, alternativet_vind, sf_vind, df_vind),
                              aar_2009 = c(venstre_vind_2009, soc_dem_vind_2009, kons_vind_2009, radikale_vind_2009, lokalliste_vind_2009, alternativet_vind_2009, sf_vind_2009, df_vind_2009),
                              aar_2013 = c(venstre_vind_2013, soc_dem_vind_2013, kons_vind_2013, radikale_vind_2013, lokalliste_vind_2013, alternativet_vind_2013, sf_vind_2013, df_vind_2013),
                              aar_2017 = c(venstre_vind_2017, soc_dem_vind_2017, kons_vind_2017, radikale_vind_2017, lokalliste_vind_2017, alternativet_vind_2017, sf_vind_2017, df_vind_2017),
                              aar_2021 = c(venstre_vind_2021, soc_dem_vind_2021, kons_vind_2021, radikale_vind_2021, lokalliste_vind_2021, alternativet_vind_2021, sf_vind_2021, df_vind_2021))
tbl_vindmølle_parti <- tbl_vindmølle_parti %>%
  arrange(desc(vind)) %>%
  mutate(pct_vind = gsub("\\.", ",", pct_vind))

kbl(tbl_vindmølle_parti, booktabs = T)

tbl_vindmølle_parti <- tbl_vindmølle_parti %>%
  filter(row_number() %in% c(1, 2, 3, 4, 5)) %>%
  add_row(parti = "Socialistisk Folkeparti, Alternativet & Dansk Folkeparti", pct_vind = "0.0%", vind = 0, aar_2009 = 0, aar_2013 = 0, aar_2017 = 0, aar_2021 = 0) %>%
  mutate(pct_vind = gsub("\\.", ",", pct_vind))

tbl_vindmølle_parti <- kbl(tbl_vindmølle_parti, booktabs = TRUE,
                           col.names = c("Parti", "Andel", "Antal", "2009", "2013", "2017", "2021"),
                           align = "lcccccc") %>%
  kable_styling(full_width = TRUE, font_size = 11) %>%
  column_spec(1, width = "6cm") %>%
  add_header_above(c(" " = 1, "Total" = 2, "Valgår" = 4))


datastruktur <- analyse_data %>% 
  filter(valgsted_id == 101001 & valg == "KV2009") %>% 
  select(valgsted_id, valg, Parti, blue_blok, borgmester_stemmer, borgmester_stemmer_pct, tilslutning_aar_valg)
datastruktur
kbl(datastruktur)
