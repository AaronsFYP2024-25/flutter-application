import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isClient = true; // Tracks whether "Client" or "Contractor" is selected

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController companyController = TextEditingController();
  final TextEditingController insuranceController = TextEditingController();
  final TextEditingController fieldXController = TextEditingController();
  final TextEditingController fieldYController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Animated Toggle Bar
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isClient = true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isClient ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: const Text(
                        'Client',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isClient = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isClient ? Colors.grey[300] : Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: const Text(
                        'Contractor',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Dynamic Form
            Expanded(
              child: SingleChildScrollView(
                child: isClient ? buildClientForm() : buildContractorForm(),
              ),
            ),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (isClient) {
                  // Handle client sign-up logic
                  print('Client Sign-Up: ${emailController.text}');
                } else {
                  // Handle contractor sign-up logic
                  print('Contractor Sign-Up: ${emailController.text}');
                }
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  // Client Form
  Widget buildClientForm() {
    return Column(
      children: [
        buildTextField(controller: nameController, label: 'Name'),
        buildTextField(controller: emailController, label: 'Email'),
        buildTextField(controller: passwordController, label: 'Password', isPassword: true),
        buildTextField(controller: phoneController, label: 'Phone Number'),
      ],
    );
  }

  // Contractor Form
  Widget buildContractorForm() {
    return Column(
      children: [
        buildTextField(controller: nameController, label: 'Name'),
        buildTextField(controller: companyController, label: 'Company Name'),
        buildTextField(controller: emailController, label: 'Email'),
        buildTextField(controller: passwordController, label: 'Password', isPassword: true),
        buildTextField(controller: phoneController, label: 'Phone Number'),
        buildTextField(controller: insuranceController, label: 'Insurance Number'),
        buildTextField(controller: fieldXController, label: 'Field X'),
        buildTextField(controller: fieldYController, label: 'Field Y'),
      ],
    );
  }

  // Reusable Text Field
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
