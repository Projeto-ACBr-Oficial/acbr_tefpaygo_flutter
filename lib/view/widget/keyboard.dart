import 'package:flutter/material.dart';

import '../_core/app_colors.dart';

class CustomKeyBoard extends StatelessWidget {
  final Function(String) processKeyBoardInput;

  const CustomKeyBoard({Key? key, required this.processKeyBoardInput})
      : super(key: key);

  static const double _maxKeyboardWidth = 400.0;

  static const List<String> _keys = [
    '1', '2', '3',
    '4', '5', '6',
    '7', '8', '9',
    'C', '0', 'CE',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _maxKeyboardWidth),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < _keys.length; i += 3)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: _keys.sublist(i, i + 3).map((key) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: NumericKeyButton(
                          text: key,
                          onPressed: () => processKeyBoardInput(key),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 8),
            PayButton(onPressed: () => processKeyBoardInput('PAGAR')),
          ],
        ),
      ),
    );
  }
}

class NumericKeyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const NumericKeyButton({
    Key? key, 
    required this.text, 
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color buttonColor =  AppColors.secondary;
    Color textColor = theme.colorScheme.onPrimaryContainer;
    
    Widget buttonChild = Center(
      child: Text(
        text,
        style: TextStyle(
          color: textColor, 
          fontSize: 20, 
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    if (text == 'C') {
      buttonColor = AppColors.dangerLight;
      textColor = Colors.white;
      buttonChild = Icon(
        Icons.clear,
        color: textColor,
        size: 24,
      );
    } else if (text == 'CE') {
      buttonColor = AppColors.warning;
      textColor = Colors.white;
      buttonChild = Icon(
        Icons.backspace, 
        color: textColor, 
        size: 24,
      );
    }

    return AspectRatio(
      aspectRatio: 1.16,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: buttonChild),
          ),
        ),
      ),
    );
  }
}

class PayButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PayButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.success,
                AppColors.successDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: const Center(
        child: Text(
          'Pagar',
              style: TextStyle(
                color: Colors.white, 
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
