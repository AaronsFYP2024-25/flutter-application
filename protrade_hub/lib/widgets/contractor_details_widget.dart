import 'package:flutter/material.dart';

class ContractorDetailsWidget extends StatelessWidget {
  const ContractorDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace these with actual data from your backend or state management
    final String name = "John Doe";
    final String email = "johndoe@example.com";
    final String phone = "+1234567890";

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contractor Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Name: $name'),
            Text('Email: $email'),
            Text('Phone: $phone'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to edit profile page or show a dialog
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
