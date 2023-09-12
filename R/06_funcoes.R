# criando função NDVI

# Esta função leva como entrada as imagens das bandas de vermelho (red_band) e 
# infravermelho próximo (nir_band) como arquivos raster. Em seguida, 
# a função converte as bandas em reflectância, que é uma unidade comum usada 
# em imagens de satélite. Em seguida, a função calcula o NDVI a partir das bandas 
# convertidas e retorna o resultado como um arquivo raster.
# 
# Para utilizar esta função em um conjunto de dados de imagens de satélite, você 
# pode chamar a função para cada par de bandas de vermelho e infravermelho próximo
# em seu conjunto de dados.

calc_ndvi <- function(red_band, nir_band, plot_result = TRUE) {
  # Carregando as bandas de vermelho e infravermelho próximo como raster
  red_raster <- raster(red_band)
  nir_raster <- raster(nir_band)
  
  # Convertendo as bandas para reflectância
  red_refl <- red_raster * 0.0001
  nir_refl <- nir_raster * 0.0001
  
  # Calculando o NDVI
  ndvi <- (nir_refl - red_refl) / (nir_refl + red_refl)
  
  # Plotando o resultado, se plot_result for TRUE
  if (plot_result) {
    plot(ndvi, main = "NDVI")
  }
  
  # Retornando o NDVI como um raster
  return(ndvi)
  
  
}
