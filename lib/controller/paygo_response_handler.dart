import 'dart:async';
import 'dart:core';

import 'package:demo_tefpaygo_simples/controller/types/tef_paygo_callback.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_resposta.dart';
import 'package:receive_intent/receive_intent.dart' as receive_intent;

import '../utils/paygo_consts.dart';

/**
 * Classe para tratar as respostas do PayGo Integrado
 * Essencialmente essa classe recebe uma intent e chama a callback[TefPayGoCallBack] de acordo com a resposta
 */

class PayGOResponseHandler {
  final TefPayGoCallBack _callBack;

  late StreamSubscription _subscription;

  late receive_intent.Intent? _intent;

  PayGOResponseHandler(this._callBack);

  void inicializar() {
    _subscription = receive_intent.ReceiveIntent.receivedIntentStream
        .listen((receive_intent.Intent? intent) {
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
      _intent = intent;
      _processarResposta(resposta);
    }
  }

  void _processarResposta(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      switch (resposta.operation) {
        case "VENDA":
        case "CANCELAMENTO":
          _handleTransacao(resposta);
          break;

        case "REIMPRESSAO":
        case "RELATORIO_SINTETICO":
        case "RELATORIO_DETALHADO":
        case "RELATORIO_RESUMIDO":
        case "INSTALACAO":
          _handleImpressao(resposta);
          break;

        // não exigem ação imediata
        case "EXIBE_PDC":
        case "MANUTENCAO":
        case "ADMINISTRATIVA":
        case "TESTE_COMUNICACAO":
        case "OPERACAO_DESCONHECIDA":
        default:
          _handleOutraOperacao(resposta);
          break;
      }
    }
    _intent =null;
  }


  void _handleTransacao(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      String transactionResult = resposta.transactionResult.toString();
      switch (transactionResult) {
        case PayGoRetornoConsts.PWRET_OK:
          _callBack.onFinishTransaction(resposta);
          break;
        case PayGoRetornoConsts.PWRET_FROMHOSTPENDTRN:
          _callBack.onPendingTransaction(_getStringPendingData());
          break;
        default:
          _callBack.onReceiveMessage(resposta.resultMessage +
              "\n" +
              "Resultado da transação: ${resposta.transactionResult}");
          break;
      }
    }
  }


  void _handleOutraOperacao(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      _callBack.onReceiveMessage("Resposta do PayGo Integrado:\n" +
          "Operation: ${resposta?.operation} \n" +
          "${resposta?.resultMessage}\n"+
          "Resultado da transação: ${resposta?.transactionResult}\n" +
          "ID: ${resposta?.transactionId}\n"
          );
    }
  }

  /**
   * Método auxiliar para tratar a impressão
   */
  void _handleImpressao(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if ( resposta.transactionResult == PayGoRetornoConsts.PWRET_OK) {
        _callBack.onPrinter(resposta);
      } else {
        _callBack.onReceiveMessage(resposta.resultMessage);
      }
    }
  }

  /**
   * Método auxiliar para obter os dados da transação pendente
   */
  String _getStringPendingData() {
    return _intent?.extra?["TransacaoPendenteDados"] ?? "";
  }
}
