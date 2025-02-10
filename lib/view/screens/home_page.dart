import 'dart:async';

import 'package:demo_tefpaygo_simples/view/screens/commands_page.dart';
import 'package:flutter/material.dart';
import 'package:receive_intent/receive_intent.dart' as receive_intent;

import '../../controller/paygo_response_handler.dart';
import 'config/config_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamSubscription _subscription;


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
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool dip, dynamic result) {
        setCurrentIndex(0);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
              ])
      ),
    );
  }

  /**
   * Metodo para inicializar o listener de intent
   * Esse metodo obtem a resposta do PayGo Integrado
   */

  void _initIntentListener() {
    _subscription = receive_intent.ReceiveIntent.receivedIntentStream
        .listen((receive_intent.Intent? intent) {
      PayGOResponseHandler responseHandler = PayGOResponseHandler(context);

      //existem situações em que a regra de negócio não deve confirmar automaticamente uma transação
      //nesse caso, o método setIsAutoConfirm deve ser chamado com o valor false
      //responseHandler.setIsAutoConfirm(false);
      responseHandler.processarResposta(intent);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _subscription?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initIntentListener();
  }
}
