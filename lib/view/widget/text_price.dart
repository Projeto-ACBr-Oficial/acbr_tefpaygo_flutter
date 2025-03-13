import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextPrice extends StatefulWidget {
  String _initialPrice = "0,00";

  TextPrice(this._initialPrice);

  _TextPriceState createState() => _TextPriceState();
}

class _TextPriceState extends State<TextPrice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, 2.5),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "R\$ " + widget._initialPrice,
            style: TextStyle(fontSize: 30.0),
          ),
        ],
      ),
    );
  }
}
