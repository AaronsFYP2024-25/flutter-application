import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  
  List<String> _specializations = [];
  bool _isContractor = false; // Toggle between Client and Contractor

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user == null) return;

        String collection = _isContractor ? "contractor_profiles" : "client_profiles";

        Map<String, dynamic> userData = {
          "userId": user.uid,
          "fullName": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "phoneNumber": _phoneController.text.trim(),
        };

        if (_isContractor) {
          userData.addAll({
            "specializations": _specializations, // Store contractor's specializations
            "availability": [], // Contractors can set availability later
            "portfolio": [], // Empty portfolio upon signup
            "cvUrl": "", // Contractors can upload CV later
          });
        }

        await _firestore.collection(collection).doc(user.uid).set(userData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signup successful!")),
        );

        Navigator.pop(context); // Return to login page
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Account Type Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => setState(() => _isContractor = false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !_isContractor ? Colors.blue : Colors.grey,
                        ),
                        child: const Text("Client"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => setState(() => _isContractor = true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isContractor ? Colors.blue : Colors.grey,
                        ),
                        child: const Text("Contractor"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? "Enter your name" : null,
                ),
                const SizedBox(height: 10),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Enter your email";
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Enter a valid email";
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.length < 6 ? "Password must be at least 6 characters" : null,
                ),
                const SizedBox(height: 10),

                // Phone Field
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Enter your phone number";
                    if (!RegExp(r'^\+?\d{7,15}$').hasMatch(value)) return "Enter a valid phone number";
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Specializations for Contractors
                if (_isContractor) ...[
                  const Text("Specializations", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: _specializationController,
                    decoration: const InputDecoration(
                      labelText: "Enter specialization (e.g., Plumber, Electrician)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_specializationController.text.isNotEmpty) {
                        setState(() {
                          _specializations.add(_specializationController.text.trim());
                          _specializationController.clear();
                        });
                      }
                    },
                    child: const Text("Add Specialization"),
                  ),
                  Wrap(
                    children: _specializations
                        .map((spec) => Chip(
                              label: Text(spec),
                              onDeleted: () {
                                setState(() {
                                  _specializations.remove(spec);
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                ],

                // Signup Button
                ElevatedButton(
                  onPressed: _signUp,
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
