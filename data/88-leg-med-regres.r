library(fixest)
library(tidyverse)
library(modelsummary)
library(bacondecomp)

dat4 = data.frame(
  id = rep(1:3, times = 10),
  tt = rep(1:10, each = 3)
) |>
  within({
    D = (id == 2 & tt >= 5) | (id == 3 & tt >= 8)
    btrue = ifelse(D & id == 3, 4, ifelse(D & id == 2, 2, 0))
    y = id + 1 * tt + btrue * D
  })

# Optional: custom ggplot2 theme
theme_set(
  theme_linedraw() +
    theme(
      panel.grid.minor = element_line(linetype = 3, linewidth = 0.1),
      panel.grid.major = element_line(linetype = 3, linewidth = 0.1)
    )
)

ggplot(dat4, aes(x = tt, y = y, col = factor(id))) +
  geom_point() + geom_line() +
  geom_vline(xintercept = c(4.5, 7.5), lty = 2) +
  scale_x_continuous(breaks = scales::pretty_breaks()) +
  labs(x = "Time variable", y = "Outcome variable", col = "ID")

feols(y ~ D | id + tt, dat4)

rbind(
  dat4 |> subset(id %in% c(1,2)) |> transform(role = ifelse(id==2, "Treatment", "Control"), comp = "1.1. Early vs Untreated"),
  dat4 |> subset(id %in% c(1,3)) |> transform(role = ifelse(id==3, "Treatment", "Control"), comp = "1.2. Late vs Untreated"),
  dat4 |> subset(id %in% c(2,3) & tt<8) |> transform(role = ifelse(id==2, "Treatment", "Control"), comp = "2.1. Early vs Untreated"),
  dat4 |> subset(id %in% c(2:3) & tt>4) |> transform(role = ifelse(id==3, "Treatment", "Control"), comp = "2.2. Late vs Untreated")
) |>
  ggplot(aes(tt, y, group = id, col = factor(id), lty = role)) +
  geom_point() + geom_line() + 
  facet_wrap(~comp) +
  scale_x_continuous(breaks = scales::pretty_breaks()) +
  scale_linetype_manual(values = c("Control" = 5, "Treatment" = 1)) +
  labs(x = "Time variable", y = "Ouroleome variable", col = "ID", lty = "Role")

(bgd = bacon(y ~ D, dat4, id_var = "id", time_var = "tt"))

(bgd_wm = weighted.mean(bgd$estimate, bgd$weight))


ggplot(bgd, aes(x = weight, y = estimate, shape = type, col = type)) +
  geom_hline(yintercept = bgd_wm, lty  = 2) +
  geom_point(size = 3) +
  labs(
    x = "Weight", y = "Estimate", shape = "Type", col = "Type",
    title = "Bacon-Goodman decomposition example",
    caption = "Note: The horizontal dotted line depicts the full TWFE estimate."
  )


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

# 
# msummary(tbl_borgmester_interaktion_modeller,
#          output = "kableExtra", gof_omit = "AIC|BIC",
#          gof_map = tbl_borgmester_interaktion_modeller_gof_map,
#          estimate = "{estimate}{stars}") %>%
#   kable_styling(full_width = TRUE, latex_options = c("repeat_header"), latex_table_env = "fonttable", font_size = 10) %>%
#   column_spec(1, width = "5cm") %>%
#   add_header_above(c(" " = 1, "Afhængig: Stemmeandel til borgmesterparti i %" = 8))
# 
# 
# msummary(tbl_borgmester_interaktion_modeller,
#          output = "gt", stars = TRUE,
#          coef_map = c(
#            "tilslutning_aar_valg" = "Vindmølle tilsluttet",
#            "blue_blok" = "Blå blok",
#            "PartiVenstre" = "Venstre",
#            "tilslutning_aar_valg:blue_blok" = "Vindmølle tilsluttet x Blå blok",
#            "tilslutning_aar_valg:PartiVenstre" = "Vindmølle tilsluttet x Venstre",
#            "tilslutning_aar_valg:PartiSocialdemokratiet" = "Vindmølle tilsluttet x Socialdemokratiet"
#          ), gof_map = tbl_borgmester_interaktion_modeller_gof_map)  %>%
#   tab_spanner(label = "Afhængig: Stemmeandel til borgmesterparti i %", columns = -1) %>%
#   cols_align_decimal() %>%
#   tab_style(style = cell_borders(sides = c("bottom"), weight = px(0.5)), locations = cells_body(rows = c(10))) %>%
#   fmt_number(columns = everything(), locale = "da") %>%
#   fmt_auto(locale = "da")

