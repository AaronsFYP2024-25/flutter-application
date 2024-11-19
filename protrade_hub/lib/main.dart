import 'package:flutter/material.dart';
import 'screens/login__page.dart';

void main() {
  runApp(const TradeSoftwareApp());
} //end of main

class TradeSoftwareApp extends StatelessWidget {
  const TradeSoftwareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  } //end of build
} //end of TradeSoftwareApp


