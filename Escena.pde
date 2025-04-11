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
    
    // Tamaño aleatorio - ahora más grande
    tamaño = random(2, 6);  // Aumentado de 1-3 a 2-6 píxeles
    
    // Determinar si es una estrella brillante especial (10% de probabilidad)
    estrellaBrillante = random(1) < 0.1;
    
    // Si es brillante, hacerla más grande
    if (estrellaBrillante) {
      tamaño *= 1.5;
    }
    
    // Determinar el color base (predominan los claros para las estrellas)
    float seleccionTipo = random(1);
    if (seleccionTipo < 0.5) {
      // 50% estrellas blancas/plateadas (texto) - Aumentado de 70% a 50%
      colorEstrella = colores.obtenerTexto(100); // Blanco puro para mejor visibilidad
    } else if (seleccionTipo < 0.8) {
      // 30% estrellas azuladas (primario) - Aumentado de 20% a 30%
      colorEstrella = colores.obtenerPrimario(300); // Color más brillante sin alteración
    } else {
      // 20% estrellas cálidas (acento) - Aumentado de 10% a 20%
      colorEstrella = colores.obtenerAcento(200); // Color cálido sin alteración
    }
    
    // Velocidad propia para efecto de paralaje
    velocidadPropia = random(0.2, 1.0);
    
    // Brillo inicial más alto para mejor visibilidad
    brillo = random(180, 255); // Aumentado de 100-255 a 180-255
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
    if (estrellaBrillante || random(1) > 0.95) { // Más probabilidad de parpadeo (antes 0.97)
      brillo = random(200, 255); // Brillo más intenso (antes 150-255)
    } else {
      // Suavizar el brillo pero manteniéndolo alto
      brillo = lerp(brillo, 220, 0.05); // Valor base más alto (antes 200)
    }
  }
  
  /**
   * Dibuja la estrella
   */
  void dibujar() {
    pushMatrix();
    translate(posicion.x, posicion.y, posicion.z);
    
    // Sin borde para estrellas normales
    noStroke();
    
    // Color con brillo variable
    fill(colores.conTransparencia(colorEstrella, brillo));
    
    // Dibujar como punto brillante
    circle(0, 0, tamaño);
    
    // Efecto de resplandor para estrellas brillantes
    if (estrellaBrillante) {
      // Primer halo
      fill(colores.conTransparencia(colorEstrella, brillo * 0.5));
      circle(0, 0, tamaño * 2);
      
      // Segundo halo más tenue
      fill(colores.conTransparencia(colorEstrella, brillo * 0.3));
      circle(0, 0, tamaño * 3);
      
      // Rayos de luz en forma de cruz
      stroke(colores.conTransparencia(colorEstrella, brillo * 0.7));
      strokeWeight(0.8);
      float rayoLongitud = tamaño * 2;
      line(-rayoLongitud, 0, rayoLongitud, 0); // Horizontal
      line(0, -rayoLongitud, 0, rayoLongitud); // Vertical
    }
    
    popMatrix();
  }
  
  /**
   * Reinicia la estrella a una posición aleatoria lejana
   */
  void reiniciar() {
    // Distribución más concentrada para mayor densidad visual
    float x = random(-width * 0.8, width * 1.8); // Reducido de -width,width*2
    float y = random(-height * 0.8, height * 1.8); // Reducido para más densidad
    float z = random(-2000, -200);
    posicion = new PVector(x, y, z);
  }
}