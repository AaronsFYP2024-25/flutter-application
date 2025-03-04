import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostJobWidget extends StatefulWidget {
  const PostJobWidget({super.key});

  @override
  _PostJobWidgetState createState() => _PostJobWidgetState();
}

class _PostJobWidgetState extends State<PostJobWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _postJob() async {
    if (_formKey.currentState!.validate()) {
      String? clientId = _auth.currentUser?.uid;
      if (clientId == null) return;

      await _firestore.collection('jobs').add({
        'clientId': clientId,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'status': 'Open',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Job')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Job Title'),
                validator: (value) => value!.isEmpty ? 'Enter a job title' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Job Description'),
                validator: (value) => value!.isEmpty ? 'Enter a job description' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _postJob,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
