import 'package:demo_tefpaygo_simples/view/screens/payment_page.dart';
import 'package:flutter/material.dart';
import 'config/config_page.dart';

class MyHomePage extends StatefulWidget {

  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _titles = ["Pagamento", "Configurações"];
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
    debugPrint(" home page initState");
    super.initState();
  }

  @override
  void dispose() {
    debugPrint("home_page dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            titleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            title: Text(_titles[_currentIndex],),
          ),
          body: Center(child: _pages[_currentIndex]),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.2),
                  spreadRadius: 3.0,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              selectedItemColor: Theme.of(context).colorScheme.onSurface,
              unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              elevation: 0,
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
              ],
            ),
          ),
        );
      },
    );
  }
}