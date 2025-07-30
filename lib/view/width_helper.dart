/*
 Função auxiliar para calcular a largura do widget
 */
import 'package:flutter/material.dart';

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

double calculeHeight(double maxHeight) {
  double height = 0.7 * maxHeight; // Reduzido de 0.8 para 0.7
  
  if (maxHeight < 600) {
    height = 0.8 * maxHeight; // Em telas muito pequenas, usa mais espaço
  } else if (maxHeight >= 600 && maxHeight < 1080) {
    height = 0.6 * maxHeight;
  } else if (maxHeight >= 1080) {
    height = 0.5 * maxHeight; // Reduzido de 0.4 para 0.5
  }
  
  return height;
}