import 'package:flutter/material.dart';
import 'screens/login__page.dart';

void main() {
  runApp(TradeSoftwareApp());
} //end of main

class TradeSoftwareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  } //end of build
} //end of TradeSoftwareApp
