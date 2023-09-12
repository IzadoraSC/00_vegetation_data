## CUBO DE DADOS ##

# https://www.nationalgeographicbrasil.com/historia/2023/03/quando-e-como-foi-descoberto-o-fogo-a-verdade-sobre-essa-historia
# https://panorama.sipam.gov.br/painel-do-fogo/#

pacman::p_load(terra, raster, RStoolbox)


#wet1985 <- brick('data/raster/Wet_season/Wet_season_composite_PNCM-1985.tif')
#wet2005 <- brick('data/raster/Wet_season/Wet_season_composite_PNCM-2005.tif')
wet2020 <- brick('data/raster/Wet_season/Wet_season_composite_PNCM-2020.tif')

#dry1985 <- brick('data/raster/Dry_season/Dry_season_composite_PNCM-1985.tif')
#dry2005 <- brick('data/raster/Dry_season/Dry_season_composite_PNCM-2005.tif')
dry2020 <- brick('data/raster/Dry_season/Dry_season_composite_PNCM-2020.tif')


# Cubo de Dados somente com as bandas espectrais do Landsat

#img <- subset(wet2005, c("B1", "B2", "B3", "B4", "B5", "B7"))
img <- subset(wet2020, c("B2", "B3", "B4", "B5", "B6", "B7"))

names(img) = c("B1_wet", "B2_wet", "B3_wet", "B4_wet", "B5_wet", 
               "B7_wet")

#img1 <- subset(dry2005, c("B1", "B2", "B3", "B4", "B5", "B7"))
img1 <- subset(dry2020, c("B2", "B3", "B4", "B5", "B6", "B7"))

names(img1) = c("B1_dry", "B2_dry", "B3_dry", "B4_dry", "B5_dry", 
                "B7_dry")

dry_wet <- stack(img, img1)
names(dry_wet)
#dry_wet2 <- dry_wet*0.0001 + (-0.2) 



img_1 <- brick('data/raster/1985/pncm_1985_clip_uint16.tif')
img_2 <- brick('data/raster/1985/pncm_1985_uint16bit_b20.tif')
dem <- raster('data/raster/DEM_Alos_V3_2_ret_envol_2/Elevation_Alos3D-V3_2_30m_clip.tif')

plot(img_1)
plot(img_2)
plot(dem)

cubo_all <- stack(img_1, dem)
plot(cubo_all)

writeRaster(cubo_all, 'data/raster/1985/stack_1985.tif', 
            format='GTiff',
            datatype='INT2U',
            overwrite=TRUE)

# Apply the scaling factors to the appropriate bands.
# .multiply(0.0000275).add(-0.2) (Landsat 8)
# .multiply(0.0001).add(-0.2) (Landsat 5)

# Salvando imagens

#writeRaster(dry_wet, 'data/raster/1985/pncm_1985_ok.tif', overwrite=T)

#writeRaster(dry_wet, 'data/raster/1995/pncm_1995_ok.tif', overwrite=T)

#writeRaster(dry_wet, 'data/raster/2005/pncm_2005_ok.tif', overwrite=T)

#writeRaster(dry_wet, 'data/raster/2015/pncm_2015_ok.tif', overwrite=T)

writeRaster(dry_wet, 'data/raster/2020/pncm_2020_ok.tif', overwrite=T)

########
map_data <- raster("data/raster/1985/result_class_1985_bnds-dsm.tif")
#Index_vs_Index_isEvent(img_2$pncm_1985_uint16bit_b20_7, len map_data$class_names)

###########
#----
# Carregando pacotes
#install.packages("gdalcubes")
pacman::p_load(rstac, gdalcubes, terra)

#----
# Trabalhando dados
s_obj <- stac("https://planetarycomputer.microsoft.com/api/stac/v1")
#stac("https://brazildatacube.dpi.inpe.br/stac/"

datas <- c(paste('2021-06-01', '2021-06-30', sep='/'))
bbox()
it_obj <- s_obj %>% 
  stac_search(collections = 'sentinel-2-12a',
              bbox = c(-47.42378, -7.361778, -46.74334, -6.894825), #xmin,ymin,xmax,ymax
  )
