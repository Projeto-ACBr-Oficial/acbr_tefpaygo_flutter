import 'package:demo_tefpaygo_simples/view/widget/large_button.dart';
import 'package:flutter/material.dart';

import 'key_button.dart';

class CustomKeyBoard extends StatelessWidget {
  final Function(String) processKeyBoardInput;

  const CustomKeyBoard({Key? key, required this.processKeyBoardInput})
      : super(key: key);

  final double _spacing = 5.0;
  @override
  Widget build(BuildContext context) {
    return
      ( Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: _spacing,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: _spacing,
            children: [
              KeyButton('1', processKeyBoardInput: processKeyBoardInput),
              KeyButton('2', processKeyBoardInput: processKeyBoardInput),
              KeyButton('3', processKeyBoardInput: processKeyBoardInput),
              KeyButton("C",
                  processKeyBoardInput: processKeyBoardInput,
                  color: Colors.red,
                  icon: Icon(Icons.backspace)),
            ],
          ),
          Row(
            spacing: _spacing,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KeyButton('4', processKeyBoardInput: processKeyBoardInput),
              KeyButton('5', processKeyBoardInput: processKeyBoardInput),
              KeyButton('6', processKeyBoardInput: processKeyBoardInput),
              KeyButton("CE",
                  processKeyBoardInput: processKeyBoardInput,
                  color: Colors.yellow,
                  icon: Icon(Icons.clear)),
            ],
          ),
          Row(
            spacing: _spacing,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KeyButton('7', processKeyBoardInput: processKeyBoardInput),
              KeyButton('8', processKeyBoardInput: processKeyBoardInput),
              KeyButton('9', processKeyBoardInput: processKeyBoardInput),
              KeyButton("PAGAR",
                  processKeyBoardInput: processKeyBoardInput,
                  color: Colors.green,
                  icon: Icon(Icons.check)),
            ],
          ),
          Row(
            spacing: _spacing,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LargeButton("0", processKeyBoardInput: processKeyBoardInput)
            ],
          ),
        ],
      ),
      )
    );
  }
}
