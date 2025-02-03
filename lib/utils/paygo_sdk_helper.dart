import 'package:paygo_sdk/paygo_sdk.dart';

class PayGOSdkHelper {
  // Private constructor
  PayGOSdkHelper._privateConstructor();

  // Static instance
  static final PayGOSdkHelper _instance = PayGOSdkHelper._privateConstructor();

  // Factory constructor to return the same instance
  factory PayGOSdkHelper() {
    return _instance;
  }

  // Instance of PayGOSdk
  final PayGOSdk _paygoSdk = PayGOSdk();

  // Method to get the PayGOSdk instance
  PayGOSdk get paygoSdk => _paygoSdk;
}