import 'dart:async';

import 'package:demo_tefpaygo_simples/controller/paygo_response_callback.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_resposta.dart';
import 'package:receive_intent/receive_intent.dart' as receive_intent;

import '../utils/paygo_consts.dart';
import '../utils/paygo_request_handler_helper.dart';

/**
 * Classe para tratar as respostas do PayGo Integrado
 */

class PayGOResponseHandler {
  final _payGORequestHandler = PayGoRequestHandlerHelper().payGoRequestHandler;
  bool _isAutoConfirm = true;
  final PayGoResponseCallback _callBack;

  late StreamSubscription _subscription;


  get isAutoConfirm => _isAutoConfirm;


  void setIsAutoConfirm(bool value) {
    _isAutoConfirm = value;
  }

  PayGOResponseHandler(this._callBack);


  void inicializar() {
    _subscription = receive_intent.ReceiveIntent.receivedIntentStream
        .listen((receive_intent.Intent? intent) {

      //existem situações em que a regra de negócio não deve confirmar automaticamente uma transação
      //nesse caso, o método setIsAutoConfirm deve ser chamado com o valor false
      //responseHandler.setIsAutoConfirm(false);
      this._processarIntent(intent);
    });
  }

  void finalizar() {
    _subscription.cancel();
  }

  /**
   * Metodo para tratar a resposta do PayGo Integrado
   */

  void _processarIntent(receive_intent.Intent? intent) {
    if (intent?.data != null) {
      final Uri uri = Uri.parse(intent?.data ?? '');
      final String decodedUri = Uri.decodeFull(uri.toString());
      TransacaoRequisicaoResposta? resposta;
      resposta = TransacaoRequisicaoResposta.fromUri(decodedUri);
      _processarResposta(resposta);
      print("intent data = $intent?.data");
    }
  }

  void _processarResposta(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      switch (resposta.operation) {
        case "VENDA":
          _handleTransacaoVenda(resposta);
          break;

        case "REIMPRESSAO":
          _handleTransacaoReimpressao(resposta);
          break;

        case "CANCELAMENTO":
          _handleCancelamento(resposta);
          break;

        case "RELATORIO_SINTETICO":
        case "RELATORIO_DETALHADO":
        case "RELATORIO_RESUMIDO":
          _handleImprimeRelatorio(resposta);
          break;

        case "EXIBE_PDC":
          _handleExibePDC(resposta);
          break;
        // não exigem ação imediata
        case "MANUTENCAO":
        case "INSTALACAO":
        case "ADMINISTRATIVA":
        case "TESTE_COMUNICACAO":
        case "OPERACAO_DESCONHECIDA":
        default:
          _handleOutraOperacao(resposta);
          break;
      }
    }
  }

  void _handleExibePDC(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "EXIBE_PDC") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          _callBack.onReceiveMessage(resposta.resultMessage);
        }
      }
    }
  }

  void _handleCancelamento(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "CANCELAMENTO") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          if ( _isAutoConfirm) {
            _payGORequestHandler.confirmarTransacao(resposta.transactionId);
          }
          _callBack.onPrinter(resposta);
        }else
          _callBack.onReceiveMessage(resposta.resultMessage);
      }
    }
  }

  void _handleImprimeRelatorio(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation.startsWith("RELATORIO")) {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          String tipoRelatorio = resposta.operation
              .toLowerCase()
              .replaceAll("_", " ")
              .capitalizeFirstofEach();
          _callBack.onPrinter(resposta);
        }else
          _callBack.onReceiveMessage(resposta.resultMessage);
      }
    }
  }

  /**
   * Metodo para tratar a transacao de venda
   */
  void _handleTransacaoVenda(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "VENDA") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          if ( _isAutoConfirm) {
          _payGORequestHandler.confirmarTransacao(
              resposta.transactionId); //confirma a transacao automaticamente
          }
          _callBack.onPrinter(resposta);

        } else {

          // para este exemplo, apenas exibe a mensagem de erro
          _callBack.onReceiveMessage(resposta.resultMessage);

          // // exemplo de tratamento de erro:
          // if ( resposta.resultCode == PayGoRetornoConsts.PWRET_NOTHING ) {
          //   _showMessage("Nenhuma ação foi realizada");
          // }
        }
      }
    }
  }

  /**
   * Metodo para tratar a transacao de reimpressao
   */

  void _handleTransacaoReimpressao(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "REIMPRESSAO") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          _callBack.onPrinter(resposta);
        }else {
           _callBack.onReceiveMessage(resposta.resultMessage);
        }
      }
    }
  }

  void _handleOutraOperacao(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      _callBack.onReceiveMessage("Resposta do PayGo Integrado:\n" +
              "Operation: ${resposta?.operation} \n" +
              "ID: ${resposta?.transactionId}\n" +
              "Mensagem: ${resposta?.resultMessage}\n" +
              "Resultado da transação: ${resposta?.transactionResult}\n"
          // "cardholderReceipt: ${resposta?.cardholderReceipt}\n" + //via do cliente
          // "merchantReceipt: ${resposta?.merchantReceipt}\n" //via do estabelecimento

          );
    }
  }

}

extension on String {
  String capitalizeFirstofEach() {
    return this
        .split(" ")
        .map((str) => str[0].toUpperCase() + str.substring(1))
        .join(" ");
  }
}
