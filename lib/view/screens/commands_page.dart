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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomKeyBoard()
      )

    );
  }
}