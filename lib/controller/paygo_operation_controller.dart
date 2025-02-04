import 'package:demo_tefpaygo_simples/utils/paygo_sdk_helper.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_confirmacao.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_dados_automacao.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_generica.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_venda.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/currency_code.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/intent_action.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/operation.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/transaction_status.dart';

class TefPayGoTransacoes {
  String _provider = "DEMO";
  final repository = PayGOSdkHelper().paygoSdk;

  void setProvider(String provider) {
    _provider = provider;
  }

  Future<void> realizarVenda(double valor) async {
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
    await repository.integrado.venda(
        requisicaoVenda: TransacaoRequisicaoVenda(
            amount: valor, currencyCode: CurrencyCode.iso4217Real)
          ..provider = _provider);
  }

  Future<void> confirmarTransacao(String id) async {
    await repository.integrado
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
    await repository.integrado.generico(
        intentAction: IntentAction.payment,
        requisicao:
            TransacaoRequisicaoGenerica(operation: Operation.reimpressao));
  }

  Future<void> instalacao() async {
    await repository.integrado.generico(
        requisicao: TransacaoRequisicaoGenerica(
          operation: Operation.instalacao,
        ),
        intentAction: IntentAction.payment);
  }

  Future<void> manutencao() async {
    await repository.integrado.generico(
      requisicao: TransacaoRequisicaoGenerica(
        operation: Operation.manutencao,
      ),
      intentAction: IntentAction.payment,
    );
  }

  Future<void> painelAdministrativo() async {
    await repository.integrado.administrativo();
  }

  Future<void> exibePDC() async {
    await repository.integrado.generico(
        intentAction: IntentAction.payment,
        requisicao: TransacaoRequisicaoGenerica(operation: Operation.exibePdc));
  }

  Future<void> relatorioDetalhado() async {
    await repository.integrado.generico(
        intentAction: IntentAction.payment,
        requisicao: TransacaoRequisicaoGenerica(
            operation: Operation.relatorioDetalhado));
  }

  Future<void> relatorioResumido() async {
    await repository.integrado.generico(
        intentAction: IntentAction.payment,
        requisicao: TransacaoRequisicaoGenerica(
          operation: Operation.relatorioResumido,
        ));
  }
}
