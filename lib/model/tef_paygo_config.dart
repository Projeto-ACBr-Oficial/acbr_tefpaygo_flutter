import 'package:paygo_sdk/paygo_integrado_uri/domain/types/transaction_status.dart';

import '../controller/types/PendingTransactionActions.dart';

///
///  [TefPayGoConfiguracoes] é uma classe que representa as configurações do TEF PayGo
///  Essa class é utilizada pelo PayGoTefController para configurar o comportamento do TEF PayGo
/// * Propriedades configuráveis:
/// [_isAutoConfirm]  booleano que define se a transação deve ser confirmada automaticamente
/// [_isPrintcardholderReceipt] booleano que define se o comprovante do cliente deve ser impresso
/// [_isPrintMerchantReceipt]  booleano que define se o comprovante do estabelecimento deve ser impresso
/// [_isPrintReport]  booleano que define se o relatório deve ser impresso
/// [_pendingTransactionActions] (enumerado) que define a ação a ser tomada quando a transação está pendente
/// [_tipoDeConfirmacao] (enumerado) que define o tipo de confirmação da transação
/// [_isPrintShortReceipt] booleano que define se o comprovante curto deve ser impresso

class TefPayGoConfiguracoes {
  late bool _isAutoConfirm = true;
  late bool _isPrintcardholderReceipt = true;
  late bool _isPrintMerchantReceipt = false;
  late bool _isPrintReport = true;
  late bool _isPrintShortReceipt = false;

  late PendingTransactionActions _pendingTransactionActions =
      PendingTransactionActions.MANUAL_UNDO;

  late TransactionStatus _tipoDeConfirmacao =
      TransactionStatus.confirmadoAutomatico;

  get pendingTransactionActions => _pendingTransactionActions;

  bool get isAutoConfirm => _isAutoConfirm;

  bool get isPrintcardholderReceipt => _isPrintcardholderReceipt;

  bool get isPrintMerchantReceipt => _isPrintMerchantReceipt;

  bool get isPrintReport => _isPrintReport;

  bool get isPrintShortReceipt => _isPrintShortReceipt;

  set isPrintShortReceipt(bool isPrintShortReceipt) {
    _isPrintShortReceipt = isPrintShortReceipt;
  }

  get tipoDeConfirmacao => _tipoDeConfirmacao;

  void setPendingTransactionActions(
      PendingTransactionActions pendingTransactionActions) {
    _pendingTransactionActions = pendingTransactionActions;
  }

  void setIsPrintReport(bool isPrintReport) {
    _isPrintReport = isPrintReport;
  }

  void setIsPrintcardholderReceipt(bool isPrintcardholderReceipt) {
    _isPrintcardholderReceipt = isPrintcardholderReceipt;
  }

  void setIsPrintMerchantReceipt(bool isPrintMerchantReceipt) {
    _isPrintMerchantReceipt = isPrintMerchantReceipt;
  }

  void setIsAutoConfirm(bool isAutoConfirm) {
    _isAutoConfirm = isAutoConfirm;
  }

  void setTipoDeConfirmacao(TransactionStatus tipoDeConfirmacao) {
    _tipoDeConfirmacao = tipoDeConfirmacao;
  }
}
