import 'dart:typed_data';

import 'package:demo_tefpaygo_simples/controller/types/generic_printer.dart';
import 'package:flutter/material.dart';
import 'package:tectoy_sunmiprinter/tectoy_sunmiprinter.dart';

/// * [CustomPrinter] é uma classe que implementa a interface [GenericPrinter]
/// * Essa classe deve implementar os métodos de impressão

class CustomPrinter implements GenericPrinter {
  final _printer = TectoySunmiprinter();



  @override
  Future<void> printerText(String comprovante) async {
    try {
     await Future.wait([
       _printer.printText(comprovante),
       _printer.cutPaper()
     ]);
    } catch (e) {
      debugPrint("Erro ao imprimir: $e");
    }
  }

  @override
  Future<void> sendRawData(Uint8List data) async {
    await _printer.sendRAWData(data);
  }

  @override
  Future<void> printBitmap(Uint8List bitmap)  async {
    await _printer.printBitmap(bitmap);
  }
}

/// NonePrinter imprime na saída padrão
class NonePrinter implements GenericPrinter {
  @override
  Future<void> printBitmap(Uint8List bitmap) async {
    // TODO: implement printBitmap
   debugPrint(bitmap.toString());
  }

  @override
  Future<void> printerText(String text) async {
    // TODO: implement printerText
    debugPrint(text);
  }

  @override
  Future<void> sendRawData(Uint8List data) async {
    // TODO: implement sendRawData
    debugPrint(data.toString());
  }

}