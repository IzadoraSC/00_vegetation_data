###############################################################################
################################ Amostras ######################################

# Carregando pacotes -----
pacman::p_load(terra, patchwork, tmap, geobr, ggplot2, sf, dplyr, mapview,
               ggmap, sp, ggspatial, units, raster)

#Amostras
agr <- sf::st_read('data/shp/1985/agricultura.shp')
agu <- sf::st_read('data/shp/1985/agua.shp')
cp <- sf::st_read('data/shp/1985/cerradao_planicie.shp')
cp$Class <- 4
cs <- sf::st_read('data/shp/1985/cerradao_serrano.shp')
cs$Class <- 5
ca <- sf::st_read('data/shp/1985/cerrado_aberto.shp')
cd <- sf::st_read('data/shp/1985/cerrado_denso.shp')
cr <- sf::st_read('data/shp/1985/cerrado_rupestre.shp')
mg <- sf::st_read('data/shp/1985/mata_galeria.shp')
# terra::vect()

## Carregando a imagem

img = stack("data/raster/1985/pncm_1985_ok.tif")
names(img)

names(img) = c("B1_wet", "B2_wet", "B3_wet", "B4_wet", "B5_wet", 
                   "B7_wet","B1_dry", "B2_dry", "B3_dry", "B4_dry", "B5_dry", 
                   "B7_dry")

## Merge shp amostras
list1 <- list(agr, agu, ca)
amostra <- st_union(agr, agu, by_feature = "Class")

agr <- rgdal::readOGR('data/shp/1985/agricultura.shp')
agu <- rgdal::readOGR('data/shp/1985/agua.shp')
amostra <- st_union(agr, agu)
plot(amostra)

## Mapview p/ raster

mapview(img$B5_wet)
mapview(img$B5_wet, maxpixels =  8467568)

viewRGB(img, r = 7, g = 2, b = 1)


## Adicionar shapefiles

mapview(botucatu)
mapview(brasil)

mapview(brasil, zcol = "NM_REGIAO")

mapview(classes_lulc, zcol = "Classe") + mapview(botucatu, col.regions = 'black')


# Raster + shapefile

viewRGB(img, r = 7, g = 2, b = 1, maxpixels =  8467568) + 
  mapview(classes_lulc, zcol = "Classe") + 
  mapview(botucatu, col.regions = 'black')