import 'dart:async';

import 'package:demo_tefpaygo_simples/utils/paygo_sdk_helper.dart';
import 'package:demo_tefpaygo_simples/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paygo_sdk/paygo_sdk.dart';
import 'package:receive_intent/receive_intent.dart' as receive_intent;

import '../controller/paygo_request_handler.dart';
import '../controller/paygo_response_handler.dart';
import '../utils/paygo_request_handler_helper.dart';
import 'config/config_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PayGOSdk repository = PayGOSdkHelper().paygoSdk;
  double _valorVenda = 0.0 as double;
  String _repostaPaygoIntegrado = "";
  late StreamSubscription _subscription;
  late PayGOResponseHandler _payGOResponseHandler;
  final PayGoRequestHandler _payGORequestHandler = PayGoRequestHandlerHelper().payGoRequestHandler;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: <Widget>[
              Container(
                width: 250,
                child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: onChangeInputValorVenda,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Valor da venda',
                    )),
              ),
              Text(
                _repostaPaygoIntegrado,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Button(
                onPressed: onclickButtonVenda,
                text: 'Venda',
              ),
              Button(onPressed: onClickButtonReimpressao, text: "Reimpressão"),
              Button(
                onPressed: onclickButtonLimparTela,
                text: 'Limpar tela',
              ),
              Button(
                  text: "Configurações", onPressed: onClickButtonConfiguracoes),
            ]),
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
      if (intent?.data != null) {
        final Uri uri = Uri.parse(intent?.data ?? '');
        final String decodedUri = Uri.decodeFull(uri.toString());
        TransacaoRequisicaoResposta? resposta;
        resposta = TransacaoRequisicaoResposta.fromUri(decodedUri);
        _payGOResponseHandler.tratarRespostaPaygoIntegrado(resposta);
      }
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
    _payGOResponseHandler = PayGOResponseHandler(context, onChangePaygoIntegrado, getPaygoIntegrado);
    _initIntentListener();
  }

  void onChangeInputValorVenda(String valor) {
    setState(() {
      _valorVenda = double.parse(valor);
    });
  }

  void onChangePaygoIntegrado(String response) {
    setState(() {
      _repostaPaygoIntegrado = response;
    });
  }

  void onclickButtonVenda() async {
    if (_valorVenda < 1) {
      Fluttertoast.showToast(
          msg: "Valor mínimo é R\$1,00",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).colorScheme.error,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    await _payGORequestHandler.realizarVenda(_valorVenda);
  }

  void onclickButtonLimparTela() {
    setState(() {
      _repostaPaygoIntegrado = "";
    });

    setState(() {
      _valorVenda = 0.0;
    });

  }

  void onClickButtonConfiguracoes() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ConfigurationPage()));
  }

  void onClickButtonReimpressao() async {
    await _payGORequestHandler.reimpressao();
  }

  String getPaygoIntegrado() {
    return _repostaPaygoIntegrado;
  }

}

