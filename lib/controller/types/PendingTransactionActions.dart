/**
 * Enumerado de ações para uma transação pendente
 */

enum PendingTransactionActions {
  NONE, //Nenhuma ação
  CONFIRM,// confirmar transação
  MANUAL_UNDO //desfeito manual

}

extension string on PendingTransactionActions {
  String toValue() {
    switch (this) {
      case PendingTransactionActions.NONE:
        return "SEM AÇÃO";
      case PendingTransactionActions.CONFIRM:
        return "CONFIRMAR";
      case PendingTransactionActions.MANUAL_UNDO:
        return "DESFAZIMENTO MANUAL";
    }
  }
}