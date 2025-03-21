import 'dart:typed_data';


/**
 * GenericPrinter é uma interface para uma impressora genérica
 * As classes de impressoras devem implementar essa interface
 * Por exemplo, você pode implementar a impressão via bluetooth, impressão via USB,
 * usar um serviço de impressão na nuvem, entre outros
 * Caso troque de equipamento de impressão, basta implementar essa interface
 *
 */
abstract class GenericPrinter {
  /**
   * Método para imprimir um texto
   */
  void printerText(String text);
  /**
   * Método enviar raw_data para impressora
   */

  void sendRawData(Uint8List data);

  /**
   * Método para imprimir um bitmap
   */

  void printBitmap(Uint8List bitmap);
}