import streamlit as st
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import StandardScaler
from imblearn.over_sampling import SMOTE
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import (
    accuracy_score,
    roc_auc_score,
    classification_report,
    confusion_matrix,
    roc_curve,
    auc
)
# Configurar el título de la app
st.title("Modelo Predictivo Clínico")
st.write("Cargar datos, entrenar un modelo y predecir la respuesta clínica.")

# Paso 1: Carga de datos
st.header("1. Cargar Datos")
uploaded_file = st.file_uploader("Sube tu archivo CSV", type=["csv"])

if uploaded_file:
    # Leer los datos subidos
    data = pd.read_csv(uploaded_file, encoding='latin-1')
    st.write("Vista previa de los datos cargados:")
    st.dataframe(data.head())

# Comparación Gráfica
st.header("Comparación Gráfica")
st.write("Selecciona dos columnas para comparar y el tipo de gráfico a visualizar:")

# Selección de columnas
col1, col2 = st.columns(2)
with col1:
    column_x = st.selectbox("Selecciona la primera columna (X):", data.columns, key="col_x")
with col2:
    column_y = st.selectbox("Selecciona la segunda columna (Y):", data.columns, key="col_y")

# Selección del tipo de gráfico
plot_type = st.selectbox(
    "Selecciona el tipo de gráfico:",
    ["Scatterplot", "Heatmap", "Histograma", "Boxplot"]
)

# Generar el gráfico basado en la selección
if column_x and column_y:
    st.write(f"**Gráfico seleccionado: {plot_type} ({column_x} vs {column_y})**")
    plt.figure(figsize=(10, 6))

    if plot_type == "Scatterplot":
        sns.scatterplot(data=data, x=column_x, y=column_y, hue=column_y, palette="viridis")
        plt.title(f"Scatterplot entre {column_x} y {column_y}")
        plt.xlabel(column_x)
        plt.ylabel(column_y)

    elif plot_type == "Heatmap":
        # Crear una tabla de contingencia
        contingency_table = pd.crosstab(data[column_x], data[column_y])

        # Generar heatmap a partir de la tabla de contingencia
        sns.heatmap(contingency_table, annot=True, fmt="d", cmap="YlGnBu")
        plt.title(f"Heatmap (tabla de contingencia) entre {column_x} y {column_y}")
        plt.xlabel(column_y)
        plt.ylabel(column_x)

    elif plot_type == "Histograma":
        sns.histplot(data[column_x], kde=True, bins=20, color="blue", label=column_x)
        sns.histplot(data[column_y], kde=True, bins=20, color="orange", label=column_y)
        plt.title(f"Histogramas de {column_x} y {column_y}")
        plt.xlabel("Valores")
        plt.ylabel("Frecuencia")
        plt.legend()

    elif plot_type == "Boxplot":
        sns.boxplot(data=data, x=column_x, y=column_y)
        plt.title(f"Boxplot entre {column_x} y {column_y}")
        plt.xlabel(column_x)
        plt.ylabel(column_y)

    st.pyplot(plt)


    # Selección de la variable objetivo
    st.header("2. Selección de Columnas")
    target_col = st.selectbox("Selecciona la variable objetivo (Y):", data.columns)
    feature_cols = st.multiselect("Selecciona las características (X):", [col for col in data.columns if col != target_col])

    if target_col and feature_cols:
        # Paso 2: Preprocesamiento y división de datos
        st.header("3. Entrenamiento del Modelo")
        X = data[feature_cols]
        y = data[target_col]

        # Codificar variables categóricas
        X = pd.get_dummies(X, drop_first=True)

        # División de datos
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

        # Escalar las características numéricas (si es necesario)
        scaler = StandardScaler()
        X_train_scaled = scaler.fit_transform(X_train)
        X_test_scaled = scaler.transform(X_test)

        # Manejar desbalance de clases (si es necesario)
        smote = SMOTE(random_state=42)
        X_train_res, y_train_res = smote.fit_resample(X_train_scaled, y_train)

        # Definir hiperparámetros para Logistic Regression:
        param_grid_lr = {
            'penalty': ['l1', 'l2'],
            'C': [0.1, 1, 10],
            'solver': ['liblinear', 'saga']
        }

        # Crear un objeto GridSearchCV para Logistic Regression:
        grid_search_lr = GridSearchCV(
            estimator=LogisticRegression(random_state=42),
            param_grid=param_grid_lr,
            scoring='accuracy',
            cv=5,
            n_jobs=-1
        )

        # Ajustar a los datos de entrenamiento:
        grid_search_lr.fit(X_train, y_train)

        # Mejores hiperparámetros:
        best_params_lr = grid_search_lr.best_params_

        # Definir hiperparámetros para Decision Tree:
        param_grid_dt = {
            'max_depth': [None, 5, 10, 20],
            'min_samples_split': [2, 5, 10],
            'min_samples_leaf': [1, 2, 4],
            'criterion': ['gini', 'entropy']
        }

        # Crear un objeto GridSearchCV:
        grid_search_dt = GridSearchCV(
            estimator=DecisionTreeClassifier(random_state=42),
            param_grid=param_grid_dt,
            scoring='accuracy',
            cv=5,
            n_jobs=-1
        )

        # Ajustar a los datos de entrenamiento:
        grid_search_dt.fit(X_train, y_train)

        # Mejores hiperparámetros:
        best_params_dt = grid_search_dt.best_params_

        # Definir hiperparámetros para Random Forest:
        param_grid_rf = {
            'n_estimators': [100, 200, 300],
            'max_depth': [None, 5, 10],
            'min_samples_split': [2, 5, 10]
        }

        # Crear un objeto GridSearchCV para Random Forest:
        grid_search_rf = GridSearchCV(
            estimator=RandomForestClassifier(random_state=42),
            param_grid=param_grid_rf,
            scoring='accuracy',
            cv=5,
            n_jobs=-1
        )

        # Ajustar a los datos de entrenamiento:
        grid_search_rf.fit(X_train, y_train)

        # Mejores hiperparámetros:
        best_params_rf = grid_search_rf.best_params_

        # Selección de modelo
        st.write("Selecciona el modelo de aprendizaje:")
        model_choice = st.selectbox("Modelo:", ["Logistic Regression", "Decision Tree", "Random Forest"])

        if model_choice == "Logistic Regression":
            modelo = LogisticRegression(max_iter=1000)
        elif model_choice == "Decision Tree":
            modelo = DecisionTreeClassifier(**best_params_dt, random_state=42)
        elif model_choice == "Random Forest":
            modelo = RandomForestClassifier(**best_params_rf, random_state=42)

        modelo.fit(X_train, y_train)

        # Evaluación del modelo
        y_pred = modelo.predict(X_test)
        y_prob = modelo.predict_proba(X_test)

        accuracy = accuracy_score(y_test, y_pred)
        st.write("**Exactitud del modelo:**", accuracy)

        if len(np.unique(y_test)) > 2:
            # Análisis multiclase
            roc_auc = roc_auc_score(y_test, y_prob, multi_class='ovr')
            st.write("**AUC-ROC (multiclase):**", roc_auc)
        else:
            # Análisis binario
            roc_auc = roc_auc_score(y_test, y_prob[:, 1])
            st.write("**AUC-ROC:**", roc_auc)

            # Curva ROC
            fpr, tpr, _ = roc_curve(y_test, y_prob[:, 1])
            plt.figure()
            plt.plot(fpr, tpr, label=f"ROC curve (area = {roc_auc:.2f})")
            plt.plot([0, 1], [0, 1], "k--")
            plt.xlabel("False Positive Rate")
            plt.ylabel("True Positive Rate")
            plt.title("Curva ROC")
            plt.legend(loc="lower right")
            st.pyplot(plt)

        # Matriz de Confusión
        st.write("**Matriz de Confusión:**")
        cm = confusion_matrix(y_test, y_pred)
        sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', xticklabels=np.unique(y_test), yticklabels=np.unique(y_test))
        plt.xlabel("Predicción")
        plt.ylabel("Verdadero")
        st.pyplot(plt)

        # Mostrar reporte de clasificación
        st.text("Reporte de Clasificación:")
        st.text(classification_report(y_test, y_pred))

        # Paso 3: Predicciones
        st.header("4. Predicción")
        st.write("Sube un archivo con datos para predecir:")
        predict_file = st.file_uploader("Archivo de predicción (CSV):", type=["csv"], key="predict")

        if predict_file:
            predict_data = pd.read_csv(predict_file, encoding='latin-1')
            st.write("Datos cargados para predicción:")
            st.dataframe(predict_data.head())

            # Preprocesar datos de predicción
            predict_data = pd.get_dummies(predict_data, drop_first=True)
            predict_data = predict_data.reindex(columns=X.columns, fill_value=0)

            # Realizar predicciones
            predictions = modelo.predict(predict_data)
            probabilities = modelo.predict_proba(predict_data)

            # Mostrar resultados
            st.write("**Resultados de las predicciones:**")
            result_df = predict_data.copy()
            result_df["Predicción"] = predictions
            result_df["Probabilidad"] = probabilities.max(axis=1)
            st.dataframe(result_df)

            # Descargar resultados
            st.download_button(
                label="Descargar resultados",
                data=result_df.to_csv(index=False).encode('utf-8'),
                file_name="resultados_prediccion.csv",
                mime="text/csv"
            )