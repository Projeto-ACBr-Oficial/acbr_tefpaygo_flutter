import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_resposta.dart';

///  [TefPayGoCallBack] é uma interface de comunicação entre a view e o [PayGoResponseHandler]
abstract class TefPayGoCallBack {

  /// [onPrinter] é o método chamado quando a impressão é solicitada
  ///  * Aqui você pode implementar a lógica de impressão de acordo com a resposta da transação

  void onPrinter(TransacaoRequisicaoResposta resposta);

  /// [onSuccessMessage] é o método chamado quando uma mensagem de sucesso é recebida
  /// * Método chamado quando uma mensagem é recebida
  /// * Aqui você pode implementar a lógica para exibir a mensagem recebida
  /// [message] é a mensagem de sucesso recebida

  void onSuccessMessage(String message);

  ///[onErrorMessage] é o método chamado quando uma mensagem de erro é recebida
  /// [message] é a mensagem de erro recebida

  void onErrorMessage(String message);

  /// [onFinishTransaction] é o método chamado quando a transação é finalizada
  /// Método chamado quando a transação é finalizada
  /// Nele deve ser implementado a regra de negócio para finalizar a transação
  /// Aqui você pode implementar a lógica para imprimir o comprovante, salvar a transação no banco de dados, etc

  void onFinishTransaction(TransacaoRequisicaoResposta response);

  /// [onPendingTransaction] é o método chamado quando a transação está pendente
  /// * [transactionPendingData] é os dados da transação pendente
  /// * que deve ser confirmada ou desfeita de acordo com a sua regra de negocio

  void onPendingTransaction(String transactionPendingData);

  /// [onFinishOperation] é o método chamadao quando uma operacao (não financeira) é finalizada
  ///  * Aqui deve implementar tratamento para as demais operações
  ///  * Como por exemplo: instalacao, relatorio, etc

  void onFinishOperation(TransacaoRequisicaoResposta response);

  /// [checkRequirmentsToConfirmTransaction] Metodo auxiliar que verifica quais requisitos são necessários para confirmar a transação
  /// Esse método deve ser implementado para verificar se a transação pode ser confirmada de acordo com sua regra de negócio
  /// Returns [bool] [true] se os requisitos foram atendidos, [false] caso contrário

  bool checkRequirmentsToConfirmTransaction();
}
