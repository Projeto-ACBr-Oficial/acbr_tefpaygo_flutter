/**
 * Enumerado de ações para uma transação pendente
 */

enum PendingTransactionActions {
  NONE, //Nenhuma ação
  CONFIRM,// confirmar transação
  MANUAL_UNDO //desfeito manual
}