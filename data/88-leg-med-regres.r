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

