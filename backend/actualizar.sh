#!/bin/bash

# Configuración del repositorio y del contenedor
REPO_URL="https://github.com/LiquorStore-APP/liquor-store-api.git"
CONTAINER_NAME="liquor-backend"
IMAGE_NAME="backend-liquor-backend"
SCRIPT_TO_EXECUTE="F:/DOCUMENTOS/LiquorStore-APP/liquor-store-deploy-utils/backend/desplegar.sh"

# Archivo temporal para almacenar el hash del último commit conocido
LAST_COMMIT_FILE="/tmp/last_commit_hash2.txt"

# Función para verificar si hubo un commit reciente
check_recent_commit() {
    # Obtiene el hash del último commit remoto
    LAST_COMMIT_REMOTE=$(git ls-remote "$REPO_URL" HEAD | awk '{print $1}')

    # Comprueba si existe un archivo con el último commit conocido
    if [ -f "$LAST_COMMIT_FILE" ]; then
        LAST_COMMIT_KNOWN=$(cat "$LAST_COMMIT_FILE")
    else
        LAST_COMMIT_KNOWN=""
    fi

    # Compara el hash actual con el conocido
    if [ "$LAST_COMMIT_REMOTE" != "$LAST_COMMIT_KNOWN" ]; then
        # Actualiza el archivo con el nuevo hash
        echo "$LAST_COMMIT_REMOTE" > "$LAST_COMMIT_FILE"
        return 0
    else
        return 1
    fi
}

# Bucle infinito que ejecuta la verificación cada 2 minutos
while true; do
    if check_recent_commit; then
        echo "Se detectó un commit reciente. Ejecutando acciones..."

        # Elimina el contenedor
        docker rm -f "$CONTAINER_NAME"

        # Elimina la imagen
        docker rmi -f "$IMAGE_NAME"

        # Ejecuta el script especificado
        bash "$SCRIPT_TO_EXECUTE"
    else
        echo "No se detectaron commits recientes."
    fi

    # Espera 2 minutos antes de la próxima verificación
    sleep 120
done