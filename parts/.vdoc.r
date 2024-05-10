#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
sign_stjerner
#
#
#
#
#
#| file: data/30-plots.r
#| error: false
#| cache: true
#| warning: false
#| output: false

#
#
#
#
#| fig-cap: Stemmesteder med ny vindmølle op til valg

treatment_rollout_map_baggrund

#
#
#
#
#| fig-cap: Manuel graf med stemmesteder

ggplot() +
  geom_sf(data = vind_afstemningssteder_geodata, alpha=0.1, linewidth = 0.01) +
  geom_sf(data = f_rollout_vind_stemmesteder, mapping = aes(fill = valg), linewidth = 0) +
  theme_minimal() +
  theme(legend.position = "right")

#
#
#
