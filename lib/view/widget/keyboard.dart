import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomKeyBoard extends StatelessWidget {
  const CustomKeyBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2,
          children: const [


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KeyButton('1'),
                KeyButton('2'),
                KeyButton('3'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KeyButton('4'),
                KeyButton('5'),
                KeyButton('6'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KeyButton('7'),
                KeyButton('8'),
                KeyButton('9'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KeyButton('0'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class KeyButton extends StatelessWidget {
  final String text;
  const KeyButton(this.text, {Key? key}) : super(key: key);

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
        print('Pressed $text');

      },
      child: Text(text),
    );
  }
}