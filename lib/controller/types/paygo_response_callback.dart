import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_resposta.dart';

/**
 * PayGoResponseCallback é uma interface de comunicação entre a view e o PayGoResponseHandler
 */
abstract class PayGoResponseCallback {
  void onPrinter(TransacaoRequisicaoResposta resposta);

  void onReceiveMessage(String message);

  /**
   * Método chamado quando a transação é finalizada
   * Nele deve ser implementado a regra de negócio para finalizar a transação
   * Aqui você pode implementar a lógica para imprimir o comprovante, salvar a transação no banco de dados, etc
   */
  void onFinishTransaction(TransacaoRequisicaoResposta response);
}
