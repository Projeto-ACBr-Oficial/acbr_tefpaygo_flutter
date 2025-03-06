import 'package:demo_tefpaygo_simples/view/widget/button.dart';
import 'package:demo_tefpaygo_simples/view/widget/text_price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_venda.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/card_type.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/currency_code.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/fin_type.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/payment_mode.dart';

import '../../../controller/PayGoTefController.dart';

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
    return Scaffold(
        appBar: AppBar(title: Text("Pagamento")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 2,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text("Total"),
                    Text(_formatPayment(), style: TextStyle(fontSize: 30)),
                  ],
                ),
              ),
              Text("Escolha a forma de pagamento:",
                  style: TextStyle(fontSize: 20)),
              Button(text: "Debito", onPressed: onClicKButtonDebito),
              Button(text: "Credito", onPressed: onClickButtonCredito),
              Button(text: "Voucher", onPressed: onClickButtonVoucher),
              Button(text: "Frota", onPressed: onClickButtonFrota),
              Button(
                  text: "Cartão da Loja", onPressed: onClickButtonPrivateLabel),
              Button(
                  text: "Carteira Digital",
                  onPressed: onClickButtonCarteiraDigital),
              Button(
                text: "Cancelar",
                onPressed: navegarParaTelaAnterior,
              )
            ],
          ),
        ));
  }

  void onClicKButtonDebito() {
    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = _tefController.payGORequestHandler.provider
      ..cardType = CardType.cartaoDebito;

    transacao.finType = FinType.aVista;

    //..finType = FinType.aVista;
    pagar(transacao);
  }

  void onClickButtonCredito() async {
    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = _tefController.payGORequestHandler.provider
      ..cardType = CardType.cartaoCredito;
    await _obterModoDeFinanciamento(transacao);
    await pagar(transacao);
  }

  void onClickButtonVoucher() async {
    // não é possível testar voucher em modo de sandbox
    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = _tefController.payGORequestHandler.provider
      ..cardType = CardType.cartaoVoucher;
    //..finType = FinType.aVista;
    pagar(transacao);
  }

  void onClickButtonFrota() {
    //Cartão frota é um cartão corporativo, emitido por uma empresa para seus funcionários
    // muito usado em postos de gasolina.

    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = _tefController.payGORequestHandler.provider
      ..cardType = CardType.cartaoFrota
      ..finType = FinType.aVista;

    pagar(transacao);
  }

  void onClickButtonPrivateLabel() {
    //privateLabel é um cartão (geralmente de crédito) emitido por uma loja ou empresa.

    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = _tefController.payGORequestHandler.provider
      ..cardType = CardType.cartaoPrivateLabel
      ..finType = FinType.aVista;

    pagar(transacao);
  }

  void onClickButtonCarteiraDigital() async {
    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = "PIX C6 BANK"
      ..finType = FinType.aVista
      ..paymentMode = PaymentMode.pagamentoCarteiraVirtual;

    await _tefController.payGORequestHandler.venda(transacao);
  }

  void navegarParaTelaAnterior() {
    Navigator.pop(context);
  }

  Future<void> pagar(TransacaoRequisicaoVenda transacao) async {
    await _tefController.payGORequestHandler.venda(transacao);
    Navigator.pop(context);
  }

  Future<void> _obterModoDeFinanciamento(
      TransacaoRequisicaoVenda transacao) async {
    FinType currentFinType = await _selecionaFinanciamento();
    print('entrei em modo de pagamento');
    switch (currentFinType) {
      case FinType.parceladoEmissor:
      case FinType.parceladoEstabelecimento:
        transacao.finType = currentFinType;
        double quantidadeParcelas = _obterQuantidadesDeParcelas(transacao);
        transacao.installments = quantidadeParcelas;
        break;

      default:
        transacao.finType = FinType.aVista;
        break;
    }
  }

  Future<FinType> _selecionaFinanciamento() async {
    var listFinType = {
      FinType.aVista,
      FinType.parceladoEmissor,
      FinType.parceladoEstabelecimento
    };

    var currenFinType = FinType.aVista;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          FinType? selectedFinType = currenFinType;
          return AlertDialog(
              title: Text("Selecione a forma de Financimento"),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: listFinType
                      .map((e) => RadioListTile<FinType>(
                            title: Text(e.finTypeString),
                            value: e,
                            groupValue: selectedFinType,
                            onChanged: (FinType? value) {
                              setState(() {
                                print(value!);
                                selectedFinType = value;
                                currenFinType = selectedFinType!;
                              });
                              Navigator.pop(context);
                            },
                          ))
                      .toList()));
        });
    return currenFinType;
  }

  double _obterQuantidadesDeParcelas(TransacaoRequisicaoVenda transacao) {
    return 2.0;
  }
}
