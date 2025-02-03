import 'dart:async';

import 'package:demo_tefpaygo_simples/utils/paygo_consts.dart';
import 'package:demo_tefpaygo_simples/utils/paygo_sdk_helper.dart';
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
   * Metodo para tratar a transacao de venda
   */
  void handleTransacaoVenda(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "VENDA") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          confirmarTransacao(
              resposta.transactionId); //confirma a transacao automaticamente
          imprimirComprovante(resposta.merchantReceipt);
          mostrarDialogoImpressao(resposta.cardholderReceipt, "Imprimir via do Cliente?");
        } else {
          //tratar transacao pendente

          if (resposta?.transactionResult ==
              PayGoRetornoConsts.PWRET_FROMHOSTPENDTRN) {
            //resolverPendencia(resposta?.uri);
            ;
          }

          //tratar outros erros
        }
      }
    }
  }

  /**
   * Metodo para tratar a transacao de reimpressao
   */

  void handleTransacaoReimpressao(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "REIMPRESSAO") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          imprimirComprovante(resposta.merchantReceipt);
          mostrarDialogoImpressao(resposta.cardholderReceipt, "Imprimir via do Cliente?");
        }
      }
    }
  }

  /**
   * Metodo (exemplo) para tratar transacao nao suportada
   */

  void handleTransacaoNaoSuportada(TransacaoRequisicaoResposta resposta) {}

  /**
   * Metodo para tratar a resposta do PayGo Integrado
   */
  void tratarRespostaPaygoIntegrado(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      switch (resposta.operation) {
        case "VENDA":
          handleTransacaoVenda(resposta);
          break;

        case "REIMPRESSAO":
          handleTransacaoReimpressao(resposta);
          break;

        case "MANUTENCAO":
          ;
          break;
        case "INSTALACAO":
          ;
          break;
        case "ADMINISTRATIVA":
          ;
          break;

        case "CANCELAMENTO":
          ;
          break;

        case "RELATORIO_SINTETICO":
          handleImprimeRelatorio(resposta);
          break;
        case "RELATORIO_DETALHADO":
          handleImprimeRelatorio(resposta);
          break;

        case "RELATORIO_RESUMIDO":
          handleImprimeRelatorio(resposta);
          break;

        case "TESTE_COMUNICACAO":
          ;
          break;

        case "EXIBE_PDC":
          handleExibePDC(resposta);
          break;
        case "OPERACAO_DESCONHECIDA":
          ;
          break;
        default:
          handleTransacaoNaoSuportada(resposta);
          break;
      }

      onChangePaygoIntegrado("Resposta do PayGo Integrado:\n" +
              "Operation: ${resposta?.operation} \n" +
              "ID: ${resposta?.transactionId}\n" +
              "Mensagem: ${resposta?.resultMessage}\n" +
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

  void onClickButtonConfiguracoes() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ConfigurationPage()));
  }

  void onClickButtonReimpressao() async {
    await repository.integrado.generico(
        intentAction: IntentAction.payment,
        requisicao:
            TransacaoRequisicaoGenerica(operation: Operation.reimpressao));
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

  void imprimirComprovante(String comprovante) async {
    try {
      await _printer.printText(comprovante);
      await _printer.cutPaper();
    } catch (e) {
      onChangePaygoIntegrado(_repostaPaygoIntegrado + "\n" + e.toString());
    }
  }

  void handleExibePDC(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "EXIBE_PDC") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          onChangePaygoIntegrado(resposta.resultMessage);
        }
      }
    }
  }


  void handleImprimeRelatorio(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation.startsWith("RELATORIO")) {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          String tipoRelatorio = resposta.operation
              .toLowerCase()
              .replaceAll("_"," ");
          mostrarDialogoImpressao(resposta.fullReceipt, "Imprimir $tipoRelatorio?");

        }
      }
    }
  }

  void mostrarDialogoImpressao(String conteudo, String titulo ) {
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
                  imprimirComprovante(conteudo);
                  Navigator.of(context).pop();
                },
                child: const Text("Imprimir"),
              ),
            ],
          );
        });
  }
}
