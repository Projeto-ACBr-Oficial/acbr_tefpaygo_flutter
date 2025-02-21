import 'package:demo_tefpaygo_simples/controller/custom_printer.dart';
import 'package:demo_tefpaygo_simples/controller/paygo_request_handler.dart';
import 'package:demo_tefpaygo_simples/controller/paygo_response_handler.dart';
import 'package:demo_tefpaygo_simples/controller/types/PendingTransactionActions.dart';
import 'package:demo_tefpaygo_simples/controller/types/generic_printer.dart';
import 'package:demo_tefpaygo_simples/controller/types/tef_paygo_callback.dart';
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

/**
 *  TefController é a classe que implenta as regras de negócio do TEF PayGo
 *  Propriedades configuráveis:
 * - _printer: Instância de [GenericPrinter]
 * - _isAutoConfirm: booleano que define se a transação deve ser confirmada automaticamente
 * - _isPrintcardholderReceipt: booleano que define se o comprovante do cliente deve ser impresso
 *  - _isPrintMerchantReceipt: booleano que define se o comprovante do estabelecimento deve ser impresso
 *  - _isPrintReport: booleano que define se o relatório deve ser impresso
 *  - _pendingTransactionActions (enumerado) que define a ação a ser tomada quando a transação está pendente
 *
 */

class TefController extends GetxController implements TefPayGoCallBack {

  final PayGoRequestHandler _payGORequestHandler = PayGoRequestHandler();
  late GenericPrinter _printer = CustomPrinter();
  late PayGOResponseHandler _payGOResponseHandler;
  late bool _isAutoConfirm = true;
  late bool _isPrintcardholderReceipt = true;
  late bool _isPrintMerchantReceipt = true;
  late bool _isPrintReport = true;

  late PendingTransactionActions _pendingTransactionActions = PendingTransactionActions.CONFIRM;

  get pendingTransactionActions => _pendingTransactionActions;
  get isAutoConfirm => _isAutoConfirm;
  get isPrintcardholderReceipt => _isPrintcardholderReceipt;
  get isPrintMerchantReceipt => _isPrintMerchantReceipt;
  get isPrintReport => _isPrintReport;
  get payGORequestHandler => _payGORequestHandler;
  get payGOResponseHandler => _payGOResponseHandler;

  void setPendingTransactionActions(PendingTransactionActions pendingTransactionActions) {
    _pendingTransactionActions = pendingTransactionActions;
  }

  void setIsPrintReport(bool isPrintReport) {
    _isPrintReport = isPrintReport;
  }

  void setIsPrintcardholderReceipt(bool isPrintcardholderReceipt) {
    _isPrintcardholderReceipt = isPrintcardholderReceipt;
  }

  void setIsPrintMerchantReceipt(bool isPrintMerchantReceipt) {
    _isPrintMerchantReceipt = isPrintMerchantReceipt;
  }

  void setIsAutoConfirm(bool isAutoConfirm) {
    _isAutoConfirm = isAutoConfirm;
  }

  void setPrinter(GenericPrinter printer) {
    _printer = printer;
  }

  @override
  void onFinishTransaction(TransacaoRequisicaoResposta response) {

    //aqui você pode implementar a lógica para salvar a transação no banco de dados, notas fiscais, etc
    if (checkRequirmentsToConfirmTransaction()) {
      _payGORequestHandler.confirmarTransacao(response.transactionId);
    }
    //a impressão é opcional
    onPrinter(response);

    //
  }
  @override
  void onPendingTransaction(String transactionPendingData) {
    // TODO: implement onPendingTransaction
    switch (_pendingTransactionActions) {

      case PendingTransactionActions.CONFIRM:
        String id = Uri.parse(transactionPendingData).queryParameters["transactionId"] ?? "";
        _payGORequestHandler.confirmarTransacao(id);
        break;

      case PendingTransactionActions.MANUAL_UNDO:
        _payGORequestHandler.resolverPendencia(Uri.parse(transactionPendingData));
        break;

      case PendingTransactionActions.NONE:
      default:
        print("Nenhuma ação definida para transação pendente");
        break;
    }
  }


  @override
  void onPrinter(TransacaoRequisicaoResposta resposta) {

    switch (resposta.operation) {
      case "VENDA":
      case "REIMPRESSAO":
      case "CANCELAMENTO":
        _printRecepits(resposta)  ;

        break;

      case "RELATORIO_SINTETICO":
      case "RELATORIO_DETALHADO":
      case "RELATORIO_RESUMIDO":
        _printReport(resposta);
        break;

      default:
        onReceiveMessage("Operação não suportada");
    }
  }

  @override
  void onReceiveMessage(String message) {
    showDialog(
        context: Get.context!,
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


  /**
   * Função auxiliar que verifica se os requisitos para confirmar a transação foram atendidos
    */

  @override
  bool checkRequirmentsToConfirmTransaction() {
    //aqui você pode implementar a lógica para verificar se os requisitos para confirmar a transação foram atendidos
      return _isAutoConfirm == true ;
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

  /**
   * Metodo auxiliar para imprimir o comprovante (via  do cliente)
   */
  void _printCardHolderReceipt(TransacaoRequisicaoResposta resposta) {
    if (_isPrintcardholderReceipt) {
      _printer.printerText(resposta.cardholderReceipt);
    }
  }

  /**
   * Metodo auxiliar para imprimir o relatório
   */
  void _printReport(TransacaoRequisicaoResposta resposta) {
    if (_isPrintReport) {
      _printer.printerText(resposta.fullReceipt);
    }
  }

  /**
   * Metodo auxiliar para imprimir os comprovantes
   */
  void _printRecepits(TransacaoRequisicaoResposta resposta) {
    if (_isPrintMerchantReceipt)
      _printer.printerText(resposta.merchantReceipt);
    _printCardHolderReceipt(resposta);
  }
}
