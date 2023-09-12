###############################################################################
################################ ÁREA DE ESTUDO ################################

#Carregando pacotes----

pacman::p_load(terra, geobr, ggplot2, sf, dplyr, mapview, ggspatial,
               units, patchwork, cartogram, maptools, maps, mapsf)

# Usando o pacote geobr-----
uc <- read_conservation_units()
uc

li <- sf::st_read('data/shp/limite_pncm.shp')
dt <- data.table::fread(
"X       Y
232425.3   9185532
307374   9237526")

dt %>% 
  sf::st_as_sf( coords = c("X", "Y") ) %>%
  sf::st_set_crs(32723) %>%      #current CRS  <--!! check!!
  sf::st_transform(4326) %>%   #transform CRS 
  sf::st_coordinates()  #export new coordinates


pncm <- uc |> filter(name_conservation_unit == 'PARQUE NACIONAL DA CHAPADA DAS MESAS')
plot(pncm$geom)
mapview(pncm)

str(pncm$geom)

ma <- read_state(code_state = 'MA')
br <- read_country()
biomas <- read_biomes()
ce <- biomas |> filter(name_biome == "Cerrado")
amz_lg <- read_amazon()
plot(amz_lg)

## Plotando o mapa de localização ----

# map1 <- ggplot() +
#   geom_sf(data = br, fill = 'transparent', color = 'gray', size = 0.1) +
#   geom_sf(data = ma, fill = 'darkgray', color = 'black', size = 0.1) +
#   geom_sf(data = ce, fill = 'transparent', color = 'brown', size = 0.2) +
#   geom_sf(data = pncm, fill = 'yellow') +
#   north() +
#   labs(subtitle = 'Brazil - Cerrado', fill = 'Legend') + 
#   annotation_scale(location = "br", width_hint = .3) +
#   annotation_north_arrow(location = "tr", which_north = "true", 
#                          pad_x = unit(0, "cm"), pad_y = unit(.8, "cm"),
#                          style = north_arrow_fancy_orienteering) +
#   theme_bw()


map1 <- ggplot() +
  geom_sf(data = br, aes(fill = "Brasil", color = "Brasil"), size = 0.1) +
  geom_sf(data = ma, aes(fill = "Maranhão", color = "Maranhão"), size = 0.1) +
  geom_sf(data = amz_lg, aes(fill = "Amazônia Legal", color = "Amazônia Legal"),
          size = 0.2) +
  geom_sf(data = ce, aes(fill = "Cerrado", color = "Cerrado"), 
          size = 0.2) +
  geom_sf(data = pncm, aes(fill = "Parque Nacional da Chapada das Mesas", 
                           color = "Parque Nacional da Chapada das Mesas")) +
  north() +
  labs(subtitle = 'Brasil - Amazônia Legal - Cerrado') + 
  annotation_scale(location = "br", width_hint = .3) +
  annotation_north_arrow(location = "tr", which_north = "true", 
                         pad_x = unit(0, "cm"), pad_y = unit(.8, "cm"),
                         style = north_arrow_fancy_orienteering) +
  scale_fill_manual(name = NULL, 
                    values = c(
                      "Brasil" = "transparent", "Amazônia Legal" = "transparent",
                      "Cerrado" = "transparent", "Maranhão" = "darkgray",
                      "Parque Nacional da Chapada das Mesas" = "yellow")) +
  scale_color_manual(name = NULL, 
                     values = c(
                       "Brasil" = "gray", "Amazônia Legal" = 'green' , 
                       "Cerrado" = "brown", "Maranhão" = "black",
                       "Parque Nacional da Chapada das Mesas" = "black")) +
  theme_bw()



map1

map1.1 <- map1 + theme(legend.position = "bottom", legend.key.width = unit(1.0, "cm"))


map2 <- ggplot() +
  geom_sf(data = ma, fill = 'darkgray', color = 'black', size = 0.1,  
          show.legend = "line") +
  geom_sf(data = pncm, fill = 'yellow', show.legend = "line") +
  # geom_sf(data = pncm, fill = 'yellow',  aes(color=name_conservation_unit),
  #         size = 2, show.legend = "polygon") +
  # scale_color_manual(values='black') +
  labs(subtitle = 'Parque Nacional Chapada das Mesas') + 
  annotation_scale(location = "br", width_hint = .4) +
  annotation_north_arrow(location = "tr", which_north = "true", 
                         pad_x = unit(0, "cm"), pad_y = unit(.8, "cm"),
                         style = north_arrow_fancy_orienteering) +
  theme_bw()

map1.1 + map2 

ggsave(filename = 'outputs/pncm_localizacao.jpeg', 
       width = 10, height = 10, units = 'in', dpi = 300)

# salvando o arquivo shp-----
st_write(pncm, 'data/shp/pncm_limite_geobr.shp')

##################
# Carregando o arquivo shp do local de estudo------

limite <- sf::st_read('data/shp/limite_pncm.shp')
# limite_geobr <- sf::st_read('data/shp/pncm_limite_geobr.shp')
# limite <- terra::vect('data/shp/limite_pncm.shp')
# limite <- rgdal::readOGR('data/shp/limite_pncm.shp')

limite

crs(limite, proj = T)

# Exemplo para transformar projeção ------

limite_geobr <- st_transform(limite_geobr, crs(limite))
crs(limite_geobr, proj = T)

# Transformar para SIRGAS 2000: EPSG:4674
## Proj4string +proj=longlat +ellps=GRS80 +no_defs +type=crs
# shapefiles.sirgas = project(limite, 'EPSG:4674')
# print(shapefiles.sirgas)
# shapefiles.sirgas = project(shp, crs('+proj=longlat +ellps=GRS80 +no_defs +type=crs'))


# Outra opção usando o SF -------

shp = st_read("data/shp/limite_pncm.shp")

# Exemplo para transformar projeção -------

shapefile.sirgas = st_transform(
  x = shp, 
  crs = crs('+proj=longlat +ellps=GRS80 +no_defs +type=crs'))

crs(shapefile.sirgas, proj = T)

## Bouding box -----

st_bbox(limite)

## Area -----

st_area(limite) |> units::set_units('ha')
st_area(limite) |> units::set_units('km2')

## Buffer ------
# 
# limite.buffer.3 <- ?st_buffer(limite, dist = 3)
# limite.buffer.10 = st_buffer(limite, dist = 10)
# limite.buffer.20 = st_buffer(limite, dist = 20)
# 
# mapview(limite.buffer.3, col.regions = 'red', cex = 1, pch = 20) +
#   mapview(limite.buffer.10, col.regions = 'purple', cex = 1, pch = 20) +
#   mapview(limite.buffer.20, col.regions = 'orange', cex = 1, pch = 20) +
#   mapview(limite, col.regions = 'black', cex = 1, pch = 20)


#########