# libraries ----
# KOD ÜZERİNDE DE BAZI DEĞİŞİKLİKLER YAPTIM
# 2 SATIR
library(sf)
library(tidyverse)
library(plotly)
library(readxl)
library(data.table)
# load data ----
hba_ibbs <- read_excel("hba_ibbs.xlsx")
hba_ibbs <- as.data.table(hba_ibbs)
hba_ibbs <- hba_ibbs[, .SD[1], by = .(ibbs2)]
plakson <- c(34, 22, 10, 35, 20, 45, 16, 41, 6, 42, 7, 1, 31, 50, 38, 67,37,55,61, 25,36, 44,65,27,21,56)
hba_ibbs <- cbind(hba_ibbs, plakson)
hba_ibbs <- hba_ibbs %>% mutate(plaka = row_number())
hba_ibbs$plakson <- as.numeric(hba_ibbs$plakson)
tr_sf$province_code <- as.numeric(tr_sf$province_code)
tr_center1 <- tr_sf %>% left_join(hba_ibbs[, c("plakson", "pay")], by = c("province_code" = "plakson"))
str(hba_ibbs)

load(url("https://github.com/bariscr/data/raw/master/tr_sf.Rdata"))
# create the centroid ----
hba_center <- tr_center1 %>% 
  st_centroid() %>% 
  mutate(
    x = map_dbl(geometry, 1),
    y = map_dbl(geometry, 2)
  )
# create the plot ----
p <- plot_ly(tr_center1) %>% 
  add_sf(
    color = ~pay,
    split = ~province_name,
    span = I(1),
    text = ~paste(province_name, scales::comma(pay)),
    hoveron = "fills",
    hoverinfo = "text"
  ) %>% 
  layout(showlegend = FALSE) %>% 
  colorbar(title = "Pay (%)") %>% 
  add_annotations(
    data = select(tr_center, province_name, x, y),
    text = ~province_name, x = ~x, y = ~y, 
    showarrow = FALSE
  ) 
p
# save as html ----
library(htmlwidgets)
library(plotly)
saveWidget(p, "p1.html", selfcontained = F, libdir = "lib")
zip("p2.zip", c("p1.html", "lib"))
