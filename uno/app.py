import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Configuración inicial de la aplicación
st.title("Análisis Exploratorio de Datos")
st.write("Esta aplicación realiza análisis descriptivo y visual de un archivo CSV.")

# Subida del archivo
uploaded_file = st.file_uploader("Sube un archivo CSV", type=["csv"])

if uploaded_file is not None:
    # Leer archivo
    datos = pd.read_csv(uploaded_file, encoding="latin1")
    st.write("Datos cargados:")
    st.write(datos.head())
    
    # Mostrar información general de los datos
    st.write("Información general del dataset:")
    st.write(datos.describe(include="all"))
    
    # Limpieza de valores nulos
    st.write("Rellenando valores nulos...")
    datos.fillna(datos.mean(numeric_only=True), inplace=True)
    datos.fillna("Desconocido", inplace=True)
    st.write("Valores nulos rellenados.")

    # Columnas categóricas y numéricas
    columnas_categoricas = datos.select_dtypes(include=["object", "category"]).columns
    columnas_numericas = datos.select_dtypes(include=["number"]).columns

    st.write("Columnas categóricas detectadas:", list(columnas_categoricas))
    st.write("Columnas numéricas detectadas:", list(columnas_numericas))

    # Análisis para columnas categóricas
    if len(columnas_categoricas) > 0:
        st.subheader("Análisis de columnas categóricas")
        for col in columnas_categoricas:
            st.write(f"### Análisis de la columna '{col}'")
            conteo = datos[col].value_counts()
            st.write(conteo)

            # Gráfico de barras
            fig, ax = plt.subplots()
            conteo.plot(kind="bar", ax=ax, color="skyblue")
            ax.set_title(f"Distribución de {col}")
            ax.set_xlabel(col)
            ax.set_ylabel("Frecuencia")
            st.pyplot(fig)

    # Análisis para columnas numéricas
    if len(columnas_numericas) > 0:
        st.subheader("Análisis de columnas numéricas")
        for col in columnas_numericas:
            st.write(f"### Análisis de la columna '{col}'")
            st.write(datos[col].describe())

            # Histograma
            fig, ax = plt.subplots()
            sns.histplot(datos[col], kde=True, ax=ax, color="skyblue")
            ax.set_title(f"Distribución de {col}")
            ax.set_xlabel(col)
            ax.set_ylabel("Frecuencia")
            st.pyplot(fig)

            # Boxplot para detección de outliers
            fig, ax = plt.subplots()
            sns.boxplot(x=datos[col], ax=ax, color="lightgreen")
            ax.set_title(f"Boxplot de {col}")
            st.pyplot(fig)

    # Análisis de relaciones entre columnas numéricas
    if len(columnas_numericas) > 1:
        st.subheader("Análisis de relaciones entre columnas numéricas")
        st.write("### Matriz de correlación:")
        correlacion = datos[columnas_numericas].corr()
        st.write(correlacion)

        # Mapa de calor
        fig, ax = plt.subplots(figsize=(10, 6))
        sns.heatmap(correlacion, annot=True, cmap="coolwarm", ax=ax)
        ax.set_title("Mapa de calor de correlaciones")
        st.pyplot(fig)

    # Análisis cruzado entre variables categóricas
    if len(columnas_categoricas) > 1:
        st.subheader("Análisis cruzado entre variables categóricas")
        for col1 in columnas_categoricas:
            for col2 in columnas_categoricas:
                if col1 != col2:
                    st.write(f"Relación entre '{col1}' y '{col2}':")
                    tabla = pd.crosstab(datos[col1], datos[col2])
                    st.write(tabla)

                    # Gráfico de calor de la tabla cruzada
                    fig, ax = plt.subplots(figsize=(8, 6))
                    sns.heatmap(tabla, annot=True, fmt="d", cmap="YlGnBu", ax=ax)
                    ax.set_title(f"Gráfico de calor entre {col1} y {col2}")
                    st.pyplot(fig)
else:
    st.write("Por favor, sube un archivo CSV para comenzar.")
