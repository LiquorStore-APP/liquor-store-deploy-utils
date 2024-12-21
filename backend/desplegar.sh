#!/bin/sh

# Configuración de nombres de los repositorios y carpetas locales
REPO1_URL="https://github.com/LiquorStore-APP/liquor-store-api.git"
REPO2_URL="https://github.com/LiquorStore-APP/liquor-store-images.git"

REPO1_DIR="liquor-store-api"
REPO2_DIR="liquor-store-images"
WORKINDIR="/f/DOCUMENTOS/LiquorStore-APP/liquor-store-deploy-utils"

# Función para limpiar repositorios clonados
cleanup() {
    echo ">>> Eliminando los repositorios clonados..."
    rm -rf "$REPO1_DIR" "$REPO2_DIR"
    rm -rf "docker-compose.yml" "Dockerfile" "nginx.conf"

    if [ $? -eq 0 ]; then
        echo "✅ Repositorios eliminados correctamente."
    else
        echo "❌ Error al eliminar los repositorios."
    fi

    echo "🎉 Operación completada con éxito."
}

# Capturar señales EXIT, SIGINT (Ctrl + C) y SIGTERM
trap cleanup EXIT       # Siempre al salir
trap cleanup SIGINT     # Cuando presionas Ctrl + C
trap cleanup SIGTERM    # Para procesos "kill"

# Mensaje de inicio
echo ">>> Clonando los repositorios..."

# Clonar el primer repositorio
git clone $REPO1_URL $REPO1_DIR
if [ $? -eq 0 ]; then
    echo "✅ Repositorio 1 clonado correctamente."
else
    echo "❌ Error al clonar el repositorio 1."
    exit 1
fi

# Clonar el segundo repositorio
git clone $REPO2_URL $REPO2_DIR
if [ $? -eq 0 ]; then
    echo "✅ Repositorio 2 clonado correctamente."
else
    echo "❌ Error al clonar el repositorio 2."
    exit 1
fi

# Mostrar contenido de los repositorios (opcional)
echo ">>> Contenido del repositorio 1:"
ls -la $REPO1_DIR

echo ">>> Contenido del repositorio 2:"
ls -la $REPO2_DIR

pwd
cd $WORKINDIR/backend/liquor-store-images/backend-image/
mv docker-compose.yml $WORKINDIR/backend/
mv Dockerfile $WORKINDIR/backend/
cd $WORKINDIR/backend/
docker-compose -f docker-compose.yml build --no-cache
docker-compose -f  docker-compose.yml up -d