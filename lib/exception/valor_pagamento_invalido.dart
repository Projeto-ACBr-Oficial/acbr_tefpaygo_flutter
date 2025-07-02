import 'package:demo_tefpaygo_simples/exception/tef_paygo_exception.dart';

class ValorPagamentoInvalidoException extends TefPaygoException{

  ValorPagamentoInvalidoException(super.message);

  @override
  String toString()  => "PagamentoInvalidoException: $message";
}