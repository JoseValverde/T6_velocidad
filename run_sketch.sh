#!/bin/bash

# Script para ejecutar el sketch de Processing T6_velocidad
# Este script detecta la instalación de Processing y ejecuta el sketch

# Función para encontrar la ruta de instalación de Processing
find_processing() {
  if [ -d "/Applications/Processing.app" ]; then
    echo "/Applications/Processing.app"
    return 0
  fi
  
  # Buscar en otras ubicaciones comunes
  local processing_path=$(find /Applications -maxdepth 2 -name "Processing*.app" -type d 2>/dev/null | head -n 1)
  if [ -n "$processing_path" ]; then
    echo "$processing_path"
    return 0
  fi
  
  return 1
}

# Obtener la ruta de Processing
PROCESSING_APP=$(find_processing)

if [ $? -ne 0 ]; then
  echo "Error: No se pudo encontrar la aplicación Processing."
  exit 1
fi

echo "Encontrada la instalación de Processing en: $PROCESSING_APP"

# Definir la ruta del sketch
SKETCH_PATH="$(cd "$(dirname "$0")" && pwd)"

# Método 1: Intentar abrir directamente en Processing (más confiable)
echo "Abriendo el sketch en Processing..."
open -a "$PROCESSING_APP" "$SKETCH_PATH/T6_velocidad.pde"

exit 0

# Método 2: Intentar con processing-java (alternativa si el método 1 falla)
# Descomentar las siguientes líneas si prefieres este método

# PROCESSING_JAVA_PATHS=(
#   "$PROCESSING_APP/Contents/Processing/processing-java"
#   "$PROCESSING_APP/Contents/Java/processing-java"
#   "$PROCESSING_APP/Contents/Resources/Java/processing-java"
# )

# for PROCESSING_JAVA in "${PROCESSING_JAVA_PATHS[@]}"; do
#   if [ -x "$PROCESSING_JAVA" ]; then
#     echo "Ejecutando con $PROCESSING_JAVA..."
#     "$PROCESSING_JAVA" --sketch="$SKETCH_PATH" --run
#     exit $?
#   fi
# done

# echo "Error: No se pudo encontrar el ejecutable processing-java."
# exit 1