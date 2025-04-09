import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _role = 'contractor';
  String _county = 'Antrim';
  String _profilePicUrl = '';
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();

  final List<String> _counties = [
    'Antrim', 'Armagh', 'Carlow', 'Cavan', 'Clare', 'Cork', 'Derry', 'Donegal',
    'Down', 'Dublin', 'Fermanagh', 'Galway', 'Kerry', 'Kildare', 'Kilkenny',
    'Laois', 'Leitrim', 'Limerick', 'Longford', 'Louth', 'Mayo', 'Meath',
    'Monaghan', 'Offaly', 'Roscommon', 'Sligo', 'Tipperary', 'Tyrone',
    'Waterford', 'Westmeath', 'Wexford', 'Wicklow'
  ];

  final List<String> _presetPics = [
    'https://via.placeholder.com/150/FF0000',
    'https://via.placeholder.com/150/00FF00',
    'https://via.placeholder.com/150/0000FF'
  ];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadProfilePic(String uid) async {
    if (_selectedImage == null) return '';
    TaskSnapshot snapshot = await _storage
        .ref('profile_pictures/$uid')
        .putFile(_selectedImage!);
    return await snapshot.ref.getDownloadURL();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
        return;
      }

      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String uid = userCredential.user!.uid;

        if (_selectedImage != null) {
          _profilePicUrl = await _uploadProfilePic(uid);
        } else if (_profilePicUrl.isEmpty) {
          _profilePicUrl = _presetPics[0];
        }

        if (_role == 'contractor') {
          await _firestore.collection('contractor_profiles').doc(uid).set({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'county': _county,
            'profilePicUrl': _profilePicUrl,
            'availability': [],
            'specializations': [],
            'portfolio': [],
            'role': 'contractor',
          });
        } else {
          await _firestore.collection('client_profiles').doc(uid).set({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'county': _county,
            'profilePicUrl': _profilePicUrl,
            'role': 'client',
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign Up Successful! Please log in.')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                style: Theme.of(context).textTheme.bodyMedium,
                validator: (value) => value == null || value.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                style: Theme.of(context).textTheme.bodyMedium,
                validator: (value) => value == null || value.isEmpty ? 'Enter email' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                style: Theme.of(context).textTheme.bodyMedium,
                validator: (value) => value == null || value.isEmpty ? 'Enter phone number' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Upload Profile Picture'),
                  ),
                  const SizedBox(width: 10),
                  const Text('Or choose preset:'),
                ],
              ),
              Wrap(
                spacing: 10,
                children: _presetPics.map((pic) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _profilePicUrl = pic;
                      _selectedImage = null;
                    });
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(pic),
                    radius: 25,
                  ),
                )).toList(),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _county,
                items: _counties.map((county) => DropdownMenuItem(value: county, child: Text(county))).toList(),
                onChanged: (value) => setState(() => _county = value!),
                decoration: const InputDecoration(labelText: 'County'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                style: Theme.of(context).textTheme.bodyMedium,
                validator: (value) => value == null || value.isEmpty ? 'Enter password' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                style: Theme.of(context).textTheme.bodyMedium,
                validator: (value) => value == null || value.isEmpty ? 'Confirm your password' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _role,
                items: const [
                  DropdownMenuItem(value: 'contractor', child: Text('Contractor')),
                  DropdownMenuItem(value: 'client', child: Text('Client')),
                ],
                onChanged: (value) => setState(() => _role = value!),
                decoration: const InputDecoration(labelText: 'Select Role'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
