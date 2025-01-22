file.choose()
RUTACSV="/cloud/project/base-de-datos-mets-opt_cleaned170125.csv"
data <- read.csv(RUTACSV, fileEncoding = "latin1")
head(data)
dim(data)
summary(data)
colnames(data)
str(data$`TAMAÑO..mm.`)
# Convertir a numérico
data$`TAMAÑO..mm.` <- as.numeric(data$`TAMAÑO..mm.`)
# Filtrar los datos para que solo contengan "Cáncer de Mama" y "Cáncer de Pulmón"
data_filtrada <- subset(data, `TUMOR.PRIMARIO` %in% c("CANCER DE MAMA", "CANCER DE PULMON"))

# Crear el boxplot con los datos filtrados
boxplot(data_filtrada$`TAMAÑO..mm.` ~ data_filtrada$`TUMOR.PRIMARIO`,
        main = "Tamaño según Tumor Primario",
        ylab = "Tamaño (mm)",
        names = c("Cáncer de Mama", "Cáncer de Pulmón"),col = "pink", border = "purple", horizontal= T)

data_filtrada1 <- subset(data, `TUMOR.PRIMARIO` %in% c("CANCER DE MAMA", "CANCER DE PULMON","CANCER RENAL"))
boxplot(data_filtrada1$`TAMAÑO..mm.` ~ data_filtrada1$`TUMOR.PRIMARIO`,main = "Tamaño según Tumor Primario", ylab = "Tamaño (mm)",xlab = "Tumor primario",col = rainbow(3, alpha=0.2),border = rainbow(3, v=0.6),horizontal = T)

boxplot(data_filtrada1$`TAMAÑO..mm.` ~ data_filtrada1$`TUMOR.PRIMARIO`,main = "Tamaño según Tumor Primario", ylab = "Tamaño (mm)",xlab = "Tumor primario",col = rainbow(3, alpha=0.2),border = rainbow(3, v=0.6))

a <- rainbow(3)
b <- rainbow(3, alpha=0.2)
c <- rainbow(3, v=0.5)

# Crear el boxplot
boxplot(data_filtrada1$`TAMAÑO..mm.` ~ data_filtrada1$`TUMOR.PRIMARIO`,
main = "Tamaño según Tumor Primario",
ylab = "Tamaño (mm)",
xlab = "Tumor primario",
col = rainbow(3, alpha = 0.2),
border = rainbow(3, v = 0.6),
horizontal = TRUE)
       
# Agregar la leyenda correctamente
legend("topright", 
title = "Tumor Primario", 
legend = c("Cáncer de Mama", "Cáncer de Pulmón", "Cáncer Renal"),
fill = rainbow(3, alpha = 0.2),
border = rainbow(3, v = 0.6))

#con boxplot vertical
# Crear el boxplot
boxplot(data_filtrada1$`TAMAÑO..mm.` ~ data_filtrada1$`TUMOR.PRIMARIO`,
main = "Tamaño según Tumor Primario",
ylab = "Tamaño (mm)",
xlab = "Tumor primario",
col = rainbow(3, alpha = 0.2),
border = rainbow(3, v = 0.6))


legend("topright", 
title = "Tumor Primario", 
legend = c("Cáncer de Mama", "Cáncer de Pulmón", "Cáncer Renal"),
fill = rainbow(3, alpha = 0.2),
border = rainbow(3, v = 0.6),
cex = 0.6,   # Reduce el tamaño del texto
pt.cex = 0.5)   # Ajusta el tamaño de los cuadros de color



# Crear el boxplot sin etiquetas en el eje X
boxplot(data_filtrada1$`TAMAÑO..mm.` ~ data_filtrada1$`TUMOR.PRIMARIO`,
        main = "Tamaño según Tumor Primario",
        ylab = "Tamaño (mm)",
        xlab = "Tumor primario",
        col = rainbow(3, alpha = 0.2),
        border = rainbow(3, v = 0.6),
        axes = FALSE)  # No dibujar las etiquetas en el eje X

# Agregar las etiquetas personalizadas en el eje X
axis(1, at = 1:3, labels = c("Cáncer de Mama", "Cáncer de Pulmón", "Cáncer Renal"))

# Agregar la leyenda con un tamaño más pequeño
legend("topright", 
       title = "Tumor Primario", 
       legend = c("Cáncer de Mama", "Cáncer de Pulmón", "Cáncer Renal"),
       fill = rainbow(3, alpha = 0.2),
       border = rainbow(3, v = 0.6),
       cex = 0.8,   # Reduce el tamaño del texto
       pt.cex = 1)   # Ajusta el tamaño de los cuadros de color


# Crear el boxplot sin etiquetas en el eje X
boxplot(data_filtrada1$`TAMAÑO..mm.` ~ data_filtrada1$`TUMOR.PRIMARIO`,
        main = "Tamaño según Tumor Primario",
        ylab = "Tamaño (mm)",
        xlab = "Tumor primario",
        col = rainbow(3, alpha = 0.2),
        border = rainbow(3, v = 0.6),
        axes = FALSE)  # No dibujar las etiquetas en el eje X

# Agregar las etiquetas personalizadas en el eje X con tamaño de texto reducido
axis(1, at = 1:3, labels = c("Cáncer de Mama", "Cáncer de Pulmón", "Cáncer Renal"), cex.axis = 0.8)

# Agregar la leyenda con un tamaño más pequeño
legend("topright", 
       title = "Tumor Primario", 
       legend = c("Cáncer de Mama", "Cáncer de Pulmón", "Cáncer Renal"),
       fill = rainbow(3, alpha = 0.2),
       border = rainbow(3, v = 0.6),
       cex = 0.6,   # Reduce el tamaño del texto
       pt.cex = 1)   # Ajusta el tamaño de los cuadros de color


# Crear el boxplot sin etiquetas en el eje X
boxplot(data_filtrada1$`TAMAÑO..mm.` ~ data_filtrada1$`TUMOR.PRIMARIO`,
        main = "Tamaño según Tumor Primario",
        ylab = "Tamaño (mm)",
        xlab = "Tumor primario",
        col = rainbow(3, alpha = 0.2),
        border = rainbow(3, v = 0.6),
        axes = FALSE)  # No dibujar las etiquetas en el eje X

# Agregar el eje Y (sin cambiarlo)
axis(2)

# Agregar las etiquetas personalizadas en el eje X con tamaño de texto reducido
axis(1, at = 1:3, labels = c("Cáncer de Mama", "Cáncer de Pulmón", "Cáncer Renal"), cex.axis = 0.8)

# Agregar la leyenda con un tamaño más pequeño
legend("topright", 
       title = "Tumor Primario", 
       legend = c("Cáncer de Mama", "Cáncer de Pulmón", "Cáncer Renal"),
       fill = rainbow(3, alpha = 0.2),
       border = rainbow(3, v = 0.6),
       cex = 0.5,   # Reduce el tamaño del texto
       pt.cex = 1)   # Ajusta el tamaño de los cuadros de color


#========================#
#   Gráfico de mosaico   #
#========================#
#Los gráficos en mosaico ilustran relaciones
#Con dos variables, el ancho de las columnas es proporcional al número de observaciones 
#de cada nivel de la misma representadas en el eje horizontal. La vertical de las barras 
#es proporcional al número de la segunda variable en cada nivel de la primera.

mosaicplot(TAMAÑO..mm ~ LOCALIZACION,
           col=2:5,
           main="Tamaño según Tumor Primario",
           xlab="Localizacion",
           ylab="Tamaño (mm)",
           cex.axis=.5,
           las=1)

# Convertir `TAMAÑO..mm.` en categorías (bins)
data$TAMAÑO_CAT <- cut(as.numeric(data$`TAMAÑO..mm.`),
                       breaks = c(0, 10, 30, 50, Inf),
                       labels = c("0-10 mm", "10-30 mm", "30-50 mm", ">50 mm"),
                       include.lowest = TRUE)

# Crear el mosaicplot
mosaicplot(data$TAMAÑO_CAT ~ data$LOCALIZACION,
           col = rainbow(4, alpha = 0.6),
           main = "Distribución del Tamaño por Localización",
           xlab = "Localización",
           ylab = "Categorías de Tamaño",
           cex.axis = 0.6,
           las = 1)  # Orientación vertical de etiquetas


library(ggplot2)
library(gganimate)
library(dplyr)

# Agrupar y calcular frecuencias
data_summary <- data %>%
  group_by(LOCALIZACION, TAMAÑO_CAT) %>%
  summarise(Frecuencia = n()) %>%
  ungroup()

# Crear el gráfico base
base_plot <- ggplot(data_summary, aes(x = LOCALIZACION, y = Frecuencia, fill = TAMAÑO_CAT)) +
  geom_bar(stat = "identity", position = "fill", alpha = 0.8) +  # Gráfico de barras apiladas
  scale_fill_brewer(palette = "Set3") +  # Paleta de colores
  labs(title = "Distribución del Tamaño por Localización - Año: {closest_state}",
       x = "Localización",
       y = "Proporción",
       fill = "Tamaño (mm)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Simulación de una variable de tiempo
data_summary <- data_summary %>%
  mutate(Año = rep(2000:2005, length.out = n()))  # Ejemplo de años

# Agregar animación
animated_plot <- base_plot +
  transition_states(Año, transition_length = 2, state_length = 1) +
  ease_aes('cubic-in-out')  # Suavizado de la animación

# Guardar como GIF
anim_save("animacion_mosaicplot.gif", animate(animated_plot, duration = 10, fps = 20, width = 800, height = 600))


animate(animated_plot, duration = 10, fps = 20, width = 800, height = 600)

install.packages(c("gganimate", "ggplot2", "gifski", "transformr"))

packageVersion("gganimate")
packageVersion("gifski")
packageVersion("transformr")

rm(list = ls())
gc()  # Forzar la recolección de memoria

library(ggplot2)
library(gganimate)
library(dplyr)







