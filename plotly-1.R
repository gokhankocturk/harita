# libraries ----
library(sf)
library(tidyverse)
library(plotly)
# load data ----
load(url("https://github.com/bariscr/data/raw/master/tr_sf.Rdata"))
# create the centroid ----
tr_center <- tr_sf %>% 
  st_centroid() %>% 
  mutate(
    x = map_dbl(geometry, 1),
    y = map_dbl(geometry, 2)
  )
# create the plot ----
p <- plot_ly(tr_sf) %>% 
  add_sf(
    color = ~goat,
    split = ~province_name,
    span = I(1),
    text = ~paste(province_name, scales::comma(goat)),
    hoveron = "fills",
    hoverinfo = "text"
  ) %>% 
  layout(showlegend = FALSE) %>% 
  colorbar(title = "Number of Goats") %>% 
  add_annotations(
    data = select(tr_center, province_name, x, y),
    text = ~province_name, x = ~x, y = ~y, 
    showarrow = FALSE
  ) 
# save as html ----
library(htmlwidgets)
library(plotly)
saveWidget(p, "p1.html", selfcontained = F, libdir = "lib")
zip("p2.zip", c("p1.html", "lib"))