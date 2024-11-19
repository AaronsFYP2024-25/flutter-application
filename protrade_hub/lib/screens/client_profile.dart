import 'package:flutter/material.dart';

class ClientProfilePage extends StatelessWidget {
  const ClientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Profile'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: Jane Doe', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: jane.doe@example.com', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}