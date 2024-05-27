library(tidyverse)
library(fixest)
library(modelsummary)
library(bacondecomp)

did_analyse_data <- analyse_data %>% 
  select(!time) %>% 
  mutate(gname1 = ifelse(tilslutning_bin == 1, valgaar, 0),
         gname2 = ifelse(is.na(tilslutning_treat), 0, ifelse(tilslutning_aar == 1, valgaar, valgaar - tilslutning_aar)),
         idname = as.numeric(valgsted_id))

analyse_data %>% 
  ggplot(aes(x = valgaar, y = borgmester_stemmer_pct, col = factor(valgsted_id))) +
  geom_point() +
  geom_line() +
  theme(legend.position = "none")


bacon_data <- slice_sample(analyse_data, n = 50, by = c("valgsted_id", "valg")) %>% 
  mutate(treated = as.numeric(tilslutning_bin))

cont_table <- table(bacon_data$valgsted_id, bacon_data$valg)

filtered_cont_table <- cont_table[rowSums(cont_table) != 4, ]

valgsteder_med_fejl <- filtered_cont_table %>% rownames()

filtered_analyse_data <- bacon_data[bacon_data$valgsted_id %in% valgsteder_med_fejl, ]

expect_true(nrow(filtered_analyse_data) == 0)

feols(borgmester_stemmer_pct ~ tilslutning_aar_valg | valgsted_id + valg, data = analyse_data)

df_bacon <- bacon(borgmester_stemmer_pct ~ tilslutning_aar_valg,
                  data = analyse_data,
                  id_var = "valgsted_id",
                  time_var = "valgaar")
df_bacon




library(did)
cs21 <- att_gt(
  yname = "borgmester_stemmer_pct",
  tname = "valgaar",
  idname = "idname",
  gname = "gname2",
  xformla = ~Parti,
  clustervars = "valgsted_id",
  data = did_analyse_data
)

cs21_es <- aggte(cs21)
cs21_es

ggdid(cs21_es)
