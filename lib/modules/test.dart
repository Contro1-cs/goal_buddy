import 'package:flutter/material.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), //Adjust Radius for roundness
        ),
      ),
    );
  }
}
