/**
 * Clase Formas
 * 
 * Contiene diferentes tipos de formas geométricas que pueden
 * generarse en la animación espacial.
 */
 
// Tipos de formas disponibles
enum TipoForma {
  CIRCULO,
  CUADRADO,
  TRIANGULO,
  CRUZ,
  ESTRELLA,
  POLIEDRO
}

/**
 * Clase con métodos para dibujar diferentes formas geométricas
 * Nota: No usamos métodos estáticos para permitir el uso de las funciones de dibujo de Processing
 */
class Formas {
  
  /**
   * Dibuja una forma específica
   * @param tipo - El tipo de forma a dibujar
   * @param tamaño - El tamaño de la forma
   */
  void dibujarForma(TipoForma tipo, float tamaño) {
    switch (tipo) {
      case CIRCULO:
        dibujarCirculo(tamaño);
        break;
      case CUADRADO:
        dibujarCuadrado(tamaño);
        break;
      case TRIANGULO:
        dibujarTriangulo(tamaño);
        break;
      case CRUZ:
        dibujarCruz(tamaño);
        break;
      case ESTRELLA:
        dibujarEstrella(tamaño);
        break;
      case POLIEDRO:
        dibujarPoliedro(tamaño);
        break;
    }
  }
  
  /**
   * Dibuja un círculo
   */
  void dibujarCirculo(float tamaño) {
    ellipse(0, 0, tamaño, tamaño);
  }
  
  /**
   * Dibuja un cuadrado
   */
  void dibujarCuadrado(float tamaño) {
    rectMode(CENTER);
    rect(0, 0, tamaño, tamaño);
  }
  
  /**
   * Dibuja un triángulo equilátero
   */
  void dibujarTriangulo(float tamaño) {
    float altura = tamaño * 0.866; // Altura de un triángulo equilátero
    float mitad = tamaño / 2;
    
    triangle(-mitad, altura/3, mitad, altura/3, 0, -2*altura/3);
  }
  
  /**
   * Dibuja una cruz
   */
  void dibujarCruz(float tamaño) {
    float ancho = tamaño / 3;
    float largo = tamaño;
    
    // Rectángulo horizontal
    rect(0, 0, largo, ancho);
    
    // Rectángulo vertical
    rect(0, 0, ancho, largo);
  }
  
  /**
   * Dibuja una estrella de 5 puntas
   */
  void dibujarEstrella(float tamaño) {
    float radioExt = tamaño / 2;
    float radioInt = radioExt * 0.4;
    int numPuntas = 5;
    
    beginShape();
    for (int i = 0; i < numPuntas * 2; i++) {
      float radio = (i % 2 == 0) ? radioExt : radioInt;
      float angulo = TWO_PI * i / (numPuntas * 2) - HALF_PI;
      vertex(cos(angulo) * radio, sin(angulo) * radio);
    }
    endShape(CLOSE);
  }
  
  /**
   * Dibuja un poliedro (representado como un hexágono en 2D)
   */
  void dibujarPoliedro(float tamaño) {
    float radio = tamaño / 2;
    int numLados = 6;
    
    beginShape();
    for (int i = 0; i < numLados; i++) {
      float angulo = TWO_PI * i / numLados;
      vertex(cos(angulo) * radio, sin(angulo) * radio);
    }
    endShape(CLOSE);
  }
}