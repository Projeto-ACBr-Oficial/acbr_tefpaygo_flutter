
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * KeyButon é uma classe co constrói um wigdet de um botão de teclado
 *
 */
class KeyButton extends StatelessWidget {
  final String text;
  final Function(String) processKeyBoardInput;
  final Icon? icon;
  final Color? color;
  const KeyButton(this.text, {Key? key,required this.processKeyBoardInput, this.icon,this.color}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color:  color == null ? Theme
          .of(context)
          .colorScheme
          .primary : color,
      textColor: Theme
          .of(context)
          .colorScheme
          .onPrimary,
      padding:EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: color == null ? Theme
                .of(context)
                .colorScheme
                .primary : color!,
            width: 2.0,
          )
      ),
      onPressed: () {
        print(text);
        processKeyBoardInput(text);

      },
      child: Column(
        children:  icon == null ?[ Text(text)] : [icon!],
      ),

    );
  }

}