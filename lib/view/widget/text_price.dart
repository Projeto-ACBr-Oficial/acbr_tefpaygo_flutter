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
    return SizedBox(
        width: 400,
        height: 120,
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 2.0),
          ),
          child: Text(
            "R\$ " + widget._initialPrice,
            style: TextStyle(fontSize: 30.0),
          ),
        ));
  }
}
