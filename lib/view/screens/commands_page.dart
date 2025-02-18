import 'dart:async';

import 'package:demo_tefpaygo_simples/controller/PayGoTefController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:receive_intent/receive_intent.dart' as receive_intent;

import '../../controller/paygo_request_handler.dart';
import '../../controller/paygo_response_handler.dart';
import '../../utils/paygo_request_handler_helper.dart';
import '../widget/button.dart';
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
  String _valorVendaString = "0.00";

  void _setInputVenta(String value){
    setState(() {
      _valorVenda = double.parse(value);
      _valorVendaString = _valorVenda.toStringAsFixed(2);
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
          msg: "Valor da venda deve ser maior que R\$ 1,00",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }
    _tefController
        .payGORequestHandler
        .venda(_valorVenda);
  }


  void _onClearVenda(){
    setState((){
      _valorVenda = 0.0;
      _valorVendaString = "0.00";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2,
          children: [
            Text(
                _valorVendaString,
                style: TextStyle(fontSize:40)
            ),
            CustomKeyBoard(processKeyBoardInput:_processInputKeyBoard),
          ],
        )
      )

    );
  }
}