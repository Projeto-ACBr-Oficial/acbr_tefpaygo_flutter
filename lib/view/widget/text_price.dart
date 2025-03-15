import 'package:demo_tefpaygo_simples/view/width_helper.dart';
import 'package:flutter/material.dart';

class TextPrice extends StatefulWidget {
  String _initialPrice = "0,00";

  TextPrice(this._initialPrice);

  _TextPriceState createState() => _TextPriceState();
}

class _TextPriceState extends State<TextPrice> {
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = calculeWidth(constraints.maxWidth);
        return Container(
          width: width,
          padding: const EdgeInsets.all(15.0),
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: theme.brightness == Brightness.dark ? Colors.black.withOpacity(0.5) : theme.shadowColor.withOpacity(0.2),
                blurRadius: 10.0,
                offset: Offset(0, 2.5),
              ),
            ],
            color: theme.colorScheme.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "R\$ " + widget._initialPrice,
                style: TextStyle(
                  fontSize: 30.0,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
