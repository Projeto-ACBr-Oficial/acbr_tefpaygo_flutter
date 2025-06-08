import 'package:flutter/material.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_confirmacao.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_pendencia.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/transaction_status.dart';
import 'package:paygo_sdk/paygo_sdk.dart';

/// PayGoRequestHandler é uma classe que abstrai a requisiçoes do PayGo SDK
class PayGoRequestHandler {
  String _provider = "DEMO";
  final _repository = PayGOSdk();

  get provider => _provider;

  void setProvider(String provider) {
    _provider = provider;
  }

  late TransacaoRequisicaoDadosAutomacao _dadosAutomacao = TransacaoRequisicaoDadosAutomacao(

    "Exemplo TEF PayGo Flutter",
    "1.0",
    "",

    allowCashback: true,
    allowDifferentReceipts: true,
    allowDiscount: true,
    allowDueAmount: true,
    allowShortReceipt: true,
  );

  TransacaoRequisicaoDadosAutomacao get dadosAutomacao => _dadosAutomacao;
  set dadosAutomacao(TransacaoRequisicaoDadosAutomacao dadosAutomacao) {
    _dadosAutomacao = dadosAutomacao;
  }

  
  Future<void> venda(TransacaoRequisicaoVenda dadosVenda) async {
    // configura dados da automacao (obrigatorio para o TefPayGo)
    await _repository.integrado.venda(
      requisicaoVenda: dadosVenda,
      dadosAutomacao: _dadosAutomacao,
    );
  }
  

  
  Future<void> confirmarTransacao(String id,
      [TransactionStatus status = TransactionStatus.confirmadoAutomatico]) async {
    await _repository.integrado.confirmarTransacao(
      intentAction: IntentAction.confirmation,
      requisicao: TransacaoRequisicaoConfirmacao(
        confirmationTransactionId: id,
        status: status,
      )
    ).then((value) {
      debugPrint("Venda confirmada");
    }).catchError((error) {
      debugPrint("Erro ao confirmar venda: $error");
    });
  }
  

  
  Future<void> reimpressao() async {
    await _repository.integrado.generico(
      intentAction: IntentAction.payment,
      requisicao: TransacaoRequisicaoGenerica(operation: Operation.reimpressao),
      dadosAutomacao: _dadosAutomacao,
    );
  }
  

  
  Future<void> instalacao() async {
    await _repository.integrado.generico(
      requisicao: TransacaoRequisicaoGenerica(
        operation: Operation.instalacao,
      ),
      intentAction: IntentAction.payment,
      dadosAutomacao: _dadosAutomacao,
    );
  }
  

  
  Future<void> manutencao() async {
    await _repository.integrado.generico(
      requisicao: TransacaoRequisicaoGenerica(
        operation: Operation.manutencao,
      ),
      intentAction: IntentAction.payment,
      dadosAutomacao: _dadosAutomacao,
    );
  }
  

  
  Future<void> painelAdministrativo() async {
    await _repository.integrado.administrativo(
      dadosAutomacao: _dadosAutomacao,
    );
  }
  

  
  Future<void> exibePDC() async {
    await _repository.integrado.generico(
      intentAction: IntentAction.payment,
      requisicao: TransacaoRequisicaoGenerica(operation: Operation.exibePdc),
      dadosAutomacao: _dadosAutomacao,
    );
  }
  

  
  Future<void> relatorioDetalhado() async {
    await _repository.integrado.generico(
      intentAction: IntentAction.payment,
      requisicao: TransacaoRequisicaoGenerica(
        operation: Operation.relatorioDetalhado,
      ),
      dadosAutomacao: _dadosAutomacao,
    );
  }
  

  
  Future<void> relatorioResumido() async {
    await _repository.integrado.generico(
      intentAction: IntentAction.payment,
      requisicao: TransacaoRequisicaoGenerica(
        operation: Operation.relatorioResumido,
      ),
      dadosAutomacao: _dadosAutomacao,
    );
  }
  
  Future<void> resolverPendencia(String transacaoPendenteDados,
      [TransactionStatus status = TransactionStatus.desfeitoManual]) async {
    await _repository.integrado.resolucaoPendencia(
      intentAction: IntentAction.confirmation,
      requisicaoPendencia: transacaoPendenteDados,
      requisicaoConfirmacao: TransacaoRequisicaoPendencia(status: status),
    );
  }
}
