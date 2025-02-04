
import 'package:demo_tefpaygo_simples/controller/paygo_request_handler.dart';

class PayGoRequestHandlerHelper{
  // Private constructor
  PayGoRequestHandlerHelper._privateConstructor();

  // Static instance
  static final PayGoRequestHandlerHelper _instance = PayGoRequestHandlerHelper._privateConstructor();

  // Factory constructor to return the same instance
  factory PayGoRequestHandlerHelper() {
    return _instance;
  }

  // Instance of PayGOSdk
  final  PayGoRequestHandler  _payGoRequestHandler = PayGoRequestHandler();

  // Method to get the PayGOSdk instance
  PayGoRequestHandler get payGoRequestHandler => _payGoRequestHandler;
}