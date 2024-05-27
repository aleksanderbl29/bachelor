library(tidyverse)
library(fixest)
library(modelsummary)
library(marginaleffects)
library(cowplot)
library(patchwork)
library(logger)
library(ggsci)

if (!exists("fe_m8")) {
  ## Indlæser modeller der skal bruges
  log_info("Indlæser modeller der skal bruges til modelplot")
  source("data/22-fixedeffects.r")
}

## Indlæser objekter der skal bruges
if (exists("valg_farver") & exists("partier_farver")) {
  log_info("Farver er tidligere indlæst")
} else {
  log_info("Indlæser farver....")
  source("data/39-farver.r")
  log_info("Farver indlæst korrekt")
}


baggrund_0_linje <- list(
  geom_vline(xintercept = 0, color = "grey")
)

modelplot_1 <- modelplot(fe_m8, background = baggrund_0_linje, coef_map = c(
  "tilslutning_aar_valg:PartiLokalliste" = "Lokalliste",
  "tilslutning_aar_valg" = "Socialdemokratiet",
  "tilslutning_aar_valg:PartiRadikale Venstre" = "Radikale Venstre",
  "tilslutning_aar_valg:PartiVenstre" = "Venstre",
  "tilslutning_aar_valg:PartiDet Konservative Folkeparti" = "Det Konservative Folkeparti"
  )) +
  aes(color = ifelse(p.value < 0.05, "< 0,05", "> 0,05")) +
  labs(color = "Signifikansniveau",
       x = "Koefficienter og 95% konfidensinterval",
       y = "Parti") +
  theme_minimal() +
  theme(legend.position = "none") +
  scale_color_manual(values = c("black", "grey"))
modelplot_1


## PLOT FRA https://asjadnaqvi.github.io/DiD/docs/code_r/07-twfe_r/

analyse_data %>%
  ggplot(aes(x = tilslutning_aar_valg, y = borgmester_stemmer_pct, color = valgsted_id)) +
  geom_point() +
  geom_line() +
  scale_x_continuous(breaks = scales::pretty_breaks()) +
  theme(legend.position = "none")


fe_plot_data_blue <- analyse_data %>%
  filter(blue_blok == 1)

fe_plot_model_blue <- feols(borgmester_stemmer_pct ~ i(tilslutning_aar_valg, valgaar, ref = 4) | valgsted_id + valg, data = fe_plot_data_blue)

fe_plot_data_red <- analyse_data %>%
  filter(blue_blok == 0)

fe_plot_model_red <- feols(borgmester_stemmer_pct ~ i(tilslutning_aar_valg, valgaar, ref = 4) | valgsted_id + valg, data = fe_plot_data_red)



valg_estimates <- tribble(
  ~valg, ~effect, ~id, ~error, ~blok,
  "Tre valg før", fe_plot_model_blue$coeftable$Estimate[1], 1, fe_plot_model_blue$coeftable$`Std. Error`[1], "blue",
  "To valg før", fe_plot_model_blue$coeftable$Estimate[2], 2, fe_plot_model_blue$coeftable$`Std. Error`[2], "blue",
  "Valget før", fe_plot_model_blue$coeftable$Estimate[3], 3, fe_plot_model_blue$coeftable$`Std. Error`[3], "blue",
  "Første valg efter", fe_plot_model_blue$coeftable$Estimate[4], 4, fe_plot_model_blue$coeftable$`Std. Error`[4], "blue",
  "To valg efter", fe_plot_model_blue$coeftable$Estimate[5], 5, fe_plot_model_blue$coeftable$`Std. Error`[5], "blue",
  "Tre valg efter", fe_plot_model_blue$coeftable$Estimate[6], 6, fe_plot_model_blue$coeftable$`Std. Error`[6], "blue",
  "Tre valg før", fe_plot_model_red$coeftable$Estimate[1], 1, fe_plot_model_red$coeftable$`Std. Error`[1], "red",
  "To valg før", fe_plot_model_red$coeftable$Estimate[2], 2, fe_plot_model_red$coeftable$`Std. Error`[2], "red",
  "Valget før", fe_plot_model_red$coeftable$Estimate[3], 3, fe_plot_model_red$coeftable$`Std. Error`[3], "red",
  "Første valg efter", fe_plot_model_red$coeftable$Estimate[4], 4, fe_plot_model_red$coeftable$`Std. Error`[4], "red",
  "To valg efter", fe_plot_model_red$coeftable$Estimate[5], 5, fe_plot_model_red$coeftable$`Std. Error`[5], "red",
  "Tre valg efter", fe_plot_model_red$coeftable$Estimate[6], 6, fe_plot_model_red$coeftable$`Std. Error`[6], "red"
)

blue_estimates <- valg_estimates %>%
  filter(blok == "blue")

red_estimates <- valg_estimates %>%
  filter(blok == "red")

valg_estimates_plot <- ggplot(valg_estimates, aes(x = factor(id, levels = c(1, 2, 3, 4, 5, 6)), y = effect, group = 1)) +
  geom_rect(aes(xmin = 2.5, xmax = 3.5, ymin = -Inf, ymax = Inf), fill = "gray", alpha = 0.3) +
  geom_point(aes(color = blok)) +
  geom_line(data = red_estimates, aes(color = blok)) +
  geom_line(data = blue_estimates, aes(color = blok)) +
  geom_errorbar(aes(ymin = effect - error, ymax = effect + error, color = blok), width = 0.2) +
  annotate("text", x = 3, y = 0.003, label = "Wind Turbine Constructed", angle = 90, vjust = -0.5, hjust = 0.5) +
  scale_y_continuous(limits = c(-0.006, 0.006), breaks = seq(-0.006, 0.003, by = 0.001)) +
  scale_x_discrete(labels = c("Tre valg før", "To valg før", "Valget før", "Første valg efter", "To valg efter", "Tre valg efter")) +
  scale_color_manual(values = c("blue" = "blue", "red" = "red")) +
  theme_minimal() +
  labs(x = NULL, y = "Koefficient") +
  facet_wrap(~blok, ncol = 1)

fe_plot_model_blue_straight <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg | valgsted_id + valg, data = fe_plot_data_blue)

fe_plot_model_red_straight <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg | valgsted_id + valg, data = fe_plot_data_red)

marginsplot_xlim <- c(-0.5, 1.5)

fe_m7_pred <- plot_predictions(fe_m7, condition = c("tilslutning_aar_valg", "blue_blok")) +
  scale_x_continuous(limits = marginsplot_xlim, breaks = seq(-2, 4, by = 1)) +
  scale_y_continuous(limits = c(-10, 42), breaks = seq(-10, 40, by = 5)) +
  scale_color_manual(values = c(
    "0" = "red",
    "1" = "blue"
  ), labels = NULL) +
  scale_fill_manual(values = c(
    "0" = "red",
    "1" = "blue"
  ), labels = NULL) +
  labs(color = "Blok", fill = "Blok") +
  theme_cowplot() +
  theme(legend.position = c(0.2, 0.9))
fe_m8_pred <- plot_predictions(fe_m8, condition = c("tilslutning_aar_valg", "Parti")) +
  scale_x_continuous(limits = marginsplot_xlim, breaks = seq(-2, 4, by = 1)) +
  scale_y_continuous(limits = c(-10, 42), breaks = seq(-10, 40, by = 5)) +
  scale_color_manual(values = partier_farver) +
  scale_fill_manual(values = partier_farver) +
  theme_cowplot()

marginsplot_1 <- fe_m7_pred + fe_m8_pred
marginsplot_1


### Udvikling pr parti
analyse_data %>%
  ggplot(aes(x = tilslutning_aar_valg, y = borgmester_stemmer_pct, color = Parti)) +
  geom_point() +
  theme_minimal() +
  stat_summary(aes(y = borgmester_stemmer_pct, group=1), fun.y=mean, colour="red", geom="line",group=1) +
  facet_wrap(~Parti)






plot_predictions(fe_m8, condition = c("tilslutning_aar_valg", "Parti"))

test1 <- analyse_data %>%
  filter(!Parti %in% c("Dansk Folkeparti", "Alternativet"))
test2 <- venstre_analyse_data %>%
  filter(!Parti %in% c("Dansk Folkeparti", "Alternativet"))


test_fe_m8 <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg * Parti | valgsted_id + valg, data = test1)

test_fe_m8_venstre <- feols(borgmester_stemmer_pct ~ tilslutning_aar_valg * Parti | valgsted_id + valg, data = test2)

plot_slopes(test_fe_m8, variables = "tilslutning_aar_valg", by = "Parti")

plot_slopes(test_fe_m8_venstre, variables = "tilslutning_aar_valg", by = "Parti")

plot_predictions(test_fe_m8, condition = c("tilslutning_aar_valg", "Parti")) +
  scale_color_manual(values = partier_farver) +
  scale_fill_manual(values = partier_farver) +
  theme_minimal()
plot_predictions(test_fe_m8_venstre, condition = c("tilslutning_aar_valg", "Parti")) +
  scale_color_manual(values = c("Socialdemokratiet" = "#f04d46",
                                ".Venstre" = "#00639E",
                                "Det Konservative Folkeparti" = "#00583C",
                                "Lokalliste" = "grey40",
                                "Radikale Venstre" = "#EC008C",
                                "Socialistisk Folkeparti" = "#C4151C",
                                "Alternativet" = "#00FF00",
                                "Dansk Folkeparti" = "#0F3459")
  ) +
  scale_fill_manual(values = c("Socialdemokratiet" = "#f04d46",
                                ".Venstre" = "#00639E",
                                "Det Konservative Folkeparti" = "#00583C",
                                "Lokalliste" = "grey40",
                                "Radikale Venstre" = "#EC008C",
                                "Socialistisk Folkeparti" = "#C4151C",
                                "Alternativet" = "#00FF00",
                                "Dansk Folkeparti" = "#0F3459")
  ) +
  theme_minimal()

plot_slopes(test_fe_m8, variables = "tilslutning_aar_valg", condition = c("Parti", "Parti")) +
  scale_color_manual(values = partier_farver) +
  theme_minimal()

plot_slopes(test_fe_m8_venstre, variables = "tilslutning_aar_valg", condition = c("Parti", "Parti")) +
  scale_color_manual(values = partier_farver) +
  theme_minimal()

slope_plot_parti <- plot_slopes(fe_m8, variables = "tilslutning_aar_valg", condition = c("Parti", "Parti")) +
  scale_color_manual(values = partier_farver) +
  geom_hline(yintercept = 0, linewidth = 0.1) +
  theme_cowplot() +
  scale_x_discrete(labels = scales::label_wrap(10)) +
  xlab("") +
  ylab("Ændring i stemmeandel") +
  theme(legend.position = "none")
slope_plot_parti

pt_analyse_data <- analyse_data %>% 
  select(!time) %>% 
  mutate(gname1 = ifelse(tilslutning_bin == 1, valgaar, 0),
         gname2 = ifelse(is.na(tilslutning_treat), NA, valgaar),
         idname = as.numeric(valgsted_id)) %>% 
  mutate(forbogstav = substr(kommunenavn, 1,1))

analyse_data %>% 
  ggplot(aes(x = valgaar, y = borgmester_stemmer_pct)) +
  geom_jitter()

analyse_data %>% 
  filter(borgmester_stemmer_pct < 6) %>% 
  select(valgsted_id, kommunenavn, valgaar, stemmer, Parti, borgmester_stemmer_pct, borgmester_stemmer, A, B, V, C) %>% 
  view()

# 
# pt_plots <- tibble()
# 
# bogstaver <- c(LETTERS, "Æ")
# 
# # Loop over each letter in bogstaver
# for (letter in bogstaver) {
#   # Subset the dataframe where 'forbogstav' matches the current letter
#   bogstav_analyse_data <- pt_analyse_data %>% 
#     filter(forbogstav == letter)
#   
#   # Check if the subset is not empty
#   if (nrow(bogstav_analyse_data) > 0) {
#     # Create the plot
#     p <- bogstav_analyse_data %>% 
#       ggplot(aes(x = valgaar, y = borgmester_stemmer_pct, color = tilsluttet_i)) +
#       geom_point() +
#       geom_line() +
#       theme(legend.position = "none") +
#       facet_wrap(~kommunenavn, ncol = 2)
#     
#     # Print the plot
#     print(p)
#   }
# }
# 
# 
# pt_analyse_data %>% 
#   ggplot(aes(x = valgaar, y = borgmester_stemmer_pct, color = tilsluttet_i)) +
#   geom_point() +
#   geom_line() +
#   theme(legend.position = "none") +
#   facet_wrap(~kommunenavn)
# 
# 
# 
# 
# for (kommune in unique(pt_analyse_data$kommunenavn)) {
#   # Subset the dataframe where 'forbogstav' matches the current letter
#   bogstav_analyse_data <- pt_analyse_data %>%
#     filter(kommunenavn == kommune)
#   
#   # Check if the subset is not empty
#   if (nrow(bogstav_analyse_data) > 0) {
#     # Create the plot
#     p <- bogstav_analyse_data %>%
#       ggplot() +
#       geom_vline(xintercept = 2009, color = "pink") +
#       geom_vline(xintercept = 2013, color = "orange") +
#       geom_vline(xintercept = 2017, color = "lightgreen") +
#       geom_vline(xintercept = 2021, color = "lightblue") +
#       geom_point(data = analyse_data, aes(x = valgaar, y = borgmester_stemmer_pct)) +
#       geom_line(data = analyse_data, aes(x = valgaar, y = borgmester_stemmer_pct)) +
#       geom_point(data = bogstav_analyse_data, aes(x = valgaar, y = borgmester_stemmer_pct, color = tilsluttet_i)) +
#       geom_line(data = bogstav_analyse_data, aes(x = valgaar, y = borgmester_stemmer_pct, color = tilsluttet_i)) +
#       theme(legend.position = "right") +
#       scale_color_manual(values = c(
#         "kv09" = "pink",
#         "kv13" = "orange",
#         "kv17" = "lightgreen",
#         "kv21" = "lightblue"
#       )) +
#       labs(title = paste("Parallele trends for", kommune))
#     log_info(paste("Graf lavet for", kommune))
#     
#     # Print the plot
#     print(p)
#   }
# }
# 
# for (kommune in unique(pt_analyse_data$kommunenavn)[70:75]) {
#   # Subset the dataframe where 'forbogstav' matches the current letter
#   bogstav_analyse_data <- pt_analyse_data %>%
#     filter(kommunenavn == kommune)
#   
#   # Check if the subset is not empty
#   if (nrow(bogstav_analyse_data) > 0) {
#     # Create the plot
#     p <- bogstav_analyse_data %>%
#       ggplot() +
#       geom_vline(xintercept = 2009, color = "pink") +
#       geom_vline(xintercept = 2013, color = "orange") +
#       geom_vline(xintercept = 2017, color = "lightgreen") +
#       geom_vline(xintercept = 2021, color = "lightblue") +
#       # geom_point(data = analyse_data, aes(x = valgaar, y = borgmester_stemmer_pct)) +
#       # geom_line(data = analyse_data, aes(x = valgaar, y = borgmester_stemmer_pct), color = "grey40") +
#       # geom_point(data = bogstav_analyse_data, aes(x = valgaar, y = borgmester_stemmer_pct, color = tilsluttet_i)) +
#       geom_line(data = bogstav_analyse_data, aes(x = valgaar, y = borgmester_stemmer_pct, color = tilsluttet_i, fill = valgsted_id)) +
#       theme(legend.position = "none") +
#       scale_color_manual(values = c(
#         "kv09" = "pink",
#         "kv13" = "orange",
#         "kv17" = "lightgreen",
#         "kv21" = "lightblue"
#       )) +
#       labs(title = paste("Parallele trends for", kommune)) +
#       facet_wrap(~valgsted_id)
#     log_info(paste("Graf lavet for", kommune))
#     
#     # Print the plot
#     print(p)
#     log_info(paste(kommune, "er printet"))
#   }
# }
# 
# 
# 
