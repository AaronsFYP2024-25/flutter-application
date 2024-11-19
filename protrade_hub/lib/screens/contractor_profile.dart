import 'package:flutter/material.dart';

class ContractorProfilePage extends StatelessWidget {
  const ContractorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contractor Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name: John Doe', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Email: contractor@demo.com', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Phone: +1234567890', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit Profile Coming Soon')),
                );
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  } //end of build
} //end of ContractorProfilePage
