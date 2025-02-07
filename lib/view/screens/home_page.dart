import 'dart:async';

import 'package:demo_tefpaygo_simples/view/screens/commands_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:receive_intent/receive_intent.dart' as receive_intent;

import '../../controller/paygo_request_handler.dart';
import '../../controller/paygo_response_handler.dart';
import '../../utils/paygo_request_handler_helper.dart';
import '../widget/button.dart';
import 'config/config_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Widget> _pages = [
    CommandPage(title: "Comandos"),
    ConfigurationPage(),
  ];
  int _currentIndex = 0;


  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: setCurrentIndex,
          items: [

            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Comandos",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Configurações",
            ),
          ]
      ),
    );
  }
}

