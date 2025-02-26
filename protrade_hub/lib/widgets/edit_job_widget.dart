import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditJobWidget extends StatefulWidget {
  final String jobId;
  final String currentTitle;
  final String currentDescription;

  const EditJobWidget({
    super.key,
    required this.jobId,
    required this.currentTitle,
    required this.currentDescription,
  });

  @override
  _EditJobWidgetState createState() => _EditJobWidgetState();
}

class _EditJobWidgetState extends State<EditJobWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.currentDescription);
  }

  Future<void> _updateJobDescription() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).update({
        'description': _descriptionController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job description updated successfully!')),
      );

      Navigator.pop(context); // ✅ Return to client profile page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating job: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Job Description')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.currentTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),

              // Job Description Input
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Job Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a description'
                    : null,
              ),
              const SizedBox(height: 20),

              // Update Button
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator() // Show loading state
                    : ElevatedButton(
                        onPressed: _updateJobDescription,
                        child: const Text('Update Job'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
