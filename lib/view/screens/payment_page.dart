import 'package:demo_tefpaygo_simples/controller/PayGoTefController.dart';
import 'package:demo_tefpaygo_simples/view/screens/payment/payment_mode.dart';
import 'package:demo_tefpaygo_simples/view/widget/text_price.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../widget/keyboard.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TefController _tefController = Get.find();
  double _valorVenda = 0.0;
  String _valorVendaString = "0,00";

  void _setInputVenta(String value) {
    setState(() {
      _valorVenda = double.parse(value) / 100;
      _valorVendaString = _valorVenda.toStringAsFixed(2).replaceFirst(".", ",");
    });
  }

  void _parseInputVenda(String value) {
    String digits = _onlyNumber(_valorVendaString) + value;
    _setInputVenta(digits);
  }

  String _onlyNumber(String numberStr) {
    return numberStr.replaceFirst(",", "").replaceAll(".", "");
  }

  void _clearLatestDigit() {
    String digits = _onlyNumber(_valorVendaString);
    if (digits.length > 1) {
      digits = digits.substring(0, digits.length - 1);
    } else {
      digits = "0";
    }
    _setInputVenta(digits);
  }

  void _processInputKeyBoard(String value) {
    value = value.toUpperCase();
    switch (value) {
      case "C":
        _onClearVenda();
        break;
      case "CE":
        _clearLatestDigit();
        break;
      case "PAGAR":
        _pagar();
        break;
      default:
        _parseInputVenda(value);
        break;
    }
  }

  void _showMessage(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

  void _pagar() async {
    if (_valorVenda < TefController.VALOR_MINIMO_VENDA) {
      _showMessage("Valor de venda mínimo é R\$ 1,00");
      return;
    } else if (_valorVenda > TefController.VALOR_MAXIMO_VENDA) {
      _showMessage("Valor de venda deve ser menor ou igual que R\$ 100.000,00");
      return;
    }

    // _tefController.payGORequestHandler.venda(_valorVenda);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PaymentViewMode(valorPagamento: _valorVenda)));
    _onClearVenda();
  }

  void _onClearVenda() {
    _setInputVenta("0.00");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  TextPrice(_valorVendaString),
                  const SizedBox(height: 16),
                  Flexible(
                    child: CustomKeyBoard(
                      processKeyBoardInput: _processInputKeyBoard,
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }


}
