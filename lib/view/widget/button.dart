import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  Button({ required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0)),
        minWidth: 250,
        onPressed: onPressed,
        child: Text(text),
        color: Theme.of(context).colorScheme.primaryContainer
    );
  }
}