import 'package:demo_tefpaygo_simples/controller/custom_printer.dart';
import 'package:demo_tefpaygo_simples/controller/paygo_request_handler.dart';
import 'package:demo_tefpaygo_simples/controller/paygo_response_handler.dart';
import 'package:demo_tefpaygo_simples/controller/types/generic_printer.dart';
import 'package:demo_tefpaygo_simples/controller/types/paygo_response_callback.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_resposta.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TefController>(() => TefController());
  }
}
class TefController extends GetxController implements PayGoResponseCallback{
  final PayGoRequestHandler _payGORequestHandler = PayGoRequestHandler();
  final GenericPrinter _printer = CustomPrinter(); 
  late PayGOResponseHandler _payGOResponseHandler;

  get payGORequestHandler => _payGORequestHandler;
  get payGOResponseHandler => _payGOResponseHandler;

  @override
  void onFinishTransaction(TransacaoRequisicaoResposta response) {
    // TODO: implement onFinishTransaction
    //a impressão é opcional
    onPrinter(response);
    //aqui você deve chamar a regra de negócio para finalizar a transação
    //por exemplo, salvar a transação no banco de dados
  }

  @override
  void onPendingTransaction(String transactionPendingData) {
    // TODO: implement onPendingTransaction
    showDialog(
        context: Get.context!,
        builder: (BuildContext context){
          return AlertDialog(
              title: Text("Transação Pendente"),
              actions: [
                TextButton(
                  onPressed: () {
                    String id = Uri.parse(transactionPendingData).queryParameters["transactionId"] ?? "";
                    _payGORequestHandler.confirmarTransacao(id);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Confirmar"),
                ),
                TextButton(
                  onPressed: () {
                    _payGORequestHandler.resolverPendencia(Uri.parse(transactionPendingData));
                    Navigator.of(context).pop();
                  },
                  child: const Text("Desfazer"),
                ),
              ]);
        });
  }

  @override
  void onPrinter(TransacaoRequisicaoResposta resposta) {
    // TODO: implement onPrinter
    _printer.printerText(resposta.merchantReceipt);

    switch (resposta.operation) {
      case "VENDA":
      case "REIMPRESSAO":
        mostrarDialogoImpressao(
            Get.context!, resposta.cardholderReceipt, "Imprimir via do cliente?");
        break;
      case "CANCELAMENTO":
        mostrarDialogoImpressao(  Get.context!,
            resposta.cardholderReceipt, "Comprovante de cancelamento?");
        break;

      case "RELATORIO_SINTETICO":
      case "RELATORIO_DETALHADO":
      case "RELATORIO_RESUMIDO":
        mostrarDialogoImpressao(
              Get.context!, resposta.fullReceipt, "Imprimir Relatorio?");
        break;
      default:
        onReceiveMessage("Operação não suportada");
    }
  }

  @override
  void onReceiveMessage(String message) {
    showDialog(
        context: Get.context !,
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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _payGOResponseHandler = PayGOResponseHandler(this);
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _payGOResponseHandler.inicializar();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    _payGOResponseHandler.finalizar();
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
                  _printer.printerText(conteudo);
                  Navigator.of(context).pop();
                },
                child: const Text("Imprimir"),
              ),
            ],
          );
        });
  }


}