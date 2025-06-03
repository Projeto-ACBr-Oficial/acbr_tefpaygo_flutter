import 'package:demo_tefpaygo_simples/controller/PayGoTefController.dart';
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
      final colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
      final colorSchemeDark = ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);

      return GetMaterialApp(
        onDispose: () {
          debugPrint("GetMaterialApp onDispose");
          Get.delete<TefController>();
        },
        initialBinding: BindingsBuilder(() {
          Get.put(TefController());
        }),
        title: 'Demo PayGOSdk',
        theme: ThemeData(
          colorScheme: colorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: colorSchemeDark,
          useMaterial3: true,
        ),
        initialRoute: '/home',
        getPages: [
          GetPage(
            name: '/home',
            page: () => MyHomePage(),
          ),
          GetPage(
            name: '/payment',
            page: () => PaymentViewMode(valorPagamento: Get.arguments),
          ),
        ],
      );
    }
  }