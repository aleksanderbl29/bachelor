## Forbered til dynamisk did estimation

analyse_data <- analyse_data %>% 
  mutate(dyn_did_t1 = case_when(kv01 == 1 & ))





analyse_data <- analyse_data %>%
  select(!c("kv01", "kv05", "kv09", "kv13", "kv17", "kv21"))
