import 'package:flutter/material.dart';

class ContractorProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contractor Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: John Doe', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: contractor@demo.com', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Phone: +1234567890', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Edit Profile Coming Soon')),
                );
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  } //end of build
} //end of ContractorProfilePage
