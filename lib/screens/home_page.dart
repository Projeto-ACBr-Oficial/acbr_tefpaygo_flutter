import 'dart:async';

import 'package:demo_tefpaygo_simples/utils/paygo_consts.dart';
import 'package:demo_tefpaygo_simples/widget/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_confirmacao.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_pendencia.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/card_type.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/fin_type.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/transaction_status.dart';
import 'package:paygo_sdk/paygo_sdk.dart';
import 'package:receive_intent/receive_intent.dart' as receive_intent;
import 'package:tectoy_sunmiprinter/tectoy_sunmiprinter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PayGOSdk repository = PayGOSdk();
  double _valorVenda = 0.0 as double;
  String _repostaPaygoIntegrado = "";
  late StreamSubscription _subscription;
  late TectoySunmiprinter _printer = TectoySunmiprinter();

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
              Button(
                onPressed: onclickButtonLimparTela,
                text: 'Limpar tela',
              ),
              Button(
                onPressed: onclickButtonInstalacao,
                text: 'Abrir menu de instalação',
              ),
              Button(
                onPressed: onclickButtonManutencao,
                text: 'Abrir menu de manutenção',
              ),
              Button(
                onPressed: onclickButtonPainelAdministrativo,
                text: 'Abrir Painel Administrativo',
              ),
            ]),
      ),
    );
  }

  /**
   * Metodo para tratar a resposta do PayGo Integrado
   */

  void tratarRespostaPaygoIntegrado(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "VENDA") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          confirmarTransacao(resposta.transactionId);
          imprimirComprovante(resposta.merchantReceipt);
          mostrarDialogoImprimirViaDoCliente(resposta.cardholderReceipt);
        }

        else if (resposta?.transactionResult ==
            PayGoRetornoConsts.PWRET_FROMHOSTPENDTRN) {
          ;
          //resolverPendencia(uri);
        }
      }
      onChangePaygoIntegrado("Resposta do PayGo Integrado:\n" +
          "Operation: ${resposta?.operation} \n" +
          "ID: ${resposta?.transactionId}\n"+
          "Mensagem: ${resposta?.resultMessage}\n"+
          "Resultado da transação: ${resposta?.transactionResult}\n"
         // "cardholderReceipt: ${resposta?.cardholderReceipt}\n" + //via do cliente
         // "merchantReceipt: ${resposta?.merchantReceipt}\n" //via do estabelecimento

      );
    }
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
        tratarRespostaPaygoIntegrado(resposta);
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
    _initIntentListener();
  }

  Future<void> confirmarTransacao(String id) async {
    await repository.integrado
        .confirmarTransacao(
      intentAction: IntentAction.confirmation,
      requisicao: TransacaoRequisicaoConfirmacao(
        confirmationTransactionId: id,
        status: TransactionStatus.confirmadoAutomatico,
      ),
    )
        .then((value) {
      print("Venda confirmada");
    }).catchError((error) {
      print("Erro ao confirmar venda: $error");
    });
  }

  Future<void> realizarVenda() async {
    // configura dados da automacao (obrigatorio  para o TefPayGo)
    final dadosAutomacao = await TransacaoRequisicaoDadosAutomacao(
      "Exemplo TEF",
      "1.0",
      "ACBr",
      allowCashback: true,
      allowDifferentReceipts: true,
      allowDiscount: true,
      allowDueAmount: true,
      allowShortReceipt: true,
    );
    final dadosVenda = await TransacaoRequisicaoVenda(
      amount: _valorVenda,
      currencyCode: CurrencyCode.iso4217Real,
    );
    await repository.integrado.venda(requisicaoVenda: dadosVenda).then((value) {
      // changeStatusVenda("Venda enviada: " + dadosVenda.obterIdTransacao);
    }).catchError((error) {
      //changeStatusVenda("Erro ao enviar venda: $error");
    });
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
    await realizarVenda();
  }

  void onclickButtonLimparTela() {
    setState(() {
      _repostaPaygoIntegrado = "";
    });

    setState(() {
      _valorVenda = 0.0;
    });
  }

  void onclickButtonInstalacao() async {
    await repository.integrado.generico(
        requisicao: TransacaoRequisicaoGenerica(
          operation: Operation.instalacao,
        ),
        intentAction: IntentAction.payment);
  }

  void onclickButtonManutencao() async {
    await repository.integrado.generico(
      requisicao: TransacaoRequisicaoGenerica(
        operation: Operation.manutencao,
      ),
      intentAction: IntentAction.payment,
    );
  }

  void onclickButtonPainelAdministrativo() async {
    await repository.integrado.administrativo();
  }

  /**
   * Metodo para resolver pendencia
   */

  void resolverPendencia(Uri uri) async {
    if (uri != null) {
      await repository.integrado.resolucaoPendencia(
        intentAction: IntentAction.confirmation,
        requisicaoPendencia: uri.toString(),
        requisicaoConfirmacao: TransacaoRequisicaoPendencia(
          status: TransactionStatus.desfeitoManual,
        ),
      );
    }
  }

  void imprimirComprovante(String comprovante)  async{
    try {
      await _printer.printText(comprovante);
      await _printer.cutPaper();
    } catch (e) {
      onChangePaygoIntegrado(_repostaPaygoIntegrado +"\n" + e.toString());
    }
  }

  void  mostrarDialogoImprimirViaDoCliente(String comprovante) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Imprimir via do cliente?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Fechar"),
              ),
              TextButton(
                onPressed: () {
                  imprimirComprovante(comprovante);
                  Navigator.of(context).pop();
                },
                child: const Text("Imprimir"),
              ),
            ],
          );
        });
  }
}
