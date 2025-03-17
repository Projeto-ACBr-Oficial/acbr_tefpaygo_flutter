import 'dart:io';

import 'package:demo_tefpaygo_simples/controller/custom_printer.dart';
import 'package:demo_tefpaygo_simples/controller/paygo_request_handler.dart';
import 'package:demo_tefpaygo_simples/controller/paygo_response_handler.dart';
import 'package:demo_tefpaygo_simples/controller/types/PendingTransactionActions.dart';
import 'package:demo_tefpaygo_simples/controller/types/generic_printer.dart';
import 'package:demo_tefpaygo_simples/controller/types/tef_paygo_callback.dart';
import 'package:demo_tefpaygo_simples/model/tef_paygo_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_resposta.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/transaction_status.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TefController>(TefController(), permanent: false);
  }

}

/**
 *  TefController é a classe que implenta as regras de negócio do TEF PayGo
 *  Propriedades configuráveis:
 * - _printer: Instância de [GenericPrinter]
 * - _configuracoes: Instância de [TefPayGoConfiguracoes]
 *
 */

class TefController extends GetxController implements TefPayGoCallBack {
  final PayGoRequestHandler _payGORequestHandler = PayGoRequestHandler();
  late GenericPrinter _printer = CustomPrinter();
  late PayGOResponseHandler _payGOResponseHandler;
  late TefPayGoConfiguracoes _configuracoes = TefPayGoConfiguracoes();
  static final VALOR_MINIMO_VENDA = 1.00;
  static final VALOR_MAXIMO_VENDA = 100000.000;

  // Getters e Setter
  PayGoRequestHandler get payGORequestHandler => _payGORequestHandler;
  PayGOResponseHandler get payGOResponseHandler => _payGOResponseHandler;
  TefPayGoConfiguracoes get configuracoes => _configuracoes;

  set configuracoes(TefPayGoConfiguracoes configuracoes) {
    _configuracoes = configuracoes;
  }

  set printer(GenericPrinter printer) {
    _printer = printer;
  }


  @override
  void onPrinter(TransacaoRequisicaoResposta resposta) {
    switch (resposta.operation) {
      case "VENDA":
      case "REIMPRESSAO":
      case "CANCELAMENTO":
        _printRecepits(resposta);
        break;

      case "INSTALACAO":
       _printInstall(resposta);
        break;
      break;

      case "RELATORIO_SINTETICO":
      case "RELATORIO_DETALHADO":
      case "RELATORIO_RESUMIDO":
        _printReport(resposta);
        break;

      default:
        onErrorMessage("Operação não suportada");
    }
  }

  @override
  void onSuccessMessage(String message) {
    _showDialog("Resultado", message, Colors.green, Icons.check_circle);
  }

  @override
  void onErrorMessage(String message) {
    _showDialog("Resultado", message, Colors.red, Icons.error);
  }

  void _showDialog(String title, String message, Color backgroundColor, IconData icon) {
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(color: Colors.white),
      backgroundColor: backgroundColor,
      middleText: message,
      barrierDismissible: false,
      radius: 10.0,
      content: Column(
        children: [
          Icon(icon, color: Colors.white, size: 50),
          SizedBox(height: 10),
          Text(message, style: TextStyle(color: Colors.white)),
        ],
      ),
    );

    Future.delayed(Duration(seconds: 3), () {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    });
  }


  @override
  void onFinishTransaction(TransacaoRequisicaoResposta response) {
    //aqui você pode implementar a lógica para salvar a transação no banco de dados, notas fiscais, etc
    if (checkRequirmentsToConfirmTransaction()) {
      if (! _configuracoes.isTestScript) {
        _payGORequestHandler.confirmarTransacao(
            response.transactionId, _configuracoes.tipoDeConfirmacao);
        onSuccessMessage(response.resultMessage);
      }else{
        ;
      }
    }
    //a impressão é opcional
    onPrinter(response);
  }

  @override
  void onPendingTransaction(String transactionPendingData) {

    switch (_configuracoes.pendingTransactionActions) {
      case PendingTransactionActions.CONFIRM:
      _payGORequestHandler.resolverPendencia(transactionPendingData, TransactionStatus.confirmadoManual);
        break;

      case PendingTransactionActions.MANUAL_UNDO:
        print('tentando desfazer xxxxxxxxx' + transactionPendingData);
        _payGORequestHandler.resolverPendencia(transactionPendingData);
        break;

      case PendingTransactionActions.NONE:
      default:
        print("Nenhuma ação definida para transação pendente");
        break;
    }
  }



  /**
   * Função auxiliar que verifica se os requisitos para confirmar a transação foram atendidos
   */

  @override
  bool checkRequirmentsToConfirmTransaction() {
    //aqui você pode implementar a lógica para verificar se os requisitos para confirmar a transação foram atendidos
    return _configuracoes.isAutoConfirm == true;
  }



  /**
   * Metodo auxiliar para imprimir o comprovante (via  do cliente)
   */
  void _printCardHolderReceipt(TransacaoRequisicaoResposta resposta) {
    if (_configuracoes.isPrintcardholderReceipt) {
      _printer.printerText(resposta.cardholderReceipt);
    }
  }


  /**
   * Metodo auxiliar para imprimir o relatório
   */
  void _printReport(TransacaoRequisicaoResposta resposta) {
    if (_configuracoes.isPrintReport) {
      _printer.printerText(resposta.fullReceipt);
    }
  }

  /**
   * Metodo auxiliar para imprimir os comprovantes
   */
  void _printRecepits(TransacaoRequisicaoResposta resposta) {
    if (_configuracoes.isPrintMerchantReceipt) _printer.printerText(resposta.merchantReceipt);
    _printCardHolderReceipt(resposta);
    //_printer.printerText(resposta.shortReceipt); //para roteiro de teste
  }

  void _printInstall(TransacaoRequisicaoResposta resposta){
    if ( resposta.fullReceipt != null){
      if ( resposta.fullReceipt.isNotEmpty){
        _printer.printerText(resposta.fullReceipt);
      }
    }
  }
  /**
   * Metodo auxiliar para converter o valor da transação para double
   */
  double _convertAmountToDouble (String amount){
    return double.parse(amount)/ 100.00;
  }



  // Métodos de controle de estado

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
    debugPrint("Fechando controller");
    _payGOResponseHandler.finalizar();
    super.onClose();

  }
}
