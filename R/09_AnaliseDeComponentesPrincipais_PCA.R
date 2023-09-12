## Analise de Componentes Principais (PCA)
library(ggplot2)
library(reshape2)
library(RStoolbox)
data(rlogo)
rlogo <- brick('data/raster/1985/stack_1985.tif')
ggRGB(rlogo, 3,2,1)

## Run PCA
set.seed(25)
rpc <- rasterPCA(rlogo)
rpc

## Model parameters:
summary(rpc$model)
loadings(rpc$model)

ggRGB(rpc$map,1,2,3, stretch="lin", q=0)
if(require(gridExtra)){
  plots <- lapply(1:3, function(x) ggR(rpc$map, x, geom_raster = TRUE))
  grid.arrange(plots[[1]],plots[[2]], plots[[3]], ncol=2)
}
