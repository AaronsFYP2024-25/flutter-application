import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isClient = true; // Tracks whether "Client" or "Contractor" is selected
  final _formKey = GlobalKey<FormState>(); // Key for form validation

  // Controllers for form fields
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

            // Form with Validation
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: isClient ? buildClientForm() : buildContractorForm(),
                ),
              ),
            ),

            // Submit Button
            ElevatedButton(
              key: const Key('signUpButton'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Form is valid
                  if (isClient) {
                    print('Client Sign-Up: ${emailController.text}');
                  } else {
                    print('Contractor Sign-Up: ${emailController.text}');
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Form Submitted Successfully')),
                  );
                } else {
                  // Form is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill out all required fields')),
                  );
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
        buildValidatedField(controller: nameController, label: 'Name'),
        buildValidatedField(controller: emailController, label: 'Email', isEmail: true),
        buildValidatedField(controller: passwordController, label: 'Password', isPassword: true),
        buildValidatedField(controller: phoneController, label: 'Phone Number', isPhone: true),
      ],
    );
  }

  // Contractor Form
  Widget buildContractorForm() {
    return Column(
      children: [
        buildValidatedField(controller: nameController, label: 'Name'),
        buildValidatedField(controller: companyController, label: 'Company Name'),
        buildValidatedField(controller: emailController, label: 'Email', isEmail: true),
        buildValidatedField(controller: passwordController, label: 'Password', isPassword: true),
        buildValidatedField(controller: phoneController, label: 'Phone Number', isPhone: true),
        buildValidatedField(controller: insuranceController, label: 'Insurance Number'),
        buildValidatedField(controller: fieldXController, label: 'Field X'),
        buildValidatedField(controller: fieldYController, label: 'Field Y'),
      ],
    );
  }

  // Reusable Validated Text Field
  Widget buildValidatedField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    bool isEmail = false,
    bool isPhone = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isEmail
            ? TextInputType.emailAddress
            : isPhone
                ? TextInputType.phone
                : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          if (isEmail && !value.contains('@')) {
            return 'Enter a valid email';
          }
          if (isPhone && value.length < 10) {
            return 'Enter a valid phone number';
          }
          if (isPassword && value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }
}
