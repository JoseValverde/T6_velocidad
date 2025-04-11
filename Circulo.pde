/**
 * Clase Circulo
 * 
 * Representa una forma geométrica en el espacio que crece y se acerca al observador.
 * A pesar del nombre, puede representar círculos, cuadrados, triángulos, etc.
 */
class Circulo {
  // Coordenadas de la forma en espacio 3D
  PVector posicion;
  
  // Color de la forma
  color colorForma;
  
  // Tipo de forma geométrica
  TipoForma tipoForma;
  
  // Tamaño y profundidad
  float diametro;
  float profundidadInicial;
  float profundidadRelativa; // 0.0 = más cerca, 1.0 = más lejos
  
  // Estado de la forma
  boolean activo;
  int vidaRestante;    // Tiempo de vida restante en frames
  float opacidad;      // Valor de transparencia
  
  // Sistema de estelas
  ArrayList<PosicionEstela> estela;
  int longitudEstela;  // Cantidad de segmentos en la estela
  int contadorEstela;  // Contador para generar puntos de estela periódicamente
  
  // Factor de rotación
  float rotacion;
  float velocidadRotacion;
  
  // Instancia del dibujador de formas
  Formas formaDibujador;
  
  /**
   * Constructor de la forma
   * @param diametroInicial - Tamaño inicial de la forma
   * @param profundidad - Profundidad inicial (valor Z)
   * @param colorBase - Color base de la forma
   * @param tipo - Tipo de forma geométrica
   */
  Circulo(float diametroInicial, float profundidad, color colorBase, TipoForma tipo) {
    // Posición centrada en X e Y pero alejada en Z
    posicion = new PVector(width/2, height/2, profundidad);
    
    diametro = diametroInicial;
    profundidadInicial = profundidad;
    profundidadRelativa = 1.0; // Inicia al fondo
    
    // Establecer el tipo de forma
    tipoForma = tipo;
    
    // Crear color con una ligera variación
    colorForma = colores.alterarColor(colorBase, 30);
    
    // Inicializar estado
    activo = true;
    vidaRestante = int(random(60, 120)); // Entre 1 y 2 segundos a 60fps
    opacidad = 255;
    
    // Inicializar sistema de estelas
    estela = new ArrayList<PosicionEstela>();
    longitudEstela = int(random(5, 15)); // Longitud variable para cada forma
    contadorEstela = 0;
    
    // Inicializar rotación (solo afecta a formas no circulares)
    rotacion = random(TWO_PI);
    velocidadRotacion = random(-0.02, 0.02);
    
    // Inicializar el dibujador de formas
    formaDibujador = new Formas();
  }
  
  /**
   * Constructor simplificado que acepta solo los parámetros esenciales
   */
  Circulo(float diametroInicial, float profundidad, color colorBase) {
    this(diametroInicial, profundidad, colorBase, TipoForma.values()[int(random(TipoForma.values().length))]);
  }
  
  /**
   * Actualiza la posición y estado de la forma
   * @param velocidadActual - Velocidad de aproximación
   */
  void actualizar(float velocidadActual) {
    if (!activo) return;
    
    // Aplicar rotación
    rotacion += velocidadRotacion;
    
    // Guardar la posición anterior para la estela
    contadorEstela++;
    if (contadorEstela >= 2) { // Cada 2 frames, más frecuente = estela más densa
      contadorEstela = 0;
      
      // Añadir un nuevo punto a la estela
      if (estela.size() < longitudEstela) {
        estela.add(new PosicionEstela(
          posicion.x, posicion.y, posicion.z, 
          diametro * (posicion.z < 0 ? map(profundidadRelativa, 0.0, 1.0, 1.0, 0.1) : 1.0),
          rotacion,
          tipoForma
        ));
      } else if (estela.size() > 0) {
        // Reciclar el punto más antiguo
        PosicionEstela puntoAntiguo = estela.remove(0);
        puntoAntiguo.actualizar(
          posicion.x, posicion.y, posicion.z, 
          diametro * (posicion.z < 0 ? map(profundidadRelativa, 0.0, 1.0, 1.0, 0.1) : 1.0),
          rotacion,
          tipoForma
        );
        estela.add(puntoAntiguo);
      }
    }
    
    // Acercar la forma basándose en la velocidad actual
    posicion.z += velocidadActual * 10;
    
    // Calcular la profundidad relativa (0 = cerca, 1 = lejos)
    profundidadRelativa = map(posicion.z, profundidadInicial, 0, 1.0, 0.0);
    profundidadRelativa = constrain(profundidadRelativa, 0.0, 1.0);
    
    // La forma está frente a la cámara
    if (posicion.z >= 0) {
      vidaRestante--; // Empezar a reducir la vida
      
      // Si la vida se acabó, desactivar la forma
      if (vidaRestante <= 0) {
        activo = false;
      }
      
      // Desvanecer gradualmente
      opacidad = map(vidaRestante, 0, 60, 0, 255);
    }
  }
  
  /**
   * Dibuja la forma en pantalla
   */
  void dibujar() {
    if (!activo) return;
    
    // Primero dibujar la estela (detrás de la forma principal)
    dibujarEstela();
    
    pushMatrix();
    translate(posicion.x, posicion.y, posicion.z);
    rotate(rotacion);
    
    // Calcular el tamaño basado en la proximidad
    float tamañoActual = diametro;
    if (posicion.z < 0) {
      // Cuando está lejos, el tamaño es más pequeño por la perspectiva
      float factorEscala = map(profundidadRelativa, 0.0, 1.0, 1.0, 0.1);
      tamañoActual = diametro * factorEscala;
    } else {
      // Cuando está cerca, el tamaño crece para dar sensación de inmersión
      tamañoActual = diametro * map(posicion.z, 0, 300, 1.0, 3.0);
    }
    
    // Aplicar color con opacidad
    noFill();
    stroke(red(colorForma), green(colorForma), blue(colorForma), opacidad);
    strokeWeight(3 * (1 - profundidadRelativa * 0.8)); // Líneas más gruesas cuando está cerca
    
    // Dibujar la forma según su tipo
    formaDibujador.dibujarForma(tipoForma, tamañoActual);
    
    // Opcional: Efecto de brillo
    if (random(1) > 0.8) {
      stroke(colores.conTransparencia(colores.obtenerTexto(100), random(50, 80)));
      strokeWeight(1);
      formaDibujador.dibujarForma(tipoForma, tamañoActual + random(5, 15));
    }
    
    popMatrix();
  }
  
  /**
   * Dibuja la estela de la forma
   */
  private void dibujarEstela() {
    if (estela.size() < 2) return; // Necesitamos al menos 2 puntos
    
    // Dibujar cada segmento de la estela
    for (int i = 0; i < estela.size() - 1; i++) {
      PosicionEstela punto = estela.get(i);
      PosicionEstela siguiente = estela.get(i+1);
      
      // Calcular opacidad basada en la posición en la estela (más antiguo = más transparente)
      float opacidadEstela = map(i, 0, estela.size()-1, 10, 150) * (opacidad/255.0);
      
      // Línea conectora para estelas densas (solo para simplificar la visualización)
      stroke(colores.conTransparencia(colorForma, opacidadEstela * 0.3));
      strokeWeight(1);
      line(punto.x, punto.y, punto.z, siguiente.x, siguiente.y, siguiente.z);
      
      // Dibujar forma en cada punto de la estela
      pushMatrix();
      translate(punto.x, punto.y, punto.z);
      rotate(punto.rotacion);
      noFill();
      stroke(colores.conTransparencia(colorForma, opacidadEstela));
      float grosorLinea = map(i, 0, estela.size()-1, 0.5, 2);
      strokeWeight(grosorLinea);
      
      // Dibujar forma más pequeña para la estela
      formaDibujador.dibujarForma(punto.tipoForma, punto.tamaño * 0.8);
      
      popMatrix();
    }
  }
  
  /**
   * Verifica si la forma está activa o debe ser eliminada
   * @return true si está activa, false si debería eliminarse
   */
  boolean estaActivo() {
    return activo;
  }
}

/**
 * Clase auxiliar para almacenar puntos de la estela
 */
class PosicionEstela {
  float x, y, z;
  float tamaño;
  float rotacion;
  TipoForma tipoForma;
  
  PosicionEstela(float x, float y, float z, float tamaño, float rotacion, TipoForma tipo) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.tamaño = tamaño;
    this.rotacion = rotacion;
    this.tipoForma = tipo;
  }
  
  void actualizar(float x, float y, float z, float tamaño, float rotacion, TipoForma tipo) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.tamaño = tamaño;
    this.rotacion = rotacion;
    this.tipoForma = tipo;
  }
}