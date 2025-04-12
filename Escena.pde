/**
 * Clase Escena
 * 
 * Gestiona todos los elementos visuales de la animación,
 * incluyendo círculos y estrellas de fondo.
 */
class Escena {
  // Colección de círculos activos
  ArrayList<Circulo> circulos;
  
  // Fondo de estrellas
  ArrayList<Estrella> estrellas;
  
  // Parámetros de generación
  float probabilidadNuevoCirculo;
  
  /**
   * Constructor de la escena
   */
  Escena() {
    circulos = new ArrayList<Circulo>();
    estrellas = new ArrayList<Estrella>();
    probabilidadNuevoCirculo = 0.03; // 3% de probabilidad por frame
    
    // No necesitamos obtener colores aquí, usaremos la variable global
  }
  
  /**
   * Inicializa la escena con estrellas de fondo
   */
  void inicializar() {
    // Crear estrellas de fondo
    for (int i = 0; i < MAX_ESTRELLAS; i++) {
      estrellas.add(new Estrella());
    }
  }
  
  /**
   * Actualiza todos los elementos de la escena
   * @param velocidadActual - Velocidad actual de la simulación
   */
  void actualizar(float velocidadActual) {
    // Actualizar estrellas existentes
    for (Estrella e : estrellas) {
      e.actualizar(velocidadActual);
    }
    
    // Actualizar círculos existentes
    for (int i = circulos.size() - 1; i >= 0; i--) {
      Circulo c = circulos.get(i);
      c.actualizar(velocidadActual);
      
      // Eliminar círculos inactivos
      if (!c.estaActivo()) {
        circulos.remove(i);
      }
    }
    
    // Generar nuevos círculos si hay espacio
    if (circulos.size() < MAX_CIRCULOS && random(1) < probabilidadNuevoCirculo) {
      generarNuevoCirculo();
    }
  }
  
  /**
   * Dibuja todos los elementos de la escena
   */
  void dibujar() {
    // Configurar iluminación ambiental suave
    ambientLight(40, 40, 60);
    
    // Dibujar estrellas primero (fondo)
    for (Estrella e : estrellas) {
      e.dibujar();
    }
    
    // Dibujar círculos
    for (Circulo c : circulos) {
      c.dibujar();
    }
  }
  
  /**
   * Genera un nuevo círculo con características aleatorias
   */
  void generarNuevoCirculo() {
    // Seleccionar tamaño entre 100 y 400 de diámetro
    float diametro = random(100, 400);
    
    // Colocar en una profundidad negativa (lejos)
    float profundidad = random(-2000, -1000);
    
    // Seleccionar un color base
    color colorBase;
    float seleccionColor = random(1);
    
    if (seleccionColor < 0.6) {
      // 60% de probabilidad - usar colores primarios
      int nivelPrimario = floor(random(3)) * 100 + 100; // 100, 200 o 300
      colorBase = colores.obtenerPrimario(nivelPrimario);
    } else if (seleccionColor < 0.9) {
      // 30% de probabilidad - usar colores de acento
      int nivelAcento = floor(random(2)) * 100 + 100; // 100 o 200
      colorBase = colores.obtenerAcento(nivelAcento);
    } else {
      // 10% de probabilidad - usar colores de texto (más brillantes)
      colorBase = colores.obtenerTexto(100);
    }
    
    // Seleccionar un tipo de forma aleatoriamente
    TipoForma tipoForma = TipoForma.values()[int(random(TipoForma.values().length))];
    
    // Crear y añadir la forma
    circulos.add(new Circulo(diametro, profundidad, colorBase, tipoForma));
  }
  
  /**
   * Cuenta los círculos actualmente en escena
   * @return Número de círculos activos
   */
  int contarCirculos() {
    return circulos.size();
  }
  
  /**
   * Cuenta las estrellas de fondo
   * @return Número de estrellas
   */
  int contarEstrellas() {
    return estrellas.size();
  }
}

/**
 * Clase Estrella
 * 
 * Representa una estrella del fondo para dar profundidad a la escena
 */
class Estrella {
  PVector posicion;
  float tamaño;
  color colorEstrella;
  float velocidadPropia;
  float brillo;
  boolean estrellaBrillante; // Indica si es una estrella con efecto de brillo especial
  
  /**
   * Constructor de estrella con posición aleatoria
   */
  Estrella() {
    // Posición aleatoria en todo el espacio
    reiniciar();
    
    // Tamaño aleatorio - considerablemente más grande
    tamaño = random(3, 8);  // Aumentado de 2-6 a 3-8 píxeles
    
    // Determinar si es una estrella brillante especial (ahora 25% de probabilidad)
    estrellaBrillante = random(1) < 0.25;  // Aumentado de 10% a 25%
    
    // Si es brillante, hacerla más grande
    if (estrellaBrillante) {
      tamaño *= 2.0;  // Factor de escala mayor (antes 1.5)
    }
    
    // Determinar el color base con mayor tendencia a colores brillantes
    float seleccionTipo = random(1);
    if (seleccionTipo < 0.6) {  // Aumentado a 60% (antes 50%)
      // 60% estrellas blancas/plateadas (texto blanco puro)
      colorEstrella = color(255, 255, 255);  // Blanco puro definido directamente
    } else if (seleccionTipo < 0.85) {  // Aumentado a 25% (antes 30%)
      // 25% estrellas azuladas brillantes
      colorEstrella = color(175, 255, 255);  // Cian brillante
    } else {
      // 15% estrellas cálidas intensas (antes 20%)
      colorEstrella = color(255, 220, 180);  // Naranja claro brillante
    }
    
    // Velocidad propia para efecto de paralaje
    velocidadPropia = random(0.2, 1.0);
    
    // Brillo inicial siempre alto
    brillo = random(220, 255);  // Valor mínimo aumentado a 220 (antes 180)
  }
  
  /**
   * Actualiza la posición de la estrella
   * @param velocidadBase - Velocidad base de la simulación
   */
  void actualizar(float velocidadBase) {
    // Mover hacia adelante (aumentar Z)
    posicion.z += (velocidadBase * velocidadPropia * 5);
    
    // Si se sale de la pantalla, reiniciar
    if (posicion.z > 500) {
      reiniciar();
    }
    
    // Efecto de parpadeo más frecuente y pronunciado
    if (estrellaBrillante || random(1) > 0.90) {  // Más probabilidad de parpadeo (antes 0.95)
      brillo = 255;  // Brillo máximo siempre
    } else {
      // Mantener brillo alto incluso al reducir
      brillo = lerp(brillo, 230, 0.1);  // Base y velocidad de transición aumentadas
    }
  }
  
  /**
   * Dibuja la estrella
   */
  void dibujar() {
    pushMatrix();
    translate(posicion.x, posicion.y, posicion.z);
    
    // Deshabilitar test de profundidad temporalmente para asegurar visibilidad
    hint(DISABLE_DEPTH_TEST);
    
    // Primer paso: dibujar un punto blanco brillante en el centro
    stroke(255, brillo);  // Contorno blanco puro
    strokeWeight(1);
    point(0, 0);
    
    // Color con brillo variable para el círculo principal
    noStroke();
    fill(red(colorEstrella), green(colorEstrella), blue(colorEstrella), brillo);
    
    // Dibujar como punto brillante
    circle(0, 0, tamaño);
    
    // Efecto de resplandor para todas las estrellas
    // Primer halo (todas las estrellas)
    fill(red(colorEstrella), green(colorEstrella), blue(colorEstrella), brillo * 0.6);  // Mayor opacidad
    circle(0, 0, tamaño * 1.5);
    
    // Efectos adicionales para estrellas brillantes
    if (estrellaBrillante) {
      // Halo exterior más grande
      fill(red(colorEstrella), green(colorEstrella), blue(colorEstrella), brillo * 0.4);
      circle(0, 0, tamaño * 3);
      
      // Halo exterior adicional muy sutil
      fill(red(colorEstrella), green(colorEstrella), blue(colorEstrella), brillo * 0.2);
      circle(0, 0, tamaño * 5);
      
      // Rayos de luz en forma de cruz más visibles
      stroke(red(colorEstrella), green(colorEstrella), blue(colorEstrella), brillo * 0.8);
      strokeWeight(1.2);  // Más grosor
      float rayoLongitud = tamaño * 3;  // Rayos más largos
      line(-rayoLongitud, 0, rayoLongitud, 0); // Horizontal
      line(0, -rayoLongitud, 0, rayoLongitud); // Vertical
      
      // Rayos diagonales adicionales
      strokeWeight(0.8);  // Más finos
      float rayoDiagonal = rayoLongitud * 0.7;
      line(-rayoDiagonal, -rayoDiagonal, rayoDiagonal, rayoDiagonal); // Diagonal \
      line(-rayoDiagonal, rayoDiagonal, rayoDiagonal, -rayoDiagonal); // Diagonal /
    }
    
    // Restaurar test de profundidad
    hint(ENABLE_DEPTH_TEST);
    
    popMatrix();
  }
  
  /**
   * Reinicia la estrella a una posición aleatoria lejana
   */
  void reiniciar() {
    // Distribución más concentrada en el área visible
    float x = random(-width * 0.5, width * 1.5);  // Más centrado en la pantalla
    float y = random(-height * 0.5, height * 1.5); // Más centrado en la pantalla
    float z = random(-1500, -200);  // Profundidad ajustada para mayor visibilidad
    posicion = new PVector(x, y, z);
  }
}