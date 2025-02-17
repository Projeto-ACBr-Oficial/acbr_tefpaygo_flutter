import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_confirmacao.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_pendencia.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/transaction_status.dart';
import 'package:paygo_sdk/paygo_sdk.dart';


/**
 * PayGoRequestHandler é uma classe que abstrai a requisiçoes do PayGo SDK
 *
 */
class PayGoRequestHandler {
  String _provider = "DEMO";
  final _repository = PayGOSdk();

  get provider => _provider;

  void setProvider(String provider) {
    _provider = provider;
  }

  Future<void> venda(double valor) async {
    // configura dados da automacao (obrigatorio  para o TefPayGo)
    final dadosAutomacao = await TransacaoRequisicaoDadosAutomacao(
      "Exemplo TEF",
      "1.0",
      "ACBr",
      allowCashback: true,
      allowDifferentReceipts: true,
      allowDiscount: true,
      allowDueAmount: true,
      allowShortReceipt: true,
    );
    await _repository.integrado.venda(
        requisicaoVenda: TransacaoRequisicaoVenda(
            amount: valor, currencyCode: CurrencyCode.iso4217Real)
          ..provider = _provider
    , dadosAutomacao: dadosAutomacao
    );
  }

  Future<void> confirmarTransacao(String id) async {
    await _repository.integrado
        .confirmarTransacao(
      intentAction: IntentAction.confirmation,
      requisicao: TransacaoRequisicaoConfirmacao(
        confirmationTransactionId: id,
        status: TransactionStatus.confirmadoAutomatico,
      ),
    )
        .then((value) {
      print("Venda confirmada");
    }).catchError((error) {
      print("Erro ao confirmar venda: $error");
    });
  }


  Future<void> reimpressao() async {
    await _repository.integrado.generico(
        intentAction: IntentAction.payment,
        requisicao:
            TransacaoRequisicaoGenerica(operation: Operation.reimpressao));
  }

  Future<void> instalacao() async {
    await _repository.integrado.generico(
        requisicao: TransacaoRequisicaoGenerica(
          operation: Operation.instalacao,
        ),
        intentAction: IntentAction.payment);
  }

  Future<void> manutencao() async {
    await _repository.integrado.generico(
      requisicao: TransacaoRequisicaoGenerica(
        operation: Operation.manutencao,
      ),
      intentAction: IntentAction.payment,
    );
  }

  Future<void> painelAdministrativo() async {
    await _repository.integrado.administrativo();
  }

  Future<void> exibePDC() async {
    await _repository.integrado.generico(
        intentAction: IntentAction.payment,
        requisicao: TransacaoRequisicaoGenerica(operation: Operation.exibePdc));
  }

  Future<void> relatorioDetalhado() async {
    await _repository.integrado.generico(
        intentAction: IntentAction.payment,
        requisicao: TransacaoRequisicaoGenerica(
            operation: Operation.relatorioDetalhado));
  }

  Future<void> relatorioResumido() async {
    await _repository.integrado.generico(
        intentAction: IntentAction.payment,
        requisicao: TransacaoRequisicaoGenerica(
          operation: Operation.relatorioResumido,
        ));
  }

  /**
   * Metodo para resolver pendencia
   */

  Future<void>resolverPendencia(Uri uri) async {
    if (uri != null) {
      await _repository.integrado.resolucaoPendencia(
        intentAction: IntentAction.confirmation,
        requisicaoPendencia: uri.toString(),
        requisicaoConfirmacao: TransacaoRequisicaoPendencia(
          status: TransactionStatus.desfeitoManual,
        ),
      );
    }
  }
}
