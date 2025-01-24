file.choose()
RUTACSV="C:\\Users\\Katya\\OneDrive - Grupo Educad\\DATAA\\S20-10\\SEMANA 2\\23-01--25\\base-de-datos-mets-opt_cleaned_finalMEL23-01.csv"
data <- read.csv(RUTACSV, fileEncoding = "latin1")
names(data)

# Usar el nombre correcto de la columna
frecuencias <- table(data$PERFIL.MOLECULAR) # Cambiar a PERFIL.MOLECULAR
print(frecuencias)

# Generar el gráfico de barras
barplot(frecuencias, 
        col = heat.colors(12), 
        main = "Distribución de PERFIL MOLECULAR", 
        xlab = "Perfil", 
        ylab = "Frecuencia")

#codigo para el gif
# Instalar y cargar paquetes necesarios
library(ggplot2)
library(gganimate)
library(gifski)

# Convertir las frecuencias a un data frame para ggplot2
frecuencias_df <- as.data.frame(frecuencias)
names(frecuencias_df) <- c("Perfil", "Frecuencia")

# Crear el gráfico con gganimate
p <- ggplot(frecuencias_df, aes(x = Perfil, y = Frecuencia, fill = Perfil)) +
  geom_bar(stat = "identity") +
  scale_fill_viridis_d() + # Colores agradables
  labs(
    title = "Evolución de las frecuencias por Perfil Molecular",
    x = "Perfil Molecular",
    y = "Frecuencia"
  ) +
  theme_minimal() +
  transition_states(
    states = Perfil, 
    transition_length = 2, 
    state_length = 1
  ) +
  enter_fade() +
  exit_shrink() +
  ease_aes('sine-in-out')

# Guardar el GIF
animate(
  p, 
  nframes = 50, # Número de cuadros
  duration = 5, # Duración en segundos
  width = 800, 
  height = 600, 
  renderer = gifski_renderer("frecuencias.gif")
)

# Verifica que el GIF se haya guardado en tu directorio de trabajo



#GRAFICO 3
#### Gráfico 3: Relación entre Tamaño de Tumor y Edad
names(data)
# Verificar los nombres de las columnas
colnames(data)


# Gráfico 3: Relación entre Tamaño del Tumor y Edad
relacion_tumor_edad <- ggplot(data, aes(x = TAMAÑO..mm., y = EDAD )) +
  geom_point(alpha = 0.6, color = "blue") +   # Puntos de dispersión
  geom_smooth(method = "lm", color = "red") + # Línea de regresión lineal
  labs(
    title = "Relación entre Edad y Tamaño del Tumor Secundario",
    x = "Edad (años)",
    y = "Tamaño del Tumor Secundario (mm)"
  ) +
  theme_minimal()

