import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExampleSuccessScreen extends StatelessWidget {
  const ExampleSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen Example'),
      ),
      body: Center(
        child: Text(
          'Sucessfully navigated to Screen Example',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}


class ExampleErrorScreen extends StatelessWidget {
  final String message;
  const ExampleErrorScreen({super.key,required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example Error Screen'),
      ),
      body: Center(
        child: Text(
          'Error: $message',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}