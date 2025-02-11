import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_resposta.dart';

abstract class PayGoRequestCallBack {
  void onPrinter(TransacaoRequisicaoResposta resposta);
  void onReceiveMessage(String message);
}
