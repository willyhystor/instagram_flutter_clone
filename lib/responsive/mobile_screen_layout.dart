import 'package:flutter/material.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
        'This is Mobile',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
