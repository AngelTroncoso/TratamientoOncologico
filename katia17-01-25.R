file.choose()
RUTACSV="C:\\Users\\Katya\\OneDrive - Grupo Educad\\DATAA\\S20-10\\17-1-25\\base-de-datos-mets-opt_cleaned170125.csv"
data <- read.csv(RUTACSV, fileEncoding = "latin1")
head(data) #breve inf ode la data
View(data)
summary(data) #pqueno resumen de nuestras variables
dim(data) #arroja la cant de filas y columnas
names(data) #arroja el nombre de la variable
data$EDAD
hist(data$EDAD) #histograma de la variable EDAD
attach(data) #para acceder directamente a las variables ( d las columnas)
mean(EDAD)
sd(EDAD)
#arreglando la grafica del histograma
#vamos a modificar el rango de los valores de los ejes "x" e "y"
hist(EDAD,
     breaks = 20,
     main = "Distribución de Edades de los pacientes", 
     xlab = "Edad",             
     ylab = "Número de pacientes",
     xlim = c(0,100),                     
     col = "turquoise4",                       
     border = "white"                     
)
#vamos a representar con la frecuencia relativa en vez de la absoluta
#==============================================
hist(EDAD,
     breaks = 20, 
     main = "Distribución Edades de los pacientes", 
     freq = FALSE,                  # frecuencias relativas (en tanto por uno)
     xlab = "Edad",                                         
     ylab = "Frecuencia relativa (en tanto por uno)",  
     xlim = c(0,100), 
     ylim =c (0,0.08),          
     col = "turquoise4",
     border = "white" 
)
#Agregando curva de la distribucion
hist(EDAD,
     breaks = 20,   
     main = "Distribución de Edades de los pacientes", 
     freq = FALSE,
     xlab = "Edad",                                          
     ylab = "Frecuencia relativa", 
     xlim = c(0,100),
     ylim = c(0,0.08),
     col = "turquoise4",
     border = "white"
)

curve(dnorm(x, mean=mean(EDAD), sd=sd(EDAD)), add=TRUE, col="black", lwd=3) 
abline(v=mean(EDAD), lwd=2, lty=3, col="yellow")    # añadimos posición de la media.


