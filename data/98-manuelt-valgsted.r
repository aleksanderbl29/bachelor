library(tidyverse)
library(httr)
library(tidyverse)
library(jsonlite)
library(readxl)
library(testthat)

## Rødding Forsamlingshus
## DAWA
treatment <- treatment %>% 
  mutate(valgsted_id = as.factor(valgsted_id)) %>% 
  mutate(valgsted_id = case_when(valgsted_id == "779024" ~ "779010",
                                 .default = valgsted_id)) %>% 
  mutate(valgsted_id = as.double(valgsted_id))

valgsted_id_fejl <- c("779024",
                      "")

rm(valgsted_id_fejl)
