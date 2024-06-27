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

analyse_data %>% filter(valgsted_id == 101017) %>% select(1, valgaar, 35:36) %>% kbl(col.names = c("$i$", "$t$", "$Y_{it}$", "$D_{it}$"))


marginsplot_xlim <- c(-0.5, 1.5)

fe_m7_pred <- plot_predictions(fe_m7, condition = c("tilslutning_aar_valg", "blue_blok")) +
  scale_x_continuous(limits = marginsplot_xlim, breaks = seq(-2, 4, by = 1), label = c("", "", "Valg før vindmølle", "Vindmølle opsat", "", "", "")) +
  scale_y_continuous(limits = c(-10, 42), breaks = seq(-10, 40, by = 5)) +
  scale_color_manual(values = c(
    "0" = "red",
    "1" = "blue"
  ), labels = c(
    "0" = "Rød",
    "1" = "Blå"
  )) +
  scale_fill_manual(values = c(
    "0" = "red",
    "1" = "blue"
  ),  labels = c(
    "0" = "Rød",
    "1" = "Blå"
  )) +
  labs(color = "Blok", fill = "Blok") +
  xlab("") +
  ylab("Andel stemmer til borgmesterparti") +
  theme_cowplot() +
  theme(legend.position = c(0.2, 0.9))
fe_m8_pred <- plot_predictions(fe_m8_plt, condition = c("tilslutning_aar_valg", "Parti")) +
  scale_x_continuous(limits = marginsplot_xlim, breaks = seq(-2, 4, by = 1), label = c("", "", "Valg før vindmølle", "Vindmølle opsat", "", "", "")) +
  scale_y_continuous(limits = c(-10, 42), breaks = seq(-10, 40, by = 5)) +
  scale_color_manual(values = partier_farver, labels = scales::label_wrap(10)) +
  scale_fill_manual(values = partier_farver, labels = scales::label_wrap(10)) +
  ylab("") + 
  xlab("") +
  theme_cowplot()

# marginsplot_2 <- fe_m7_pred + fe_m8_pred
marginsplot_2 <- fe_m8_pred + scale_y_continuous(limits = c(-10, 30), breaks = seq(-10, 40, by = 5))  + geom_vline(xintercept = c(0, 1), linewidth = 0.1)
marginsplot_2


marginsplot_3 <- fe_m7_pred + scale_y_continuous(limits = c(23, 30), breaks = seq(-10, 40, by = 5)) + theme(legend.position = "right") + geom_vline(xintercept = c(0, 1), linewidth = 0.1)
marginsplot_3

### Udvikling pr parti
analyse_data %>%
  ggplot(aes(x = tilslutning_aar_valg, y = borgmester_stemmer_pct, color = Parti)) +
  geom_point() +
  theme_minimal() +
  stat_summary(aes(y = borgmester_stemmer_pct, group=1), fun.y=mean, colour="red", geom="line",group=1) +
  facet_wrap(~Parti)


fe_m1_pred <- plot_predictions(fe_m1, condition = "tilslutning_aar_valg") +
  scale_x_continuous(limits = marginsplot_xlim, breaks = seq(-2, 4, by = 1), label = c("", "", "Valg før vindmølle", "Vindmølle opsat", "", "", "")) +
  ylab("Andel stemmer til borgmesterparti") +
  xlab("Model 1") +
  theme_cowplot()
fe_m2_pred <- plot_predictions(fe_m2, condition = "tilslutning_aar_valg") +
  scale_x_continuous(limits = marginsplot_xlim, breaks = seq(-2, 4, by = 1), label = c("", "", "Valg før vindmølle", "Vindmølle opsat", "", "", "")) +
  ylab("") +
  xlab("Model 2") +
  theme_cowplot()

marginsplot_1 <- fe_m1_pred + fe_m2_pred
marginsplot_1


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

slope_plot_parti <- plot_slopes(fe_m8_plt, variables = "tilslutning_aar_valg", condition = c("Parti", "Parti")) +
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
  filter(borgmester_stemmer_pct == 0) %>%
  select(valgsted_id, kommunenavn, valgaar, stemmer, Parti, borgmester_stemmer_pct, borgmester_stemmer, A, B, V, C) %>%
  ggplot(aes(x = valgaar, fill = kommunenavn)) +
  geom_bar() +
  theme()

slope_plot_blok <- plot_slopes(fe_m7, variables = "tilslutning_aar_valg", condition = c("blue_blok", "blue_blok")) +
  geom_hline(yintercept = 0, linewidth = 0.1) +
  theme_cowplot() +
  scale_x_discrete(labels = c("0" = "Rød blok", "1" = "Blå blok")) +
  scale_color_manual(values = c(
    "0" = "red",
    "1" = "blue"
  ), labels = NULL) +
  scale_fill_manual(values = c(
    "0" = "red",
    "1" = "blue"
  ), labels = NULL) +
  xlab("") +
  ylab("Ændring i stemmeandel") +
  theme(legend.position = "none")
slope_plot_blok


pr_tr_p1 <- analyse_data %>% 
  filter(!is.na(tilslutning_treat)) %>% 
  filter(time == 1 & tilslutning_aar_valg <= 0)

pr_tr_p1_mean <- tribble(
  ~time, ~borgmester_stemmer_pct,
  1, mean(pr_tr_p1$borgmester_stemmer_pct)
)

pr_tr_p2 <- analyse_data %>% 
  filter(!is.na(tilslutning_treat)) %>% 
  filter(time <= 2 & tilslutning_aar_valg <= 0)

pr_tr_p3 <- analyse_data %>% 
  filter(!is.na(tilslutning_treat)) %>% 
  filter(time <= 3 & tilslutning_aar_valg <= 0)

pr_tr_p4 <- analyse_data %>% 
  filter(!is.na(tilslutning_treat)) %>% 
  filter(time <= 4 & tilslutning_aar_valg <= 0)

pr_ik_tr <- analyse_data %>% 
  filter(is.na(tilslutning_treat))

### PArrallele trends
prl_trends <- ggplot() +
  geom_point(data = pr_tr_p1_mean, aes(x = time, y = borgmester_stemmer_pct, fill = "2009"), color = "#E69F00", size = 3) +
  geom_smooth(data = pr_tr_p2, aes(x = time, y = borgmester_stemmer_pct, fill = "2013"), color = "#56B4E9", method = lm, se = FALSE) +
  geom_smooth(data = pr_tr_p3, aes(x = time, y = borgmester_stemmer_pct, fill = "2017"), color = "#009E73", method = lm, se = FALSE) +
  geom_smooth(data = pr_ik_tr, aes(x = time, y = borgmester_stemmer_pct, fill = "Aldrig treatet"), color = "grey40", method = lm, se = FALSE) +
  labs(fill = "Sidste valg inden vindmølle") +
  ylab("Borgmesterpartiets stemmeandel i %") +
  xlab("") +
  scale_x_continuous(labels = c("2009", "2013", "2017", "2021")) +
  theme_cowplot()
  
prl_trends


analyse_data %>%
  ggplot(aes(x = valgaar, y = borgmester_stemmer_pct)) +
  geom_smooth(method = "loess") +
  facet_wrap(~tilsluttet_i)

app_prl_trends <- ggplot() +
  geom_point(data = pr_tr_p1_mean, aes(x = time, y = borgmester_stemmer_pct, fill = "2009"), color = "#E69F00", size = 3) +
  geom_smooth(data = pr_tr_p2, aes(x = time, y = borgmester_stemmer_pct, fill = "2013"), color = "#56B4E9", method = lm, se = FALSE) +
  geom_smooth(data = pr_tr_p3, aes(x = time, y = borgmester_stemmer_pct, fill = "2017"), color = "#009E73", method = loess, se = FALSE) +
  geom_smooth(data = pr_ik_tr, aes(x = time, y = borgmester_stemmer_pct, fill = "Aldrig treatet"), color = "grey40", method = loess, se = FALSE) +
  labs(fill = "Sidste valg uden vindmølle") +
  ylab("Borgmesterpartiets stemmeandel i %") +
  xlab("") +
  scale_x_continuous(labels = c("2009", "2013", "2017", "2021")) +
  theme_cowplot()
app_prl_trends





