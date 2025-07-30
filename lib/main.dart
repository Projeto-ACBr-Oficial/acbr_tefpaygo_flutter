import 'package:demo_tefpaygo_simples/controller/paygo_tefcontroller.dart';
import 'package:demo_tefpaygo_simples/view/screens/home_page.dart';
import 'package:demo_tefpaygo_simples/view/screens/payment/payment_mode.dart';
import 'package:demo_tefpaygo_simples/view/screens/screen_example.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorSeed = Color.fromARGB(255, 43, 57, 78);
    final colorScheme = ColorScheme.fromSeed(
        seedColor: colorSeed, brightness: Brightness.light);
    final colorSchemeDark =
        ColorScheme.fromSeed(seedColor: colorSeed, brightness: Brightness.dark);

    return GetMaterialApp(
      onDispose: () {
        debugPrint("GetMaterialApp onDispose");
        Get.delete<TefController>();
      },
      initialBinding: BindingsBuilder(() {
        Get.put(TefController(), permanent: true);
      }),
      title: 'Demo PayGOSdk',
      theme: ThemeData(
          colorScheme: colorScheme,
          useMaterial3: true,
          primaryColor: colorSeed),
      darkTheme: ThemeData(
          colorScheme: colorSchemeDark,
          useMaterial3: true,
          primaryColor: colorSeed),
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
        GetPage(
            name: '/failure_screen',
            page: () => ExampleErrorScreen(message: Get.arguments)),
        GetPage(
          name: '/success_screen',
          page: () => ExampleSuccessScreen(),
        ),
      ],
    );
  }
}
