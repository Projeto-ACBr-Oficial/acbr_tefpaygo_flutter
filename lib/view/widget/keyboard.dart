import 'package:flutter/material.dart';

import 'key_button.dart';

class CustomKeyBoard extends StatelessWidget {
  final Function(String) processKeyBoardInput;

  const CustomKeyBoard({Key? key, required this.processKeyBoardInput})
      : super(key: key);

  final double _spacing = 2.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
          child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KeyButton('1', processKeyBoardInput: processKeyBoardInput),
            SizedBox(width: _spacing),
            KeyButton('2', processKeyBoardInput: processKeyBoardInput),
            SizedBox(width: _spacing),
            KeyButton('3', processKeyBoardInput: processKeyBoardInput),
            SizedBox(width: _spacing),
            KeyButton("C",
                processKeyBoardInput: processKeyBoardInput,
                color: Colors.red,
                icon: Icon(Icons.backspace)),
          ],
        ),
        SizedBox(height: _spacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KeyButton('4', processKeyBoardInput: processKeyBoardInput),
            SizedBox(width: _spacing),
            KeyButton('5', processKeyBoardInput: processKeyBoardInput),
            SizedBox(width: _spacing),
            KeyButton('6', processKeyBoardInput: processKeyBoardInput),
            SizedBox(width: _spacing),
            KeyButton("CE",
                processKeyBoardInput: processKeyBoardInput,
                color: Colors.yellow,
                icon: Icon(Icons.clear)),
          ],
        ),
        SizedBox(height: _spacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KeyButton('7', processKeyBoardInput: processKeyBoardInput),
            SizedBox(width: _spacing),
            KeyButton('8', processKeyBoardInput: processKeyBoardInput),
            SizedBox(width: _spacing),
            KeyButton('9', processKeyBoardInput: processKeyBoardInput),
            SizedBox(width: _spacing),
            KeyButton("PAGAR",
                processKeyBoardInput: processKeyBoardInput,
                color: Colors.green,
                icon: Icon(Icons.check)),
          ],
        ),
        SizedBox(height: _spacing),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Flexible(
            child: SizedBox(
              width: 360,
              child: KeyButton("0", processKeyBoardInput: processKeyBoardInput)
            ),
          )
        ]),
      ]));
    });
  }
}
