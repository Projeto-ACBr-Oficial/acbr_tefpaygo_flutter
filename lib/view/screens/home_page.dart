import 'dart:io';

import 'package:demo_tefpaygo_simples/view/screens/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/PayGoTefController.dart';
import 'config/config_page.dart';

class MyHomePage extends StatefulWidget {
  String title = "";
  MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _titles = ["Home", "Configurações"];
  final List<Widget> _pages = [
    PaymentPage(title: "Comandos"),
    ConfigurationPage(),
  ];
  int _currentIndex = 0;

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void dispose() {
    debugPrint("dispose");
    Get.deleteAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(_titles[_currentIndex]),
        ),
        body: Center(
            child: _pages[_currentIndex]),

        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: setCurrentIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Configurações",
              ),
            ]));
  }
}
