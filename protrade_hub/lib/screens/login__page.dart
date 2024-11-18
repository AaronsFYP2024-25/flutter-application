import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'contractor_profile.dart';
import 'client_profile.dart';
import 'admin_dashboard.dart';


class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trade Software Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text;
                final password = _passwordController.text;

                if (email == 'admin@demo.com' && password == 'admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminDashboard()),
                  );
                } else if (email == 'contractor@demo.com' && password == 'contractor') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContractorProfilePage()),
                  );
                } else if (email == 'client@demo.com' && password == 'client') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClientProfilePage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid login credentials')),
                  );
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text('Sign Up as Contractor or User'),
            ),
          ],
        ),
      ),
    );
  } //end of build
} //end of LoginPage
