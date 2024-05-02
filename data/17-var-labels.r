## Giver labels til variablene i analyse_data
expect_true(exists("analyse_data"))

analyse_data$valgsted_id <- haven::labelled(analyse_data$valgsted_id, label = "Stemmested")
analyse_data$valg <- haven::labelled(analyse_data$valg, label = "Valgår")
