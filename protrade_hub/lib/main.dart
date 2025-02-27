import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/contractor_profile.dart';
import 'screens/admin_dashboard.dart';
import 'screens/client_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TradeSoftwareApp());
} //end of main

class TradeSoftwareApp extends StatelessWidget {
  const TradeSoftwareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ProTrade App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/contractorProfile': (context) => const ContractorProfilePage(),
        '/adminDashboard': (context) => const AdminDashboard(),
        '/clientProfile': (context) => const ClientProfilePage(),
      },
    );
  } //end of build
} //end of TradeSoftwareApp
