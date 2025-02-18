import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'key_button.dart';

class CustomKeyBoard extends StatelessWidget {
    final Function(String) processKeyBoardInput;
    const CustomKeyBoard({Key? key,required this.processKeyBoardInput}) : super(key: key);


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
                KeyButton('1', processKeyBoardInput: processKeyBoardInput),
                KeyButton('2' , processKeyBoardInput: processKeyBoardInput),
                KeyButton('3' , processKeyBoardInput: processKeyBoardInput),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KeyButton('4',  processKeyBoardInput: processKeyBoardInput),
                KeyButton('5',  processKeyBoardInput: processKeyBoardInput),
                KeyButton('6',processKeyBoardInput: processKeyBoardInput),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KeyButton('7',processKeyBoardInput: processKeyBoardInput),
                KeyButton('8',processKeyBoardInput: processKeyBoardInput),
                KeyButton('9',processKeyBoardInput: processKeyBoardInput  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KeyButton(
                    'C',
                    processKeyBoardInput: processKeyBoardInput,
                    color: Colors.red
                ),
                KeyButton('0',processKeyBoardInput: processKeyBoardInput),
                KeyButton('CE',icon:Icon(Icons.arrow_back),processKeyBoardInput: processKeyBoardInput),
              ],
            ),
          ],
        ),
      );
  }

}
