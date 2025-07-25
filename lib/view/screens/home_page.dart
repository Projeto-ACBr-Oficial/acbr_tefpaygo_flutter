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
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            title: Text(_titles[_currentIndex],),
          ),
          body: Center(child: _pages[_currentIndex]),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: setCurrentIndex,
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.payment),
                selectedIcon: Icon(Icons.payment),
                label: 'Pagamento',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                selectedIcon: Icon(Icons.settings),
                label: 'Configurações',
              ),
            ],
          ),
        );
      },
    );
  }
}