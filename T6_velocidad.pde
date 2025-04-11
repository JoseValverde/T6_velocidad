/**
 * Simulación de Vuelo Espacial
 * 
 * Esta animación simula la sensación de avanzar a través del espacio,
 * con círculos que surgen en la distancia y crecen a medida que nos acercamos,
 * creando un efecto de túnel o viaje espacial.
 * 
 * Autor: GitHub Copilot
 * Fecha: 11 de abril de 2025
 */

// Constantes globales
final int MAX_ESTRELLAS = 150;     // Cantidad máxima de estrellas en segundo plano
final int MAX_CIRCULOS = 20;       // Cantidad máxima de círculos en la escena
final float VELOCIDAD_BASE = 2.0;  // Velocidad base de movimiento

// Variables globales
float velocidad;         // Velocidad actual de los objetos
float aceleracion;       // Valor de aceleración/desaceleración
Escena escena;           // Gestor principal de la escena
boolean modoDebug = false; // Para mostrar información de depuración
GestorColores colores;   // Gestor de la paleta de colores (compartido globalmente)

// Configuración inicial
void setup() {
  size(700, 1000, P3D);  // Usamos P3D para mejor rendimiento con muchos objetos
  smooth(4);            // Antialiasing para mejor calidad visual
  frameRate(60);        // Intentamos mantener 60fps
  
  // Inicializar el gestor de colores (creación directa)
  colores = new GestorColores();
  
  // Inicializar variables
  velocidad = VELOCIDAD_BASE;
  aceleracion = 0.0;
  
  // Crear la escena principal
  escena = new Escena();
  escena.inicializar();
}

// Bucle principal de dibujo
void draw() {
  // Actualizar la velocidad con aceleración
  velocidad += aceleracion;
  velocidad = constrain(velocidad, 0.5, 10.0); // Limitar la velocidad
  
  // Limpiar el fondo con el color de la paleta
  background(colores.obtenerFondo(100));
  
  // Actualizar y dibujar la escena
  escena.actualizar(velocidad);
  escena.dibujar();
  
  // Mostrar información de debug si está activado
  if (modoDebug) {
    mostrarInfoDebug();
  }
}

// Controles de teclado
void keyPressed() {
  if (key == 'w' || key == 'W' || keyCode == UP) {
    aceleracion = 0.05; // Acelerar
  } 
  else if (key == 's' || key == 'S' || keyCode == DOWN) {
    aceleracion = -0.05; // Desacelerar
  }
  else if (key == 'd' || key == 'D') {
    modoDebug = !modoDebug; // Activar/desactivar modo debug
  }
  else if (key == 'r' || key == 'R') {
    // Reiniciar la simulación
    escena = new Escena();
    escena.inicializar();
    velocidad = VELOCIDAD_BASE;
  }
}

void keyReleased() {
  if ((key == 'w' || key == 'W' || keyCode == UP) || 
      (key == 's' || key == 'S' || keyCode == DOWN)) {
    aceleracion = 0; // Detener aceleración/desaceleración al soltar teclas
  }
}

// Muestra información de debug en pantalla
void mostrarInfoDebug() {
  // Cambiar a modo 2D para evitar problemas de iluminación con el texto
  hint(DISABLE_DEPTH_TEST);
  camera();
  noLights();
  
  // Sin fondo ni borde, solo texto extra brillante
  textAlign(LEFT);
  textSize(16);  // Texto más grande
  
  // Títulos con color primario brillante
  fill(colores.obtenerPrimario(300), 255);  // Color cian brillante para títulos con opacidad máxima
  text("INFORMACIÓN DE DEPURACIÓN", 20, 30);
  
  // Valores con color blanco brillante, forzando el brillo máximo
  fill(255);  // Blanco puro con opacidad total
  text("FPS: " + nf(frameRate, 0, 1), 20, 55);
  text("Velocidad: " + nf(velocidad, 0, 2), 20, 75);
  text("Círculos: " + escena.contarCirculos(), 20, 95);
  text("Estrellas: " + escena.contarEstrellas(), 20, 115);
  text("Aceleración: " + nf(aceleracion, 0, 2), 20, 135);
  
  // Sección de controles con color destacado
  fill(colores.obtenerAcento(100), 255);  // Rojo brillante para controles con opacidad máxima
  text("CONTROLES:", 20, 165);
  
  fill(255);  // Blanco puro
  text("D - Alternar debug", 20, 185);
  text("R - Reiniciar", 20, 205);
  text("W/↑ - Acelerar", 20, 225);
  text("S/↓ - Desacelerar", 20, 245);
  
  // Restaurar configuración 3D
  hint(ENABLE_DEPTH_TEST);
}