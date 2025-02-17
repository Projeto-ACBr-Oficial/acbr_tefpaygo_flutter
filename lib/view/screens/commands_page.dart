import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final PayGoRequestHandler _payGORequestHandler = PayGoRequestHandlerHelper().payGoRequestHandler;
  void _onChangedInputVenda(String value){

    String onlyDigits = _valorVendaString.replaceFirst(",", "").replaceAll(".", "") + value;
    setState(() {
      _valorVenda = double.parse(onlyDigits)/100.00;
      _valorVendaString = _valorVenda.toStringAsFixed(2);
    });

  }


  void _onClearVenda(){
    setState((){
      _valorVenda = 0.0;
      _valorVendaString = "0.00";
    });
  }
  double _valorVenda = 0.0;
  String _valorVendaString = "0.00";

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
            CustomKeyBoard(onChangedInputVenda:_onChangedInputVenda),
            MaterialButton(
              shape: CircleBorder(
                  side: BorderSide(
                      color: Colors.black,
                      width: 2
                  )
              ),
                onPressed: _onClearVenda, child: Text("C")
            ),
          ],
        )
      )

    );
  }
}