import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_resposta.dart';

/**
 * PayGoResponseCallback é uma interface de comunicação entre a view e o PayGoResponseHandler
 */
abstract class PayGoResponseCallback {
  void onPrinter(TransacaoRequisicaoResposta resposta);
  void onReceiveMessage(String message);
}
