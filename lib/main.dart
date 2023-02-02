import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        backgroundColor: mobileBackgroundColor,
      ),
      title: 'Instagram Clone',
      home: Scaffold(
        body: Text('Let us build instagram'),
      ),
    );
  }
}
