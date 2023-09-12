## Vegetation Index no R ##
pacman::p_load(terra, raster, RStoolbox)

# carregando imagem

img <- brick('data/raster/1985/pncm_1985_clip_uint16.tif')
img

## Selecionando e Mudando o nome das bandas
names(img) = c("B1", "B2", "B3", "B4", "B5", "B7","B1_1",
               "B2_2", "B3_3", "B4_4", "B5_5", "B7_7")
img

# carregando shp
shp <- terra::vect('data/shp/limite_pncm.shp')

# plot imagem

plotRGB(img, r = 3, g = 2, b =1, stretch = 'lin')

# Calculando Indices com o pacote RSToolbox
#Landsat-5
ndvi_wet <- spectralIndices(img, red = 'B3', nir = 'B4', indices = c("NDVI"))
names(ndvi_wet)

ndvi_dry <- spectralIndices(img, red = 'B3_3', nir = 'B4_4', indices = c("NDVI"))
names(ndvi_dry)

plot(ndvi_wet)
plot(ndvi_dry)

#Landsat-8
indices <- spectralIndices(img1, red = 'B4', nir = 'B5', indices = c("NDVI",
                                                                    "NRVI",
                                                                    "MSAVI2",
                                                                    "SAVI",
                                                                    "KNDVI"))


indices1 <- spectralIndices(img1, green = 'B2', swir2 = 'B6', nir = 'B5',
                           indices = c("GNDVI", "NDWI", "NDWI2"))

plot(indices)

# INSERIR BANDAS DOS IVs 

ivs <- subset(indices, c("NDVI",
                          "KNDVI"))
ivs

ivs1 <- subset(indices1, c("NDWI", "NDWI2"))
ivs1

## WET SEASON
ivs_wet <- stack(img, ivs, ivs1)
names(ivs_wet)

## Selecionando e Mudando o nome das bandas
ivs_wet <- subset(ivs_wet, c("B1", "B2", "B3", "B4", "B5", "B7","NDVI",
                             "KNDVI", "NDWI", "NDWI2"))

names(ivs_wet) = c("B1_wet", "B2_wet", "B3_wet", "B4_wet", "B5_wet", 
                   "B7_wet","NDVI_wet","KNDVI_wet", "NDWI_wet", "NDWI2_wet")
## DRY SEASON
ivs_dry <- stack(img1, ivs, ivs1) # antes de executar essa parte voltar e gerar para o dado img1
names(ivs_dry)
## Selecionando e Mudando o nome das bandas
ivs_dry <- subset(ivs_dry, c("B1", "B2", "B3", "B4", "B5", "B7","NDVI",
                             "KNDVI", "NDWI", "NDWI2"))

names(ivs_dry) = c("B1_dry", "B2_dry", "B3_dry", "B4_dry", "B5_dry", 
                   "B7_dry","NDVI_dry","KNDVI_dry", "NDWI_dry", "NDWI2_dry")

par(mfrow=c(1,2))
plotRGB(ivs_wet, r = "B7_wet", g = "B2_wet", b = "B1_wet", stretch = 'lin',
        axes = T,mar = c(1,1,1,1))
plotRGB(ivs_dry, r = "B7_dry", g = "B2_dry", b = 'B1_dry', stretch = 'lin', axes = T, mar = c(1,1,1,1))

plot(ivs_wet$NDVI_wet)
plot(ivs_dry$NDVI_dry)
# t <- tmap::tm_shape(ivs_wet[7]) +
# tmap::tm_raster()
# t


## GERANDO IMAGEM PARA SER UTILIZADA NA CLASSIFICAÇÃO
dry_wet <- stack(ivs_wet, ivs_dry)
names(dry_wet)

par(mfrow=c(1,2))
plotRGB(ivs_wet, r = 7, g = 2, b = 1, stretch = 'lin', axes = T, mar = c(4,4,4,4))
plotRGB(ivs_dry, r = 7, g = 2, b = 1, stretch = 'lin', axes = T, mar = c(4,4,4,4))

# Salvando raster para usar na classificação

img <- subset(img, c("B1", "B2", "B3", "B4", "B5", "B7"))

names(img) = c("B1_wet", "B2_wet", "B3_wet", "B4_wet", "B5_wet", 
                   "B7_wet")

img1 <- subset(img1, c("B1", "B2", "B3", "B4", "B5", "B7"))

names(img1) = c("B1_dry", "B2_dry", "B3_dry", "B4_dry", "B5_dry", 
                   "B7_dry")

dry_wet <- stack(img, img1)

writeRaster(dry_wet, 'data/raster/1985/pncm_1985_v2.tif', overwrite=T)

## NDVI # "(NIR - RED) / (NIR + RED)"

# ndvi_85 <- (img[[4]] - img[[3]]) / (img[[4]] + img[[3]]) #LANDSAT/LT05/C01/T1_SR
# ndvi_20 <- (img4[[5]] - img4[[4]]) / (img4[[5]] + img4[[4]]) # LANDSAT/LC08/C01/T1_SR
# plot(ndvi_20)
# plot(ndvi_85)
# names(ndvi_85) <- "NDVI"
# 
# img_ndvi <- rast(c(img, ndvi_85))
# names(img_ndvi)

## EVI
# "2.5 * ((NIR - RED) / (NIR + 6RED - 7.5BLUE + 1)"

## NDWI
# "(GREEN - SWIR / (GREEN + SWIR)"