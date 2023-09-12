## Script GeoBR e Ggplot
library(geobr)
library(ggplot2)
library(dplyr)
library(sf)

br <- geobr::read_country(year = 2019)

li_br <- ggplot(br) +
  geom_sf()

li_br

estados <- geobr::read_state()

View(estados)

estados <- geobr::read_state() %>% dplyr::filter(name_region == 'Nordeste')

ma <- geobr::read_municipality(code_muni = 2102804) %>% mutate(area = st_area(geom))

ggplot(ma) + geom_sf()

ggplot(estados) + geom_sf()
