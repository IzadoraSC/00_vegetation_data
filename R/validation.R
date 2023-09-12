# https://github.com/EcoDyn/rsacc

# Install package
#install.packages("devtools")

#library(devtools)
# devtools::install_github("EcoDyn/rsacc")
# remotes::install_github('https://github.com/EcoDyn/rsacc')


library(raster)
library(rsacc)
library(RStoolbox)
library(ggplot2)

#remotes::install_github("bleutner/RStoolbox")






#setwd("F:/00_Classificacao/")

# read in classification data

#map_data <- raster("F:/00_Classificacao/class_pncm2_raster.tif")
#map_data <- raster("F:/00_Classificacao/class_pncm.tif")
map_data <- raster("data/raster/1985/result_class_1985_bnds-dsm.tif")
#map_data <- raster("data/classif/reclass_20_rep.tif")
plot(map_data)

# read in validation data

#val_polygon <- shapefile("F:/00_Classificacao/shape_valid2.shp")
val_polygon <- shapefile('C:/Users/User/Documents/GitHub/classification_vegetation/python/shapefiles_validation_antigo/shape_valid2.shp')
val_polygon <- shapefile('data/shp/1985/amostras_1985_ok.shp')
#val_polygon <- shapefile("data/classif/validacao.shp")
plot(val_polygon, add=T)
dplyr::glimpse(val_polygon)

# Build confusion matrix. 
# Use reproj=T if projections are different.
# Since validation data is a Spatial object, we need to specify the class field name


cmat <- conf_mat(map_data,val_polygon,reproj=T,val_field="Class",na_val=0,use_extract=T)
#cmat <- conf_mat(map_data,val_polygon,reproj=F,val_field="reclass")

cmat

#deletando nodata (se tiver)
#cmat2 <- cmat[-1,]

#mapvals

#kia(cmat2)
kia(cmat)

pontius(cmat)
