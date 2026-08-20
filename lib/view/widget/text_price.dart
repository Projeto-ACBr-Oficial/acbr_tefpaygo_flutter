import 'package:flutter/material.dart';

class TextPrice extends StatelessWidget {

  final String initialPrice;
  TextPrice({super.key, required this.initialPrice});

  static const double _maxWidth = 400.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _maxWidth),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: theme.brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.2)
                  : theme.shadowColor.withOpacity(0.2),
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
              "R\$  $initialPrice",
              style: TextStyle(
                fontSize: 30.0,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
