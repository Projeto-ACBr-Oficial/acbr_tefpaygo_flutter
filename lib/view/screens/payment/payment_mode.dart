import 'package:demo_tefpaygo_simples/controller/types/tef_provider.dart';
import 'package:demo_tefpaygo_simples/exception/valor_pagamento_invalido.dart';
import 'package:demo_tefpaygo_simples/model/tef_paygo_config.dart';
import 'package:demo_tefpaygo_simples/view/widget/text_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_venda.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/card_type.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/currency_code.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/fin_type.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/payment_mode.dart';

import '../../../controller/paygo_tefcontroller.dart';
import '../../widget/widgets.dart';

class PaymentViewMode extends StatefulWidget {
  final double valorPagamento;

  @override
  _PaymentViewModeState createState() => _PaymentViewModeState();

  const PaymentViewMode({super.key, required this.valorPagamento});
}

class _PaymentViewModeState extends State<PaymentViewMode> {
  final TefController _tefController = Get.find();

  String _formatPayment() {
    return "R\$ ${widget.valorPagamento.toStringAsFixed(2)}"
        .replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forma de Pagamento"),
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Seção do valor total
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Total a Pagar",
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatPayment(),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Título da seção
                Text(
                  "Escolha a forma de pagamento",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
                
                // Lista de opções de pagamento
                Expanded(
                  child: ListView(
                    children: [
                      PaymentOptionTile(
                        icon: Icons.credit_card,
                        title: "Débito",
                        subtitle: "Cartão de débito",
                        color: Colors.blue,
                        onPressed: onClicKButtonDebito,
                      ),
                      const SizedBox(height: 12),
                      PaymentOptionTile(
                        icon: Icons.credit_card,
                        title: "Crédito",
                        subtitle: "Cartão de crédito",
                        color: Colors.green,
                        onPressed: onClickButtonCredito,
                      ),
                      const SizedBox(height: 12),
                      PaymentOptionTile(
                        icon: Icons.card_giftcard,
                        title: "Voucher",
                        subtitle: "Vale alimentação ou refeição",
                        color: Colors.orange,
                        onPressed: onClickButtonVoucher,
                      ),
                      const SizedBox(height: 12),
                      PaymentOptionTile(
                        icon: Icons.local_gas_station,
                        title: "Cartão Frota",
                        subtitle: "Cartão corporativo",
                        color: Colors.purple,
                        onPressed: onClickButtonFrota,
                      ),
                      const SizedBox(height: 12),
                      PaymentOptionTile(
                        icon: Icons.store,
                        title: "Cartão da Loja",
                        subtitle: "Private label",
                        color: Colors.teal,
                        onPressed: onClickButtonPrivateLabel,
                      ),
                      const SizedBox(height: 12),
                      PaymentOptionTile(
                        icon: Icons.account_balance,
                        title: "Carteira Digital",
                        subtitle: "PIX e carteiras virtuais",
                        color: Colors.indigo,
                        onPressed: onClickButtonCarteiraDigital,
                      ),

                      const SizedBox(height: 12),
                      // Botão para pagar item de roteiro de testes
                      PaymentOptionTile(
                        icon: Icons.check_circle,
                        title: "Pagar Item do Roteiro de Testes",
                        subtitle: "Simula pagamento de item de roteiro",
                        color: Colors.green,
                        onPressed: onClickPagarItemRoteiroTestes,
                      ),
                      const SizedBox(height: 24),
                      CancelButton(
                        onPressed: navegarParaTelaAnterior,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // Método para pagar item de roteiro de testes
  // aqui é onde voce pode escrevar passo no roteiro de testes
  //
  void onClickPagarItemRoteiroTestes() async {
    //objeto[transacao] deve ser configurado com os dados do item de roteiro de testes
    //exemplo: provider,tipo de cartão, entre outros
    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
    //..provider = _tefController.configuracoes.provider.toValue()
      //..cardType = CardType.cartaoCredito
      //..finType = FinType.parceladoEmissor
      //..installments = 3.0; // exemplo de parcelamento em 3 vezes
    ;
    await pagar(transacao);
  }

  
  void onClicKButtonDebito() async {
    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = _tefController.configuracoes.provider.toValue()
      ..cardType = CardType.cartaoDebito;

    transacao.finType = FinType.aVista;

    //..finType = FinType.aVista;
    pagar(transacao);
  }

  // Métodos onClick

  // Método executado quando clicar no botão de crédito
  void onClickButtonCredito() async {
    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = _tefController.configuracoes.provider.toValue()
      ..cardType = CardType.cartaoCredito;
    _pagamentoCredito(transacao);
  }

  void onClickButtonVoucher() async {
    // não é possível testar voucher em modo de sandbox
    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..cardType = CardType.cartaoVoucher
      ..finType = FinType.aVista;
    await pagar(transacao);
  }

  void onClickButtonFrota() async {
    //Cartão frota é um cartão corporativo, emitido por uma empresa para seus funcionários
    // muito usado em postos de gasolina.

    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = _tefController.configuracoes.provider.toValue()
      ..cardType = CardType.cartaoFrota
      ..finType = FinType.aVista;

    await pagar(transacao);
  }

  void onClickButtonPrivateLabel() async {
    //privateLabel é um cartão (geralmente de crédito) emitido por uma loja ou empresa.

    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = _tefController.configuracoes.provider.toValue()
      ..cardType = CardType.cartaoPrivateLabel
      ..finType = FinType.aVista;
    _pagamentoCredito(transacao);
  }

  void onClickButtonCarteiraDigital() async {
    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = TefProvider.NENHUM.toValue()
      ..finType = FinType.aVista
      ..paymentMode = PaymentMode.pagamentoCarteiraVirtual;

    await pagar(transacao);
  }

  // Métodos auxiliares

  void navegarParaTelaAnterior() {
    Get.back();
  }

  Future<void> pagar(TransacaoRequisicaoVenda transacao) async {
    await _tefController.payGORequestHandler.venda(transacao);
    //navegarParaTelaAnterior();
  }

  /// Função auxiliar para obter o modo de financiamento
  Future<void> _obterModoDeFinanciamento(
      TransacaoRequisicaoVenda transacao) async {
    FinType currentFinType = await _selecionaFinanciamento();
    double minimoParcelas = 2.0;

    switch (currentFinType) {
      case FinType.aVista:
        transacao.finType = currentFinType;
        break;
      case FinType.parceladoEmissor:
      case FinType.parceladoEstabelecimento:
        transacao.finType = currentFinType;
        double quantidadeParcelas =
            await _selecionaQuantidadeDeParcelas(transacao.amount);
        if (quantidadeParcelas < minimoParcelas) {
          transacao.finType = null;
          return;
        }
        transacao.installments = quantidadeParcelas;
        break;

      default:
        transacao.finType = null;
        break;
    }
  }

  // Função auxiliar para selecionar a quantidade de parcelas
  Future<double> _selecionaQuantidadeDeParcelas(double valor) async {
    double quantidadeMaximaDeParcelas = _obterQuantidadeMaximaDeParcelas(valor);
    var parcelas =
        List.generate(quantidadeMaximaDeParcelas.toInt(), (i) => (i + 1))
            .sublist(1);

    double quantidadeParcelas = 1.0;
    await showGenericDialog<int>(
      context: context,
      title: "Selecione a quantidade de parcelas",
      options: parcelas,
      selectedValue: null,
      displayText: (e) => "$e x",
      onSelected: (value) {
        quantidadeParcelas = value.toDouble();
      },
      onCancel: () {
        _onCancelOperation();
      },
    );
    return quantidadeParcelas;
  }

  // Função auxiliar para selecionar a forma de financiamento
  Future<FinType> _selecionaFinanciamento() async {
    var listFinType = {
      FinType.aVista,
      FinType.parceladoEmissor,
      FinType.parceladoEstabelecimento
    };

    FinType currenFinType = FinType.financiamentoNaoDefinido;
    await showGenericDialog<FinType>(
      context: context,
      title: "Selecione a forma de Financiamento",
      options: listFinType.toList(),
      selectedValue: null,
      displayText: (e) => e.finTypeString.replaceAll('_', ' ').toLowerCase(),
      onSelected: (value) {
        currenFinType = value;
      },
      onCancel: () {
        _onCancelOperation();
      },
    );
    return currenFinType;
  }

  /// Função auxiliar para  calcular a quantidade máxima de parcelas
  /// Retorna a quantidade máxima de parcelas que o valor pode ser parcelado
  /// * [valor] é o valor a ser parcelado
  /// * Lança uma exceção se o valor for menor que o valor mínimo parcelável
  double _obterQuantidadeMaximaDeParcelas(double valor) {
    double valordeParcelaMinimo = 5.00;
    double valorMinimoParcelavel = 2 * valordeParcelaMinimo;
    double quantidadeMaximaDeParcelas = 99.0;

    if (valor < valorMinimoParcelavel) {
      throw ValorPagamentoInvalidoException(
          "Valor mínimo para parcelamento é R\$ $valorMinimoParcelavel");
    }
    double quantidadeDeParcelas = valor / valordeParcelaMinimo;

    if (quantidadeDeParcelas > quantidadeMaximaDeParcelas) {
      return quantidadeMaximaDeParcelas;
    }
    return quantidadeDeParcelas.floorToDouble();
  }

  void _onCancelOperation() {
    Fluttertoast.showToast(
        msg: "Operação cancelada", toastLength: Toast.LENGTH_LONG);
  }

  /// Função auxiliar para pagamento com cartão de crédito

  void _pagamentoCredito(TransacaoRequisicaoVenda transacao) async {
    try {
      await _obterModoDeFinanciamento(transacao);
      if (transacao.finType == null) {
        navegarParaTelaAnterior();
        return;
      }
      await pagar(transacao);
    } on ValorPagamentoInvalidoException {
      Fluttertoast.showToast(
          msg: "Valor mínimo para parcelamento é R\$ 10,00",
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0);
    }
  }
}
