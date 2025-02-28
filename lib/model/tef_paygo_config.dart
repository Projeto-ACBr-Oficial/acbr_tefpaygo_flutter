import 'package:paygo_sdk/paygo_integrado_uri/domain/types/transaction_status.dart';

import '../controller/types/PendingTransactionActions.dart';

class TefPayGoConfiguracoes {
  late bool _isAutoConfirm = true;
  late bool _isPrintcardholderReceipt = true;
  late bool _isPrintMerchantReceipt = true;
  late bool _isPrintReport = true;
  late bool _isTestScript = false;

  late PendingTransactionActions _pendingTransactionActions =
  PendingTransactionActions.MANUAL_UNDO;

  late TransactionStatus _tipoDeConfirmacao = TransactionStatus.confirmadoAutomatico;


  get pendingTransactionActions => _pendingTransactionActions;

  get isAutoConfirm => _isAutoConfirm;

  get isPrintcardholderReceipt => _isPrintcardholderReceipt;

  get isPrintMerchantReceipt => _isPrintMerchantReceipt;

  get isPrintReport => _isPrintReport;

  get tipoDeConfirmacao => _tipoDeConfirmacao;

  get isTestScript => _isTestScript;


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

  void setTipoDeConfirmacao(TransactionStatus tipoDeConfirmacao){
    _tipoDeConfirmacao = tipoDeConfirmacao;
  }

  void setIsTestScript(bool isTestScript){
    _isTestScript = isTestScript;
  }

}