import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomKeyBoard extends StatelessWidget {
    final Function(String) onChangedInputVenda;
    const CustomKeyBoard({Key? key,required this.onChangedInputVenda}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container (
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KeyButton('1', onChangedInputVenda: onChangedInputVenda),
                KeyButton('2' , onChangedInputVenda: onChangedInputVenda),
                KeyButton('3' , onChangedInputVenda: onChangedInputVenda),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KeyButton('4',  onChangedInputVenda: onChangedInputVenda),
                KeyButton('5',  onChangedInputVenda: onChangedInputVenda),
                KeyButton('6',onChangedInputVenda: onChangedInputVenda),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KeyButton('7',onChangedInputVenda: onChangedInputVenda),
                KeyButton('8',onChangedInputVenda: onChangedInputVenda),
                KeyButton('9',onChangedInputVenda: onChangedInputVenda  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KeyButton('0',onChangedInputVenda: onChangedInputVenda),
              ],
            ),
          ],
        ),
      );
  }

}

class KeyButton extends StatelessWidget {
  final String text;
  final Function(String) onChangedInputVenda;
  const KeyButton(this.text, {Key? key,required this.onChangedInputVenda}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Theme
          .of(context)
          .colorScheme
          .primary,
      textColor: Theme
          .of(context)
          .colorScheme
          .onPrimary,
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      shape: CircleBorder(
          side: BorderSide(
            color: Theme
                .of(context)
                .colorScheme
                .primary,
            width: 2.0,
          )
      ),
      onPressed: () {
        print(text);
        onChangedInputVenda(text);

      },
      child: Text(text),
    );
  }

}