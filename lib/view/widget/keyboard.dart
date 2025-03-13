import 'package:flutter/material.dart';
import 'key_button.dart';

class CustomKeyBoard extends StatelessWidget {
  final Function(String) processKeyBoardInput;

  const CustomKeyBoard({Key? key, required this.processKeyBoardInput})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> keys = [
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      'C', '0', 'CE',
      'PAGAR'
    ];

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.0,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          final key = keys[index];
          if (key == 'PAGAR') {
            return GridTile(
              child: GridTile(
                child: ElevatedButton(
                  onPressed: () => processKeyBoardInput(key),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check),
                      SizedBox(width: 4),
                      Text(key),
                    ],
                  ),
                ),
                footer: SizedBox(height: 8.0),
              ),
              footer: SizedBox(height: 8.0),
            );
          } else if (key == 'C') {
            return GridTile(
              child: ElevatedButton(
                onPressed: () => processKeyBoardInput(key),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Icon(Icons.backspace),
              ),
            );
          } else if (key == 'CE') {
            return GridTile(
              child: ElevatedButton(
                onPressed: () => processKeyBoardInput(key),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                child: Icon(Icons.clear),
              ),
            );
          } else {
            return GridTile(
              child: ElevatedButton(
                onPressed: () => processKeyBoardInput(key),
                child: Text(key),
              ),
            );
          }
        },
      ),
    );
  }
}