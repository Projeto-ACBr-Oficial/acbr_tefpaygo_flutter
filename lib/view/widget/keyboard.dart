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
        double maxHeight = calculeHeight(constraints.maxHeight); // Limita altura máxima
        
        return Container(
          width: width,
          constraints: BoxConstraints(
            maxWidth: width,
            maxHeight: maxHeight,
          ),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.1)
                    : theme.shadowColor.withOpacity(0.15),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, gridConstraints) {
                    // Calcula a altura disponível para o grid (subtraindo padding e botão de pagamento)
                    double availableHeight = gridConstraints.maxHeight - 12; // Espaço do botão de pagamento
                    double buttonHeight = (availableHeight - 24) / 4; // 4 linhas de botões com espaçamento
                    double buttonWidth = (width - 32 - 16) / 3; // 3 colunas com espaçamento
                    
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: buttonWidth / buttonHeight,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
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
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
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

  const NumericKeyButton({
    Key? key, 
    required this.text, 
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color buttonColor = theme.colorScheme.primaryContainer;
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
      buttonColor = Colors.red.shade400;
      textColor = Colors.white;
      buttonChild = Icon(
        Icons.clear, 
        color: textColor, 
        size: 24,
      );
    } else if (text == 'CE') {
      buttonColor = Colors.amber.shade600;
      textColor = Colors.white;
      buttonChild = Icon(
        Icons.backspace, 
        color: textColor, 
        size: 24,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: buttonColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
      ),
          child: Center(child: buttonChild),
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
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green.shade600,
                Colors.green.shade700,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
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
