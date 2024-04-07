library(tidyverse)

# Load data
data <- mtcars

# Head

# head(data)

# Plot
plot1 <- data %>% ggplot(data = ., aes(x = cyl, y = mpg)) +
  geom_point() +
  labs(title = "Scatter plot of mpg vs cyl",
       x = "Cylinders",
       y = "Miles per gallon") +
  theme_minimal()

plot1
