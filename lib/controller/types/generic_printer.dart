import 'dart:typed_data';

///  [GenericPrinter] é uma interface para uma impressora genérica
///  * As classes de impressoras devem implementar essa interface
///  * Por exemplo, você pode implementar a impressão via bluetooth, impressão via USB,
///  * usar um serviço de impressão na nuvem, entre outros
///  * Caso troque de equipamento de impressão, basta implementar essa interface
///

abstract class GenericPrinter {
  /// [printerText] Método para inicializar a impressora
  /// * [text] é o texto a ser impresso

  Future<void> printerText(String text);

  /// [sendRawData] Método para enviar dados brutos para a impressora
  /// * Este método é usado para enviar dados que não são texto, como imagens ou comandos específicos da impressora
  /// * [data] é os dados a serem enviados

  Future<void> sendRawData(Uint8List data);

  /// [printBitmap] Método para imprimir uma imagem bitmap
  /// * [bitmap] é a imagem em formato [Uint8List] a ser impressa

  Future<void> printBitmap(Uint8List bitmap);
}
