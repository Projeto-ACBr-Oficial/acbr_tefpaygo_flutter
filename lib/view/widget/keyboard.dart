import 'package:flutter/material.dart';

import '../width_helper.dart';

class CustomKeyBoard extends StatelessWidget {
  final Function(String) processKeyBoardInput;

  const CustomKeyBoard({Key? key, required this.processKeyBoardInput})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = calculeWidth(constraints.maxWidth);
        return Container(
          width: width,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
              color: theme.brightness == Brightness.dark ? Colors.black.withOpacity(0.5) : theme.shadowColor.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  List<String> buttons = [
                    '1', '2', '3',
                    '4', '5', '6',
                    '7', '8', '9',
                    'C', '0', 'CE'
                  ];
                  return NumericKeyButton(
                    text: buttons[index],
                    onPressed: () => processKeyBoardInput(buttons[index]),
                  );
                },
              ),
              const SizedBox(height: 16),
              PayButton(onPressed: () => processKeyBoardInput('PAGAR')),
            ],
          ),
        );
      },
    );
  }
}

class NumericKeyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const NumericKeyButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color buttonColor = theme.colorScheme.primaryContainer;
    Color textColor = theme.colorScheme.onPrimaryContainer;
    Widget buttonChild = Center(
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );

    if (text == 'C') {
      buttonColor = Colors.red;
      buttonChild = const Icon(Icons.clear, color: Colors.white, size: 22);
    } else if (text == 'CE') {
      buttonColor = Colors.amber;
      buttonChild = const Icon(Icons.backspace, color: Colors.white, size: 22);
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: buttonColor,
      ),
      child: buttonChild,
    );
  }
}

class PayButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PayButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.green,
      ),
      child: const Center(
        child: Text(
          'Pagar',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}