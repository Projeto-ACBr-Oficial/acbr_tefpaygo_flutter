import 'package:demo_tefpaygo_simples/view/screens/commands_page.dart';
import 'package:flutter/material.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final TefController _tefController = Get.put(TefController());
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
                  label: "Home",
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "Configurações",
                ),
              ])),
    );
  }



}
