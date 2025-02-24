import 'package:demo_tefpaygo_simples/controller/PayGoTefController.dart';
import 'package:demo_tefpaygo_simples/view/screens/payment/payment_page.dart';
import 'package:demo_tefpaygo_simples/view/widget/text_price.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../widget/keyboard.dart';

class CommandPage extends StatefulWidget {
  const CommandPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CommandPage> createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
  final TefController _tefController = Get.find();
  double _valorVenda = 0.0;
  String _valorVendaString = "0,00";

  void _setInputVenta(String value){
    setState(() {
      _valorVenda = double.parse(value)/100;
      _valorVendaString = _valorVenda
          .toStringAsFixed(2)
      .replaceFirst(".", ",")
      ;
    });
  }

  void _parseInputVenda(String value){

    String digits = _onlyNumber(_valorVendaString) + value;
    _setInputVenta(digits);
  }

  String _onlyNumber(String numberStr){
    return numberStr.replaceFirst(",", "").replaceAll(".", "");
  }

  void  _clearLatestDigit(){
    String digits = _onlyNumber(_valorVendaString);
    if(digits.length > 1){
      digits = digits.substring(0, digits.length - 1);
    }else{
      digits = "0";
    }
    _setInputVenta(digits);

  }
  void _processInputKeyBoard(String value){
    value = value.toUpperCase();
    switch(value){
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

  void _pagar(){
    if ( _valorVenda < 1){
      Fluttertoast.showToast(
          msg: "Valor mínimo de venda é R\$ 1,00",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(valorPagamento:_valorVenda)));
  }


  void _onClearVenda(){
    _setInputVenta("0.00");
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraint){
        return Container(
            width: constraint.maxWidth *0.7,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 2,
              children: [
                TextPrice(_valorVendaString),
                CustomKeyBoard(processKeyBoardInput:_processInputKeyBoard),
              ],
            )

        );
      }
    );
  }
}