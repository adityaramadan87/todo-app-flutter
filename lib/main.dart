import 'package:flutter/material.dart';
import 'package:learnflutter/loginscreen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'learnFlutter',
      debugShowCheckedModeBanner: false,
      home: new LoginScreen(),
    );
  }
}

