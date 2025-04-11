/**
 * Clase Colores
 * 
 * Gestiona la paleta de colores para toda la animación,
 * centralizando el acceso y facilitando cambios globales.
 */
class GestorColores {
  // Colores primarios
  color primary100;
  color primary200;
  color primary300;
  
  // Colores de acento
  color accent100;
  color accent200;
  
  // Colores de texto
  color text100;
  color text200;
  
  // Colores de fondo
  color bg100;
  color bg200;
  color bg300;
  
  /**
   * Constructor para el gestor de colores
   * Inicializa todos los colores de la paleta
   */
  GestorColores() {
    // Inicializar colores según la paleta definida
    primary100 = color(13, 110, 110);    // #0D6E6E
    primary200 = color(74, 157, 156);    // #4a9d9c
    primary300 = color(175, 255, 255);   // #afffff
    
    accent100 = color(255, 61, 61);      // #FF3D3D
    accent200 = color(255, 224, 200);    // #ffe0c8
    
    text100 = color(255, 255, 255);      // #FFFFFF
    text200 = color(224, 224, 224);      // #e0e0e0
    
    bg100 = color(13, 31, 45);           // #0D1F2D
    bg200 = color(29, 46, 61);           // #1d2e3d
    bg300 = color(53, 70, 86);           // #354656
  }
  
  /**
   * Obtiene un color primario de la paleta
   * @param nivel Índice del color primario (100, 200 o 300)
   * @return Color correspondiente
   */
  color obtenerPrimario(int nivel) {
    switch (nivel) {
      case 100: return primary100;
      case 200: return primary200;
      case 300: return primary300;
      default: return primary200; // Valor por defecto
    }
  }
  
  /**
   * Obtiene un color de acento de la paleta
   * @param nivel Índice del acento (100 o 200)
   * @return Color correspondiente
   */
  color obtenerAcento(int nivel) {
    switch (nivel) {
      case 100: return accent100;
      case 200: return accent200;
      default: return accent100; // Valor por defecto
    }
  }
  
  /**
   * Obtiene un color de texto de la paleta
   * @param nivel Índice del texto (100 o 200)
   * @return Color correspondiente
   */
  color obtenerTexto(int nivel) {
    switch (nivel) {
      case 100: return text100;
      case 200: return text200;
      default: return text100; // Valor por defecto
    }
  }
  
  /**
   * Obtiene un color de fondo de la paleta
   * @param nivel Índice del fondo (100, 200 o 300)
   * @return Color correspondiente
   */
  color obtenerFondo(int nivel) {
    switch (nivel) {
      case 100: return bg100;
      case 200: return bg200;
      case 300: return bg300;
      default: return bg100; // Valor por defecto
    }
  }
  
  /**
   * Obtiene un array con todos los colores primarios
   * @return Array con los tres colores primarios
   */
  color[] obtenerPalletaPrimarios() {
    return new color[] { primary100, primary200, primary300 };
  }
  
  /**
   * Obtiene un array con todos los colores de acento
   * @return Array con los dos colores de acento
   */
  color[] obtenerPaletaAcentos() {
    return new color[] { accent100, accent200 };
  }
  
  /**
   * Aplica una variación aleatoria a un color base
   * @param base - Color base a modificar
   * @param variacion - Cantidad máxima de variación
   * @return Color alterado
   */
  color alterarColor(color base, int variacion) {
    int r = constrain(int(red(base) + random(-variacion, variacion)), 0, 255);
    int g = constrain(int(green(base) + random(-variacion, variacion)), 0, 255);
    int b = constrain(int(blue(base) + random(-variacion, variacion)), 0, 255);
    
    return color(r, g, b);
  }
  
  /**
   * Crea un color con transparencia
   * @param c - Color original
   * @param alfa - Valor de transparencia (0-255)
   * @return Color con transparencia aplicada
   */
  color conTransparencia(color c, float alfa) {
    return color(red(c), green(c), blue(c), alfa);
  }
}