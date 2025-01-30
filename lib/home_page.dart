import 'package:demo_tefpaygo_simples/utils/paygo_consts.dart';
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
              MaterialButton(
                  minWidth: 250,
                  onPressed: onclickButtonVenda,
                  child: const Text('Venda'),
                  color: Theme.of(context).colorScheme.surfaceContainerLowest),
              MaterialButton(
                  minWidth: 250,
                  onPressed: onclickButtonLimparTela,
                  child: const Text('Limpar tela'),
                  color: Theme.of(context).colorScheme.surfaceContainerLowest),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onClickFloatingActionButton,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  /**
   * Metodo para tratar a resposta do PayGo Integrado
   */
  void tratarRespostaPaygoIntegrado(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "VENDA") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK)
          //confirma a venda se a resposta for OK
          confirmarVenda(resposta.transactionId);
        else if (resposta?.transactionResult ==
            PayGoRetornoConsts.PWRET_FROMHOSTPENDTRN) {
          ;
          //resolverPendencia(uri);
        }
      }
      onChangePaygoIntegrado(
          "Resposta do PayGo Integrado:\nOperation: ${resposta?.operation} \nID: ${resposta?.transactionId}\nMensagem: ${resposta?.resultMessage}\nResultado da transação: ${resposta?.transactionResult}");
    }
  }

  /**
   * Metodo para inicializar o listener de intent
   * Esse metodo obtem a resposta do PayGo Integrado
   */

  void _initIntentListener() {
    receive_intent.ReceiveIntent.receivedIntentStream
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _initIntentListener();
  }

  Future<void> confirmarVenda(String id) async {
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
      allowShortReceipt: false,
    );
    final dadosVenda = await TransacaoRequisicaoVenda(
      amount: _valorVenda,
      currencyCode: CurrencyCode.iso4217Real,
    );
    await repository.integrado
        .venda(
      requisicaoVenda: dadosVenda
        ..provider = "REDE"
        ..cardType = CardType.cartaoDebito
        ..finType = FinType.aVista,
    )
        .then((value) {
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

  void onClickFloatingActionButton() async {
    await repository.integrado.generico(
        requisicao: TransacaoRequisicaoGenerica(
          operation: Operation.instalacao,
        ),
        intentAction: IntentAction.interfaceautomacao);
    await repository.integrado.administrativo();
  }

  void onclickButtonVenda() async {
    if (_valorVenda == 0) {
      Fluttertoast.showToast(
          msg: "Informe o valor da venda",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
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
}
