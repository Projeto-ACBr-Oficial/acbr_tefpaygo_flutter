import 'package:demo_tefpaygo_simples/view/screens/commands_page.dart';
import 'package:demo_tefpaygo_simples/controller/generic_printer.dart';
import 'package:demo_tefpaygo_simples/view/widget/custom_printer.dart';
import 'package:flutter/material.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_resposta.dart';
import 'package:tectoy_sunmiprinter/tectoy_sunmiprinter.dart';

import '../../controller/paygo_response_callback.dart';
import '../../controller/paygo_response_handler.dart';
import 'config/config_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    implements PayGoResponseCallback {
  final GenericPrinter _customPrinter = CustomPrinter();
  late PayGOResponseHandler _responseHandler;

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
      canPop: false,
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
              ])),
    );
  }

  /**
   * Metodo para inicializar o listener de intent
   * Esse metodo obtem a resposta do PayGo Integrado
   */

  void _initIntentListener() {
    _responseHandler.inicializar();
    //existem situações em que a regra de negócio não deve confirmar automaticamente uma transação
    //nesse caso, o método setIsAutoConfirm deve ser chamado com o valor false
    //responseHandler.setIsAutoConfirm(false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _responseHandler.finalizar();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _responseHandler = PayGOResponseHandler(this);
    _initIntentListener();
  }

  /**
   *  Metodo que implementa a impressão de uma reposta do PayGo Integrado
   */
  @override
  void onPrinter(TransacaoRequisicaoResposta resposta) {
    _customPrinter.printerText(resposta.merchantReceipt);

    switch (resposta.operation) {
      case "VENDA":
      case "REIMPRESSAO":
        mostrarDialogoImpressao(
            context, resposta.cardholderReceipt, "Imprimir via do cliente?");
        break;
      case "CANCELAMENTO":
        mostrarDialogoImpressao(context,
            resposta.cardholderReceipt, "Comprovante de cancelamento?");
        break;

      case "RELATORIO_SINTETICO":
      case "RELATORIO_DETALHADO":
      case "RELATORIO_RESUMIDO":
        mostrarDialogoImpressao(
            context, resposta.fullReceipt, "Imprimir Relatorio?");
        break;
      default:
        onReceiveMessage("Operação não suportada");
    }
  }

  /**
   * Metodo que implementa a exibição de uma mensagem do PayGo Integrado
   */

  @override
  void onReceiveMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Resposta do PayGo Integrado"),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Fechar"),
              ),
            ],
          );
        });
  }

  void mostrarDialogoImpressao(BuildContext context, String conteudo, String titulo) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titulo),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Fechar"),
              ),
              TextButton(
                onPressed: () {
                  _customPrinter.printerText(conteudo);
                  Navigator.of(context).pop();
                },
                child: const Text("Imprimir"),
              ),
            ],
          );
        });
  }
}
