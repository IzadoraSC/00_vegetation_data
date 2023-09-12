## Reamostragem de tamanho de pixel no R ##

library(terra)

## Selecionar a imagem

# carregando imagem
img <- rast('outputs/Wet_season_composite_PNCM-1985_crop.tif')

# Selecionar uma banda

NIR = subset(img, "B4")


## Diminuir o tamanho do pixel (ou seja, valores MAIORES)

NIR.90m = aggregate(NIR, fact = 3, fun = 'mean')
NIR.300m = aggregate(NIR, fact = 10, fun = 'mean')
NIR.3000m = aggregate(NIR, fact = 100, fun = 'mean')

# ver a diferença

par(mfrow=c(2,2))

plot(NIR, col = grey.colors(100), main = "NIR - 30m")
plot(NIR.90m, col = grey.colors(100), main = "NIR - 90m")
plot(NIR.300m, col = grey.colors(100), main = "NIR - 300m")
plot(NIR.3000m, col = grey.colors(100), main = "NIR - 3000m")

## Situação 

# 2 imagens com tamanho de pixel diferentes. 

NIR.90m_30m_new = project(x = NIR.90m, y = NIR)

par(mfrow=c(1,2))
plot(NIR, col = grey.colors(100), main = "NIR - 30m")
plot(NIR.90m_30m_new, col = grey.colors(100), main = "NIR - 90m para 30m")

## Aumento o tamanho do pixel (ou seja, valores menores)

nir.15m = disagg(NIR, fact = 2, method = 'near')
