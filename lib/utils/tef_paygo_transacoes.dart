
import 'package:demo_tefpaygo_simples/controller/paygo_request_handler.dart';

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
  final  PayGoRequestHandler  _tefPayGoTransacoes = PayGoRequestHandler();

  // Method to get the PayGOSdk instance
  PayGoRequestHandler get tefPayGoTransacoes => _tefPayGoTransacoes;
}