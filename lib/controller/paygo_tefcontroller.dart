import 'package:demo_tefpaygo_simples/controller/custom_printer.dart';
import 'package:demo_tefpaygo_simples/controller/paygo_request_handler.dart';
import 'package:demo_tefpaygo_simples/controller/paygo_response_handler.dart';
import 'package:demo_tefpaygo_simples/controller/types/pending_transaction_actions.dart';
import 'package:demo_tefpaygo_simples/controller/types/generic_printer.dart';
import 'package:demo_tefpaygo_simples/controller/types/tef_paygo_callback.dart';
import 'package:demo_tefpaygo_simples/model/tef_paygo_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_resposta.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/transaction_status.dart';

import '../utils/paygo_consts.dart';

///
/// *  [TefController] é a classe que implenta as regras de negócio do TEF PayGo
/// *  Propriedades configuráveis:
/// * - [_printer]: Instância de [GenericPrinter]
/// * - [_configuracoes]: Instância de [TefPayGoConfiguracoes]
///
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
  Future<void> onPrinter(TransacaoRequisicaoResposta resposta) async {
    switch (resposta.operation) {
      case "VENDA":
      case "REIMPRESSAO":
      case "CANCELAMENTO":
        await _printRecepits(resposta);
        break;

      case "INSTALACAO":
        await _printer.printerText(resposta.fullReceipt);
        break;

      case "RELATORIO_SINTETICO":
      case "RELATORIO_DETALHADO":
      case "RELATORIO_RESUMIDO":
        await _printReport(resposta);
        break;

      default:
        await onErrorMessage("Operação não suportada");
    }
  }

  @override
  Future<void> onSuccessMessage(String message) async {
    await _showDialog("Resultado:", message, Colors.green, Icons.check_circle);
  }

  @override
  Future<void> onErrorMessage(String message) async {
    await _showDialog("Erro:", message, Colors.red, Icons.error);
    await Get.toNamed('/failure_screen', arguments: message);
  }

  /// [_showDialog] é um método auxiliar para mostrar diálogos de sucesso ou erro
  /// * [title] é o título do diálogo
  /// * [message] é a mensagem a ser exibida
  /// * [backgroundColor] é a cor de fundo do diálogo
  /// * [icon] é o ícone a ser exibido no diálogo
  Future<void> _showDialog(String title, String message, Color backgroundColor,
      IconData icon) async {
    await Future.wait([
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
      ),
      Future.delayed(Duration(seconds: 3), () {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      })
    ]);
  }

  @override
  void onFinishTransaction(TransacaoRequisicaoResposta response) async {
    //aqui você pode implementar a lógica para salvar a transação no banco de dados, notas fiscais, etc
    if (checkRequirmentsToConfirmTransaction()) {
      await _payGORequestHandler.confirmarTransacao(
          response.confirmationTransactionId, _configuracoes.tipoDeConfirmacao);
      await onSuccessMessage(response.resultMessage);
      //a impressão é opcional
      await onPrinter(response);
      await Get.offNamedUntil('/home',
          (route) => Get.isDialogOpen == false); // Redireciona para a tela i
    }
  }

  @override
  void onPendingTransaction(String transactionPendingData) async {
    switch (_configuracoes.pendingTransactionActions) {
      case PendingTransactionActions.CONFIRM:
        await _payGORequestHandler.resolverPendencia(
            transactionPendingData, TransactionStatus.confirmadoManual);
        break;

      case PendingTransactionActions.MANUAL_UNDO:
        await _payGORequestHandler.resolverPendencia(transactionPendingData);
        break;

      case PendingTransactionActions.NONE:
      default:
        debugPrint("Nenhuma ação definida para transação pendente");
        break;
    }
  }

  @override
  void onFinishOperation(TransacaoRequisicaoResposta response) async {
    switch (response.operation) {
      case "REIMPRESSAO":
      case "RELATORIO_SINTETICO":
      case "RELATORIO_DETALHADO":
      case "RELATORIO_RESUMIDO":
        await onPrinter(response);
        break;

      case "INSTALACAO":
        await _handleInstall(response);
        break;

      case "EXIBE_PDC":
      case "MANUTENCAO":
      case "ADMINISTRATIVA":
      case "TESTE_COMUNICACAO":
      case "OPERACAO_DESCONHECIDA":
      default:
        await _handleOutraOperacao(response);
        break;
    }
  }

  Future<void> _handleOutraOperacao(
      TransacaoRequisicaoResposta resposta) async {
    if (resposta != null) {
      if (resposta.transactionResult == PayGoRetornoConsts.PWRET_OK)
        await onSuccessMessage(resposta.resultMessage);
      else
        await onErrorMessage(resposta.resultMessage);
    }
  }

  /// Função auxiliar que verifica se os requisitos para confirmar a transação foram atendidos

  @override
  bool checkRequirmentsToConfirmTransaction() {
    //aqui você pode implementar a lógica para verificar se os requisitos para confirmar a transação foram atendidos
    return _configuracoes.isAutoConfirm == true;
  }

  /// Metodo auxiliar para imprimir o comprovante (via  do cliente)
  Future<void> _printCardHolderReceipt(
      TransacaoRequisicaoResposta resposta) async {
    if (_configuracoes.isPrintcardholderReceipt) {
      await _printer.printerText(resposta.cardholderReceipt);
    }
  }

  /// Metodo auxiliar para imprimir o relatório
  Future<void> _printReport(TransacaoRequisicaoResposta resposta) async {
    if (_configuracoes.isPrintReport) {
      if (resposta.fullReceipt != "")
        await _printer.printerText(resposta.fullReceipt);
    }
  }

  /// Metodo auxiliar para imprimir os comprovantes
  Future<void> _printRecepits(TransacaoRequisicaoResposta resposta) async {
    if (_configuracoes.isPrintMerchantReceipt)
      await _printer.printerText(resposta.merchantReceipt);
    await _printCardHolderReceipt(resposta);

    if (_configuracoes.isPrintShortReceipt)
      await _printer.printerText(resposta.shortReceipt); //para roteiro de teste
  }

  /// Metodo auxiliar para tratar a instalação

  Future<void> _handleInstall(TransacaoRequisicaoResposta resposta) async {
    if (resposta.transactionResult == PayGoRetornoConsts.PWRET_OK) {
      await onPrinter(resposta);
      await onSuccessMessage(resposta.resultMessage);
    } else {
      await onErrorMessage(resposta.resultMessage);
    }
  }

  /// Métodos de controle de estado

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
    super.onClose();
    _payGOResponseHandler.finalizar();
  }
}
