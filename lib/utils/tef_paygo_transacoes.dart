
import 'package:demo_tefpaygo_simples/controller/paygo_operation_controller.dart';

class PayGoOperationHelper{
  // Private constructor
  PayGoOperationHelper._privateConstructor();

  // Static instance
  static final PayGoOperationHelper _instance = PayGoOperationHelper._privateConstructor();

  // Factory constructor to return the same instance
  factory PayGoOperationHelper() {
    return _instance;
  }

  // Instance of PayGOSdk
  final  TefPayGoTransacoes  _tefPayGoTransacoes = TefPayGoTransacoes();

  // Method to get the PayGOSdk instance
  TefPayGoTransacoes get tefPayGoTransacoes => _tefPayGoTransacoes;
}