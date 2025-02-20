import 'package:demo_tefpaygo_simples/view/widget/button.dart';
import 'package:demo_tefpaygo_simples/view/widget/text_price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/card_type.dart';

import '../../../controller/PayGoTefController.dart';

class PaymentPage extends StatefulWidget {

  final double valorPagamento;
  @override
  _PaymentPageState createState() => _PaymentPageState();

  const PaymentPage({super.key,required this.valorPagamento});
}

class _PaymentPageState extends State<PaymentPage> {
  final TefController _tefController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagamento")
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Escolha a forma de pagamento:", style: TextStyle(fontSize: 20)),
              Button(text: "Debito", onPressed: onClicKButtonDebito),
              Button(text: "Credito", onPressed: onClickButtonCredito),
              Button(text: "Voucher", onPressed: onClickButtonVoucher),
              Button(text:"Frota", onPressed: onClickButtonFrota),
              Button(text: "Private Label", onPressed: onClickButtonPrivateLabel)
            ],
          ),
        )
    );
  }

  void onClicKButtonDebito(){
     _tefController
         .payGORequestHandler
         .setCardType(CardType.cartaoDebito);
     pagar();



  }
  void onClickButtonCredito(){
    _tefController
        .payGORequestHandler
        .setCardType(CardType.cartaoCredito);
    pagar();

  }

  void onClickButtonVoucher(){
    _tefController
        .payGORequestHandler
        .setCardType(CardType.cartaoVoucher);
    pagar();

  }

  void onClickButtonFrota(){
    _tefController
        .payGORequestHandler
        .setCardType(CardType.cartaoFrota);
    pagar();

  }

  void onClickButtonPrivateLabel(){
    _tefController
        .payGORequestHandler
        .setCardType(CardType.cartaoPrivateLabel);
    pagar();
  }

  void pagar(){
    _tefController
        .payGORequestHandler
        .venda(widget.valorPagamento);
    Navigator.pop(context);
  }



}