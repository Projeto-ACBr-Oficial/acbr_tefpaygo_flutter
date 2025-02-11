import 'package:demo_tefpaygo_simples/view/widget/CustomPrinterInterface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tectoy_sunmiprinter/tectoy_sunmiprinter.dart';

class CustomPrinter implements CustomViewPrinter {
  final _printer = TectoySunmiprinter();

  @override
  void mostrarDialogoImpressao(BuildContext context, String conteudo, String titulo) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titulo),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Fechar"),
              ),
              TextButton(
                onPressed: () {
                  imprimirComprovante(conteudo);
                  Navigator.of(context).pop();
                },
                child: const Text("Imprimir"),
              ),
            ],
          );
        });
  }

  @override
  void imprimirComprovante(String comprovante) async {
    try {
      await _printer.printText(comprovante);
      await _printer.cutPaper();
    } catch (e) {
      print(e);
    }
  }
}