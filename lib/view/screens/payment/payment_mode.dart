import 'package:demo_tefpaygo_simples/exception/valor_pagamento_invalido.dart';
import 'package:demo_tefpaygo_simples/view/widget/button.dart';
import 'package:demo_tefpaygo_simples/view/widget/text_price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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


  /**
   * Função auxiliar para pagamento com cartão de crédito
   */
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
      navegarParaTelaAnterior();
    }
  }

  /**
   * Método executado quando clicar no botão de crédito
   *
   */
  void onClickButtonCredito() async {
    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = _tefController.payGORequestHandler.provider
      ..cardType = CardType.cartaoCredito;
     _pagamentoCredito(transacao);
  }

  void onClickButtonVoucher() async {
    // não é possível testar voucher em modo de sandbox
    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = _tefController.payGORequestHandler.provider
      ..cardType = CardType.cartaoVoucher;
    //..finType = FinType.aVista;
   await pagar(transacao);
  }

  void onClickButtonFrota() async {
    //Cartão frota é um cartão corporativo, emitido por uma empresa para seus funcionários
    // muito usado em postos de gasolina.

    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = _tefController.payGORequestHandler.provider
      ..cardType = CardType.cartaoFrota
      ..finType = FinType.aVista;

    await pagar(transacao);
  }

  void onClickButtonPrivateLabel()  async{
    //privateLabel é um cartão (geralmente de crédito) emitido por uma loja ou empresa.

    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = _tefController.payGORequestHandler.provider
      ..cardType = CardType.cartaoPrivateLabel
      ..finType = FinType.aVista;
    _pagamentoCredito(transacao);
  }

  void onClickButtonCarteiraDigital() async {
    TransacaoRequisicaoVenda transacao = TransacaoRequisicaoVenda(
        amount: widget.valorPagamento, currencyCode: CurrencyCode.iso4217Real)
      ..provider = "PIX C6 BANK"
      ..finType = FinType.aVista
      ..paymentMode = PaymentMode.pagamentoCarteiraVirtual;

    await pagar(transacao);
  }

  void navegarParaTelaAnterior() {
    Navigator.pop(context);
  }

  Future<void> pagar(TransacaoRequisicaoVenda transacao) async {
    await _tefController.payGORequestHandler.venda(transacao);
    Navigator.pop(context);
  }

  /**
   * Função auxiliar para obter o modo de financiamento
   */
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
        double quantidadeParcelas = await _selecionaQuantidadeDeParcelas(transacao.amount);
        if (quantidadeParcelas < minimoParcelas){
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

  /**
   * Função auxiliar para selecionar a quantidade de parcelas
   *
   */
  Future<double> _selecionaQuantidadeDeParcelas( double valor) async {
    double quantidadeMaximaDeParcelas = _obterQuantidadeMaximaDeParcelas(valor);
    var parcelas  = List
        .generate(quantidadeMaximaDeParcelas.toInt(), (i)=>(i+1))
        .sublist(1);

    double quantidadeParcelas  = 1.0;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        int? selectedInstallments;
        return AlertDialog(
          title: Text("Selecione a quantidade de parcelas"),
          content: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: parcelas.map((e) => RadioListTile<int>(
                  title: Text(e.toString() + "x"),
                  value: e,
                  groupValue: selectedInstallments,
                  onChanged: (int? value) {
                    setState(() {
                      selectedInstallments = value ;
                      quantidadeParcelas = selectedInstallments!.toDouble();
                    });
                    Navigator.pop(context);
                  },
                )).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
               _onCancelOperation();
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );

    return quantidadeParcelas;


  }

  /**
   * Função auxiliar para selecionar a forma de financiamento
   */
  Future<FinType> _selecionaFinanciamento() async {
    var listFinType = {
      FinType.aVista,
      FinType.parceladoEmissor,
      FinType.parceladoEstabelecimento
    };

    FinType currenFinType  = FinType.financiamentoNaoDefinido;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          FinType? selectedFinType ;
          return AlertDialog(
              title: Text("Selecione a forma de Financiamento"),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: listFinType
                      .map((e) => RadioListTile<FinType>(
                          title: Text(e.finTypeString
                              .replaceAll('_', ' ')
                              .toLowerCase()),
                          value: e,
                          groupValue: selectedFinType,
                          onChanged: (FinType? value) {
                            setState(() {
                              selectedFinType = value;
                              currenFinType = selectedFinType!;
                            });
                            Navigator.pop(context,true);
                          }))
                      .toList()),
            actions: [
              TextButton(
                child: const Text("Cancelar"),
                onPressed: () {
                  _onCancelOperation();
                Navigator.pop(context,false);
              },

              )
          ],);
        });

    return currenFinType;
  }

  /**
   * Função auxiliar para  calcular a quantidade máxima de parcelas
   */
  double _obterQuantidadeMaximaDeParcelas(double valor) {
    double valordeParcelaMinimo = 5.00;
    double valorMinimoParcelavel = 2 * valordeParcelaMinimo;
    double quantidadeMaximaDeParcelas = 99.0;

    if (valor < valorMinimoParcelavel) {
      throw new ValorPagamentoInvalidoException(
          "Valor mínimo para parcelamento é R\$ ${valorMinimoParcelavel}");
    }
    double quantidadeDeParcelas = valor / valordeParcelaMinimo;

    if (quantidadeDeParcelas > quantidadeMaximaDeParcelas) {
      return quantidadeMaximaDeParcelas;
    }
    return quantidadeDeParcelas.floorToDouble();
  }

  void _onCancelOperation(){
    Fluttertoast.showToast(msg: "Operação cancelada", toastLength: Toast.LENGTH_LONG);
  }
}
