import 'dart:typed_data';

import 'package:demo_tefpaygo_simples/controller/types/generic_printer.dart';
import 'package:flutter/material.dart';
import 'package:sunmi_flutter_helper/sunmi_flutter_helper.dart';


/**
 * CustomSunmiPrinterX é uma classe que usa de impressao a biblioteca SunmiPrinterX
 * -
 */
class CustomSunmiPrinterX implements GenericPrinter {

  @override
  Future<void> printBitmap(Uint8List bitmap) async {
    try {
      await SunmiFlutterHelper.printImage(image: bitmap,align: 'center', width: 384);
    }catch(e){
      debugPrint("Erro ao imprimir: $e");
    }

  }

  @override
  Future<void> printerText(String text) async {
    try {
      await SunmiFlutterHelper.printText(text: text, size:10, align: 'left');
    }catch(e){
      debugPrint("Erro ao imprimir: $e");
    }
  }

  @override
  Future<void> sendRawData(Uint8List data)  async{
    // TODO: implement sendRawData
    throw UnimplementedError();
  }
  
}