library(DIDmultiplegtDYN)

### DIDmultiplegtDYN

model_dCDH24_1 <- did_multiplegt_dyn(df = analyse_data, outcome = "borgmester_stemmer_pct",
                                     group =  "valgsted_id", time =  "valg", treatment =  "tilslutning_aar_valg")
model_dCDH24_1

model_dCDH24_2 <- did_multiplegt_dyn(df = analyse_data, outcome = "borgmester_stemmer_pct",
                                     group =  "valgsted_id", time =  "valg", treatment =  "tilslutning_aar_valg",
                                     effects = 3)
model_dCDH24_2

model_dCDH24_3 <- did_multiplegt_dyn(df = analyse_data, outcome = "borgmester_stemmer_pct",
                                     group =  "valgsted_id", time =  "valg", treatment =  "tilslutning_aar_valg",
                                     effects = 3, only_never_switchers = TRUE)
model_dCDH24_3


### DIDmultiplegtDYN for blå blok

blå_analyse_data <- analyse_data %>%
  filter(blue_blok == 1) %>% 
  filter(Parti == "Venstre")

blå_model_dCDH24_1 <- did_multiplegt_dyn(df = blå_analyse_data, outcome = "borgmester_stemmer_pct",
                                     group =  "valgsted_id", time =  "valg", treatment =  "tilslutning_aar_valg")
blå_model_dCDH24_1

blå_model_dCDH24_2 <- did_multiplegt_dyn(df = blå_analyse_data, outcome = "borgmester_stemmer_pct",
                                     group =  "valgsted_id", time =  "valg", treatment =  "tilslutning_aar_valg",
                                     effects = 3)
blå_model_dCDH24_2

blå_model_dCDH24_3 <- did_multiplegt_dyn(df = blå_analyse_data, outcome = "borgmester_stemmer_pct",
                                     group =  "valgsted_id", time =  "valg", treatment =  "tilslutning_aar_valg",
                                     effects = 3, only_never_switchers = TRUE)
blå_model_dCDH24_3


### DIDmultiplegtDYN for rød blok

rød_analyse_data <- analyse_data %>%
  filter(blue_blok == 0)

rød_model_dCDH24_1 <- did_multiplegt_dyn(df = rød_analyse_data, outcome = "borgmester_stemmer_pct",
                                     group =  "valgsted_id", time =  "valg", treatment =  "tilslutning_aar_valg")
rød_model_dCDH24_1

rød_model_dCDH24_2 <- did_multiplegt_dyn(df = rød_analyse_data, outcome = "borgmester_stemmer_pct",
                                     group =  "valgsted_id", time =  "valg", treatment =  "tilslutning_aar_valg",
                                     effects = 3)
rød_model_dCDH24_2

rød_model_dCDH24_3 <- did_multiplegt_dyn(df = rød_analyse_data, outcome = "borgmester_stemmer_pct",
                                     group =  "valgsted_id", time =  "valg", treatment =  "tilslutning_aar_valg",
                                     effects = 3, only_never_switchers = TRUE)
rød_model_dCDH24_3
