import 'dart:typed_data';


/**
 * GenericPrinter é uma interface para uma impressora genérica
 * As classes de impressoras devem implementar essa interface
 */
abstract class GenericPrinter {
  void printerText(String text);
  void sendRawData(Uint8List data);
  void printBitmap(Uint8List bitmap);
}