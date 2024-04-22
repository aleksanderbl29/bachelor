library(tidyverse)

kmd_stemmer <- stemmer %>%
  select(any_of(gem_kolonner), starts_with("KV")) %>%
  pivot_longer(cols = starts_with("KV"),
               names_to = "valg",
               values_to = "stemmer") %>%
  separate(col = valg, into = c("valg", "parti"), sep = " - ") %>%
  mutate(partinavn = case_when(parti == "A" ~ "Socialdemokratiet",
                               parti == "V" ~ "Venstre, Danmarks Liberale Parti",
                               parti == "C" ~ "Det Konservative Folkeparti",
                               parti == "F" ~ "SF - Socialistisk Folkeparti",
                               parti == "Ø" ~ "Enhedslisten - De Rød-Grønne",
                               parti == "B" ~ "Radikale venstre",
                               parti == "O" ~ "Dansk Folkeparti",
                               parti == "D" ~ "Nye Borgerlige",
                               parti == "I" ~ "Liberal Alliance",
                               parti == "K" ~ "Kristendemokraterne",
                               parti == "Å" ~ "Alternativet",
                               parti == "S" ~ "Slesvigsk Parti",
                               parti == "T" ~ "Tønder Listen",
                               parti == "G" ~ "Veganerpartiet",
                               parti == "L" ~ "Lokalliste",
                               parti == "Q" ~ "Østbroen",
                               parti == "E" ~ "nytgribskov",
                               parti == "H" ~ "Klimapartiet Momentum",
                               parti == "Æ" ~ "Frihedslisten",
                               parti == "N" ~ "Nyt Odsherred",
                               parti == "W" ~ "Bornholmerlisten",
                               parti == "Stemmeberettigede" ~ "Stemmeberettigede",
                               parti == "Gyldige stemmer" ~ "Gyldige stemmer")) %>%
  drop_na(partinavn)

kmd_nrow <- nrow(kmd_stemmer)
head(kmd_stemmer)
unique(kmd_stemmer$parti)
unique(kmd_stemmer$partinavn)
unique(kmd_stemmer$valg)

kmd_nrow - alle_nrow

na_stemmer <- alle_stemmer %>%
  filter(is.na(partinavn))

na_nrow <- nrow(na_stemmer)

na_nrow - alle_nrow
