import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'contractor_profile.dart';
import 'client_profile.dart';
import 'admin_dashboard.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Software Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add a logo or introductory text
            const Text(
              'Welcome to Trade Software',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.construction, size: 100, color: Colors.blue),
            const SizedBox(height: 32),

            // Email TextField
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),

            // Login Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final email = _emailController.text.trim();
                final password = _passwordController.text.trim();

                if (email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill out all fields')),
                  );
                  return;
                }

                // Role-based Navigation Logic
                if (email == 'admin@demo.com' && password == 'admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminDashboard()),
                  );
                } else if (email == 'contractor@demo.com' && password == 'contractor') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContractorProfilePage()),
                  );
                } else if (email == 'client@demo.com' && password == 'client') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ClientProfilePage()),
                  );
                } else if (email == 'contractadmin@demo.com' && password == 'contractadmin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContractorProfilePage()), // Contractor admin for testing
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid login credentials')),
                  );
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),

            // Sign-Up Button
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text('Sign Up as Contractor or User'),
            ),
          ],
        ),
      ),
    );
  } //end of build
} //end of LoginPage
