#iniciando en script limpio
RUTACSV="/cloud/project/base-de-datos-mets-opt_cleaned170125.csv"
data <- read.csv(RUTACSV, fileEncoding = "latin1")
head(data)

# Instalar y cargar las librerías necesarias
install.packages(c("ggplot2", "gganimate", "dplyr", "gifski", "transformr"))
library(ggplot2)
library(gganimate)
library(dplyr)
install.packages("dplyr")  # Instala el paquete (si no está ya instalado)
library(dplyr)             # Carga el paquete en tu sesión


# 1. Cargar la data desde el archivo CSV
RUTACSV <- "/cloud/project/base-de-datos-mets-opt_cleaned170125.csv"
data <- read.csv(RUTACSV, fileEncoding = "latin1")

# 2. Revisar la estructura de la data
str(data)  # Para confirmar columnas disponibles

#2.1
unique(data$TAMAÑO..mm.)  # Muestra todos los valores únicos de la columna
data$TAMAÑO..mm. <- gsub(",", ".", data$TAMAÑO..mm.)  # Cambiar comas por puntos
data$TAMAÑO..mm. <- gsub("[^0-9.]", "", data$TAMAÑO..mm.)  # Eliminar caracteres no numéricos
data$TAMAÑO..mm. <- as.numeric(data$TAMAÑO..mm.)
sum(is.na(data$TAMAÑO..mm.))  # Cuenta los valores NA en la columna
data <- data %>% filter(!is.na(TAMAÑO..mm.)) #eliminando el 1 valor NA




# 3. Convertir `TAMAÑO..mm.` en categorías (bins)
data <- data %>%
  mutate(
    TAMAÑO_CAT = cut(
      as.numeric(TAMAÑO..mm.),
      breaks = c(0, 10, 30, 50, Inf),
      labels = c("0-10 mm", "10-30 mm", "30-50 mm", ">50 mm"),
      include.lowest = TRUE
    )
  )

# 4. Crear un resumen de datos para el gráfico
data_summary <- data %>%
  group_by(LOCALIZACION, TAMAÑO_CAT) %>%
  summarise(Frecuencia = n(), .groups = "drop") %>%
  mutate(Año = sample(2015:2024, n(), replace = TRUE))  # Asignar años aleatorios si no hay columna Año

# 5. Crear el gráfico base con ggplot2
base_plot <- ggplot(data_summary, aes(x = LOCALIZACION, y = Frecuencia, fill = TAMAÑO_CAT)) +
  geom_bar(stat = "identity", position = "fill", alpha = 0.8) +
  labs(
    title = "Distribución del Tamaño por Localización ({closest_state})",
    x = "Localización",
    y = "Proporción",
    fill = "Tamaño (mm)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#5.1
install.packages("ggplot2")
library(ggplot2)
head(data_summary)
str(data_summary)
base_plot <- ggplot(data_summary, aes(x = LOCALIZACION, y = Frecuencia, fill = TAMAÑO_CAT)) +
  geom_bar(stat = "identity", position = "fill", alpha = 0.8) +
  labs(
    title = "Distribución del Tamaño por Localización ({closest_state})",
    x = "Localización",
    y = "Proporción",
    fill = "Tamaño (mm)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
base_plot


# 6. Añadir animación con gganimate
animated_plot <- base_plot +
  transition_states(
    Año,
    transition_length = 2,
    state_length = 1
  ) +
  ease_aes('linear')
#6.1
install.packages("gganimate")
library(gganimate)
animated_plot <- base_plot +
  transition_states(
    TAMAÑO..mm.,  # Asegúrate de que "Año" sea una variable en tu conjunto de datos
    transition_length = 2,
    state_length = 1
  ) +
  ease_aes('linear')
head(data_summary)

class(animated_plot)
str(data_summary)
data_summary$Año <- as.factor(data_summary$Año)

animated_plot <- base_plot +
  transition_states(
    states = Año, 
    transition_length = 2, 
    state_length = 1
  ) +
  ease_aes('linear') +
  enter_fade() +  # Esto añade un efecto de entrada
  exit_fade()     # Esto añade un efecto de salida
class(animated_plot)
anim_save("animacion_mosaicplot.gif", animated_plot)



anim_save("animacion_mosaicplot.gif", animated_plot, duration = 10, fps = 20, width = 800, height = 600)


# 7. Animar y guardar el gráfico
anim <- animate(animated_plot, duration = 10, fps = 20, width = 800, height = 600)
anim_save("/cloud/project/animacion_mosaicplot.gif", animation = anim)

# 8. Mensaje de confirmación
cat("La animación se guardó como 'animacion_mosaicplot.gif' en tu directorio de trabajo.\n")

library(magick)
anim <- image_read("animacion_mosaicplot.gif")
print(anim)
