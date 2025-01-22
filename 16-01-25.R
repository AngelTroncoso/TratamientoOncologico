RUTACSV <- "/cloud/project/base-de-datos-mets-opt_cleaned.csv"
library(readr)
data <- read_csv(RUTACSV, locale = locale(encoding = "latin1"))#El UTF-8 no fx
# Ver las primeras filas del dataset
head(data)

# Ver el resumen estadístico de los datos
summary(data)

# Ver nombres de columnas
colnames(data)
#Eliminar el mensaje de columna (opcional)
data <- read_csv(RUTACSV, locale = locale(encoding = "latin1"), show_col_types = FALSE)
#Identificar posibles problemas en las columnas
data <- read_csv(RUTACSV, locale = locale(encoding = "latin1"), col_types = cols(
  EXPEDIENTE = col_character(),
  SEXO = col_character(),
  EDAD = col_double(),
  DOSIS_Gy = col_double(),
  RESPUESTA_BINARIA = col_double()
))
write_csv(data, "datos_limpios160125.csv")

#Con archivo limpio ahora
# Cargar librerías necesarias
install.packages(c("readr", "dplyr", "ggplot2", "caret", "randomForest", "pROC"))
library(readr)
library(dplyr)
library(ggplot2)
library(caret)
library(randomForest)
library(pROC)

# Cargar el archivo limpio
RUTACSV <- "/cloud/project/datoslimpios160125.csv"
data <- read_csv(RUTACSV, locale = locale(encoding = "latin1"), show_col_types = FALSE)

# Inspección inicial de los datos
glimpse(data)  # Vista general de las variables
summary(data)  # Resumen estadístico básico

# Verificar valores faltantes
cat("Valores faltantes por columna:\n")
print(colSums(is.na(data)))

# Verificar duplicados
cat("Número de filas duplicadas:\n")
print(sum(duplicated(data)))

# Verificar posibles valores atípicos (por ejemplo, en la variable EDAD)
ggplot(data, aes(y = EDAD)) +
  geom_boxplot(fill = "blue", outlier.color = "red") +
  labs(title = "Boxplot de Edad", y = "Edad")

install.packages("ggplot2")  # Instala la librería si no está instalada
library(ggplot2)             # Carga la librería para usar ggplot
# Boxplot de la variable EDAD
ggplot(data, aes(y = EDAD)) +
  geom_boxplot(fill = "blue", outlier.color = "red") +
  labs(title = "Boxplot de Edad", y = "Edad")

#ANALISIS ESTADISTICO
# Tablas de contingencia y prueba Chi-cuadrado para variables categóricas
cat("Prueba Chi-cuadrado para SEXO y RESPUESTA_BINARIA:\n")
table_sexo_respuesta <- table(data$SEXO, data$RESPUESTA_BINARIA)
print(chisq.test(table_sexo_respuesta))

cat("\nPrueba Chi-cuadrado para TUMOR_PRIMARIO y RESPUESTA_BINARIA:\n")
table_tumor_respuesta <- table(data$TUMOR_PRIMARIO, data$RESPUESTA_BINARIA)
print(chisq.test(table_tumor_respuesta))

# Comparación de medias (t-test) para variables numéricas según RESPUESTA_BINARIA
cat("\nPrueba t-test para EDAD según RESPUESTA_BINARIA:\n")
print(t.test(data$EDAD ~ data$RESPUESTA_BINARIA))

cat("\nPrueba t-test para DOSIS (Gy) según RESPUESTA_BINARIA:\n")
print(t.test(data$`DOSIS (Gy)` ~ data$RESPUESTA_BINARIA))

# Visualización: Distribución de EDAD según RESPUESTA_BINARIA
ggplot(data, aes(x = RESPUESTA_BINARIA, y = EDAD, fill = RESPUESTA_BINARIA)) +
  geom_boxplot() +
  labs(title = "Distribución de EDAD según RESPUESTA_BINARIA", x = "Respuesta Binaria", y = "Edad")

#MODELOS PREDICTIVOS
# Convertir variables categóricas en factores
data <- data %>%
  mutate(
    SEXO = as.factor(SEXO),
    TUMOR_PRIMARIO = as.factor(TUMOR_PRIMARIO),
    RESPUESTA_BINARIA = as.factor(RESPUESTA_BINARIA)
  )

# Dividir los datos en entrenamiento y prueba (70%-30%)
set.seed(123)
train_index <- createDataPartition(data$RESPUESTA_BINARIA, p = 0.7, list = FALSE)
train_data <- data[train_index, ]
test_data <- data[-train_index, ]

# Modelo de regresión logística
logistic_model <- glm(RESPUESTA_BINARIA ~ EDAD + SEXO + `DOSIS (Gy)` + TUMOR_PRIMARIO, 
                      data = train_data, family = "binomial")
summary(logistic_model)

# Predicciones y evaluación del modelo logístico
logistic_preds <- predict(logistic_model, test_data, type = "response")
logistic_roc <- roc(test_data$RESPUESTA_BINARIA, logistic_preds)
cat("\nAUC del modelo logístico:\n")
print(logistic_roc$auc)

# Modelo Random Forest
rf_model <- randomForest(RESPUESTA_BINARIA ~ EDAD + SEXO + `DOSIS (Gy)` + TUMOR_PRIMARIO, 
                         data = train_data, ntree = 100, importance = TRUE)
rf_preds <- predict(rf_model, test_data, type = "prob")[, 2]
rf_roc <- roc(test_data$RESPUESTA_BINARIA, rf_preds)
cat("\nAUC del modelo Random Forest:\n")
print(rf_roc$auc)

# Importancia de variables en Random Forest
cat("\nImportancia de las variables en Random Forest:\n")
print(varImpPlot(rf_model))
# Ver la importancia de las variables en el modelo Random Forest
varImpPlot(rf_model)


# Ver el objeto rf_model
print(rf_model)

# Cargar el paquete randomForest
library(randomForest)

# Suponiendo que 'data' es tu conjunto de datos limpio y listo para usar
# Asegúrate de que la variable dependiente sea una columna binaria, como 'RESPUESTA_BINARIA'
rf_model <- randomForest(RESPUESTA_BINARIA ~ ., data = data, ntree = 500)

# Ver el modelo
print(rf_model)
# Importancia de las variables en el modelo Random Forest
varImpPlot(rf_model)


