import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_resposta.dart';

/**
 * PayGoResponseCallback é uma interface de comunicação entre a view e o PayGoResponseHandler
 */
abstract class PayGoResponseCallback {
  /**
   * Método chamado quando a impressão é solicitada
   * Aqui você pode implementar a lógica para imprimir o comprovante
   */

  void onPrinter(TransacaoRequisicaoResposta resposta);

  /**
   * Método chamado quando uma mensagem é recebida
   * Aqui você pode implementar a lógica para exibir a mensagem recebida
   */
  void onReceiveMessage(String message);

  /**
   * Método chamado quando a transação é finalizada
   * Nele deve ser implementado a regra de negócio para finalizar a transação
   * Aqui você pode implementar a lógica para imprimir o comprovante, salvar a transação no banco de dados, etc
   */
  void onFinishTransaction(TransacaoRequisicaoResposta response);

  /**
   * Método chamado quando a transação está pendente
   *
   **/
  void onPendingTransaction(String transactionPendingData);

  bool checkRequirmentsToConfirmTransaction();
}
