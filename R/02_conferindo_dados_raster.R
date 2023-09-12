###############################################################################
################################ Rasters ######################################

# Carregando pacotes -----
pacman::p_load(terra, patchwork, tmap, geobr, ggplot2, sf, dplyr, mapview,
               ggmap, ggspatial, units, raster)

# Imagens

# As imagens foram baixadas atraves do Google Earth Engine
# Descrição dos produtos: 'wet1985' corresponde a imagem do período chuvoso,
#  e 'dry1985' corresponde a imagem do período seco.
# período chuvoso (wet_season) = [1,120,'day_of_year']; // Jan - Apr
# período seco (dry_season) = [121,274,'day_of_year']; // May - Oct

# USGS Landsat 5 Level 2, Collection 2, Tier 1, surface reflectance (1985)
# "B1" Band 1 (blue); "B2" Band 2 (green); "B3" Band 3 (red); 
# "B4" Band 4 (NIR - near infrared); "B5" Band 5 (SWIR 1 - Shortwave infrared 1); 
# "B6" Band 6 (Surface temperature - thermal infra-red); "B7" Band 7 (SWIR 2 - Shortwave infrared 2)

# USGS Landsat 8 Level 2, Collection 2, Tier 1, surface reflectance (2005 e 2020)
# "B1" Band 1 (ultra blue); "B2" Band 2 (blue); "B3" Band 3 (green); 
# "B4" Band 4 (red); "B5" Band 5 (NIR - near infrared); 
# "B6" Band 6 (SWIR 1 - Shortwave infrared 1); "B7" Band 7 (SWIR 2 - Shortwave infrared 2)

wet1985 <- rast('data/raster/Wet_season/Wet_season_composite_PNCM-1985.tif')
wet2005 <- rast('data/raster/Wet_season/Wet_season_composite_PNCM-2005.tif')
wet2020 <- rast('data/raster/Wet_season/Wet_season_composite_PNCM-2020.tif')

dry1985 <- rast('data/raster/Dry_season/Dry_season_composite_PNCM-1985.tif')
dry2005 <- rast('data/raster/Dry_season/Dry_season_composite_PNCM-2005.tif')
dry2020 <- rast('data/raster/Dry_season/Dry_season_composite_PNCM-2020.tif')

par(mfrow=c(1,2))
plotRGB(wet1985, r = 5, g = 4, b = 3, stretch = 'lin')
plotRGB(dry1985, r = 5, g = 4, b = 3, stretch = 'lin')
a <- plotRGB(img3, r = 5, g = 4, b = 3, stretch = 'lin')
b <- plotRGB(img3, r = 7, g = 3, b = 4, stretch = 'lin')
c <- plotRGB(img3, r = 1, g = 2, b = 3, stretch = 'lin')

## Escolhendo bandas
red <- wet1985$B3
nir <- wet1985$B4

## Summary

summary(red)
summary(nir)

# Histograma

par(mfrow=c(1,2))

hist(red, main = "Banda Vermelho")
hist(nir, main = "Banda NIR")

# Sistema de coordenadas

crs(red, proj = T)
crs(nir, proj = T)

# Número de celulas

ncell(red)

# Dimensões

dim(red)

# Comparar as dimensões

dim(red) == dim(nir)


### Carregando mais de uma banda no mesmo arquivo
# img.stack.raster <- stack('data/Wet_season/Wet_season/Wet_season_composite_PNCM-1985.tif')
# 
# img.stack.raster
# dim(img.stack.raster)


#Como fazer isso com o terra?

img.stack.terra = rast('data/raster/Wet_season/Wet_season_composite_PNCM-1985.tif')


## Como visualizar a imagem?

plot(img.stack.terra$B1)

# Plto RGB
plotRGB(img.stack.terra, r = 3, g = 2, b = 1, stretch = 'lin', axes = T, 
        mar = c(5,5,5,5), main = "Landsat-5 Cor Verdadeira")

plotRGB(img.stack.terra, r = 4, g = 2, b = 1, stretch = 'lin', axes = T, 
        mar = c(5,5,5,5), main = "Landsat-5 Falsa Cor")

# Para selecionar banda dar o nome do objeto e colocar o simbolo "$"
img.stack.terra$B7

#OU por posição numerica
img.stack.terra[[1]]

## Mudando o nome das bandas
names(img.stack.terra) = c("Blue", "Green", "Red", "Nir", "Swir1", 'Surface',
                           'Swir2')
names(img.stack.terra) 


## Fazendo subset (selecionando bandas)

img.visivel = subset(img.stack.terra, c("Blue", "Green", "Red"))

img.visivel
plotRGB(img.visivel, r = 3, g = 2, b = 1, stretch = 'lin', axes = T, 
        mar = c(5,5,5,5), main = "Landsat-5 Cor Verdadeira")
