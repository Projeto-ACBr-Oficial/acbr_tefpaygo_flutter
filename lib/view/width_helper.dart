/*
 Função auxiliar para calcular a largura do widget
 */
double calculeWidth(double maxWidth) {
  double width = 0.8 * maxWidth;
  
  if (maxWidth > 600) {
    width = 0.6 * maxWidth;
  }
  
  if (maxWidth > 1200) {
    width = 0.4 * maxWidth;
  }
  
  return width;
}