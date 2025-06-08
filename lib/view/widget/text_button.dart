import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Icon icon;

  const CustomButton(
      {required this.text, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Row(
        children: [
          icon,
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
