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
#| tbl-cap: "Regressionstabel med gt pakken"
#| label: tbl-reg-1
library(tidyverse)
library(gt)
print("HER MANGLER VIDST NOGET")
# gt_reg_tbl |> opt_stylize(style = 1, color = "pink", add_row_striping = TRUE) %>% tab_source_note("Data er egen tilvirkning, DST og ENS") %>% tab_footnote("Her er en fodnote") # %>% gt::as_latex()
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
#| tbl-cap: "Regressionstabel med gt pakken"
#| label: tbl-reg-html
library(tidyverse)
print("HER MANGLER VIDST OGSÅ NOGET")
# gt_reg_tbl %>% opt_stylize(style = 1, color = "pink", add_row_striping = TRUE) %>% tab_source_note(source_note = md("Data er egen tilvirkning, *DST* og *ENS*")) %>% gt::as_raw_html()
#
#
#
#
#
