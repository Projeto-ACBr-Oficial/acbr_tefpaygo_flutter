import 'dart:async';
import 'dart:core';

import 'package:demo_tefpaygo_simples/controller/types/tef_paygo_callback.dart';
import 'package:flutter/cupertino.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_resposta.dart';
import 'package:receive_intent/receive_intent.dart' as receive_intent;

import '../utils/paygo_consts.dart';

///
///  Classe para tratar as respostas do PayGo Integrado
///  Essencialmente essa classe recebe uma intent e chama a callback[TefPayGoCallBack] de acordo com a resposta

class PayGOResponseHandler {
  final TefPayGoCallBack _callBack;

  late StreamSubscription _subscription;

  late receive_intent.Intent? _intent;

  PayGOResponseHandler(this._callBack);

  /// Método para inicializar o handler e escutar as intents recebidas
  void inicializar() {
    _subscription = receive_intent.ReceiveIntent.receivedIntentStream
        .listen((receive_intent.Intent? intent) {
      _processarIntent(intent);
    });
  }

  /// Método para finalizar o handler e cancelar a escuta das intents

  void finalizar() {
    debugPrint("Finalizando o PayGOResponseHandler");
    _subscription.cancel();
  }

  // Metodo para tratar a resposta do PayGo Integrado

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

  // Método para processar a resposta da transação
  // Esse método verifica o tipo de operação e chama o método apropriado para tratar a resposta
  void _processarResposta(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      switch (resposta.operation) {
        case "VENDA":
        case "CANCELAMENTO":
          _handleOperacao(resposta, _callBack.onFinishTransaction);
          break;

        // todas as operações que não sejam transações financeiras
        default:
          _handleOperacao(resposta, _callBack.onFinishOperation);
          break;
      }
    }
    _intent = null;
  }

  /// [_handleOperacao] é uma função auxiliar para tratar operações de forma genérica.
  /// * [resposta]: Dados da operação a ser processada.
  /// * [onOperacaoRealizadaSucesso]: Função chamada quando a operação (financeira ou não) é concluída com sucesso.
  /// **Obs.:** Qualquer tratamento específico  é feita na classe que implemente a interface [TefPayGoCallBack].

  void _handleOperacao(TransacaoRequisicaoResposta resposta,
      void Function(TransacaoRequisicaoResposta) onOperacaoRealizadaSucesso) {
    if (resposta != null) {
      switch (resposta.transactionResult) {
        case PayGoRetornoConsts.PWRET_OK:
          onOperacaoRealizadaSucesso(resposta);
          break;
        case PayGoRetornoConsts.PWRET_FROMHOSTPENDTRN:
          _callBack.onPendingTransaction(_getStringPendingData());
          break;
        default:
          _callBack.onErrorMessage(resposta.resultMessage);
          break;
      }
    }
  }

  // Método auxiliar para obter os dados da transação pendente
  String _getStringPendingData() {
    return _intent?.extra?["TransacaoPendenteDados"] ?? "";
  }
}
