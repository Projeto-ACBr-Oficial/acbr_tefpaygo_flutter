import 'package:demo_tefpaygo_simples/controller/paygo_tefcontroller.dart';
import 'package:demo_tefpaygo_simples/view/_core/app_theme.dart';
import 'package:demo_tefpaygo_simples/view/screens/home_page.dart';
import 'package:demo_tefpaygo_simples/view/screens/payment/payment_mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onDispose: () {
        debugPrint("GetMaterialApp onDispose");
        Get.delete<TefController>();
      },
      initialBinding: BindingsBuilder(() {
        Get.put(TefController(), permanent: true);
      }),
      title: 'Demo PayGOSdk',
      theme: AppTheme.dark,
      initialRoute: '/home',
      getPages: [
        GetPage(
          name: '/home',
          page: () => MyHomePage(),
        ),
        GetPage(
          name: '/payment',
          page: () => PaymentViewMode(valorPagamento: Get.arguments),
        )
      ],
    );
  }
}
