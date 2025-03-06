import 'package:demo_tefpaygo_simples/exception/tef_paygo_exception.dart';

class ValorPagamentoInvalidoException implements TefPaygoException{
  final String message;

  ValorPagamentoInvalidoException(this.message);

  @override
  String toString() {
    return 'ValorPagamentoInvalidoException: $message';
  }
}