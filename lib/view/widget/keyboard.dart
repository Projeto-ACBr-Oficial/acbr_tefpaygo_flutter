import 'package:flutter/material.dart';
import 'key_button.dart';

class CustomKeyBoard extends StatelessWidget {
  final Function(String) processKeyBoardInput;

  const CustomKeyBoard({Key? key, required this.processKeyBoardInput})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth * 0.8;
        return Container(
          width: width,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
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
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                  return _buildButton(context, buttons[index]);
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: processKeyBoardInput('PAGAR'),
                child: Text('Pagar', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () => processKeyBoardInput(text),
      child: Text(text, style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.grey[300],
      ),
    );
  }
}

