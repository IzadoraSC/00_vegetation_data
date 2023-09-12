###############################################################################
################################ Clip #########################################

# Carregando pacotes -----
pacman::p_load(terra, patchwork, tmap, geobr, ggplot2, sf, dplyr, mapview,
               ggmap, ggspatial, units, raster)

pacman::p_load(terra, dplyr)


wet1985 <- rast('data/raster/Wet_season/Wet_season_composite_PNCM-1985.tif')
wet2005 <- rast('data/raster/Wet_season/Wet_season_composite_PNCM-2005.tif')
wet2020 <- rast('data/raster/Wet_season/Wet_season_composite_PNCM-2020.tif')

dry1985 <- rast('data/raster/Dry_season/Dry_season_composite_PNCM-1985.tif')
dry2005 <- rast('data/raster/Dry_season/Dry_season_composite_PNCM-2005.tif')
dry2020 <- rast('data/raster/Dry_season/Dry_season_composite_PNCM-2020.tif')

plotRGB(wet1985, r = 4, g = 3, b = 2, stretch = 'lin', axes = T, mar = c(4,4,4,4), main = 'Wet Season - 1985')
plotRGB(dry1985, r = 4, g = 3, b = 2, stretch = 'lin', axes = T, mar = c(4,4,4,4), main = "Dry Season - 1985")


shp <- terra::vect('data/shp/limite_pncm.shp')

## Checar o sistema de coordenadas

crs(wet1985, proj = T)
crs(shp, proj = T)

# Projetando o shape para a img

shp <- terra::project(x = shp, y = wet1985)


# Fazer o recorte (mask)

# img.mask = mask(wet2020, shp) # escolher a imagem
img.mask = mask(dry2020, shp) # escolher a imagem

par(mfrow=c(1,2))

# plotRGB(wet2020, r = 7, g = 2, b = 1, stretch = 'lin', axes = T, mar = c(4,4,4,4))
plotRGB(dry2020, r = 7, g = 2, b = 1, stretch = 'lin', axes = T, mar = c(4,4,4,4))
plotRGB(img.mask, r = 7, g = 2, b = 1, stretch = 'lin', axes = T, mar = c(4,4,4,4))

# Fazer o crop

img.mask.crop = crop(img.mask, shp)

plotRGB(img.mask, r = 7, g = 2, b = 1, stretch = 'lin', axes = T, mar = c(4,4,4,4), main = 'Mask')
plotRGB(img.mask.crop, r = 7, g = 2, b = 1, stretch = 'lin', axes = T, mar = c(4,4,4,4), main = "Crop")


# names(img.mask.crop) = c('B2', "B3", "B4", "B5", "B6", "B7", "B8A", "B11") #sentinel

# Salvando imagens recortadas -----

writeRaster(img.mask.crop, 'outputs/rasters_crop/Wet_season_composite_PNCM-1985_crop.tif')
writeRaster(img.mask.crop, 'outputs/rasters_crop/Wet_season_composite_PNCM-2005_crop.tif')
writeRaster(img.mask.crop, 'outputs/rasters_crop/Wet_season_composite_PNCM-2020_crop.tif')

writeRaster(img.mask.crop, 'outputs/rasters_crop/Dry_season_composite_PNCM-1985_crop.tif')
writeRaster(img.mask.crop, 'outputs/rasters_crop/Dry_season_composite_PNCM-2005_crop.tif')
writeRaster(img.mask.crop, 'outputs/rasters_crop/Dry_season_composite_PNCM-2020_crop.tif')
