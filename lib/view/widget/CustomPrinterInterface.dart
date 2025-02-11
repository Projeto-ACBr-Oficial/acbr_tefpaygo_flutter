import 'package:flutter/cupertino.dart';

abstract class CustomViewPrinter{
  void mostrarDialogoImpressao(BuildContext context, String conteudo, String titulo) ;
  void imprimirComprovante(String comprovante);
}