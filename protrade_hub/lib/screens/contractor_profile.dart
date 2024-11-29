import 'package:flutter/material.dart';

class ContractorProfilePage extends StatelessWidget {
  const ContractorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contractor Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Name Section
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile_placeholder.png'), // Replace with a valid image path
                  ),
                  const SizedBox(height: 10),
                  const Text('John Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Details Section
            const Text('Profile Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: const Text('contractor@demo.com'),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Phone'),
                subtitle: const Text('+1234567890'),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Address'),
                subtitle: const Text('123 Trade Lane, Cityville'),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit Profile Coming Soon')),
                    );
                  },
                  child: const Text('Edit Profile'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logout Coming Soon')),
                    );
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Navigation Section
            const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Go to Dashboard'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dashboard Coming Soon')),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.work),
                title: const Text('Manage Jobs'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Job Management Coming Soon')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  } //end of build
} //end of ContractorProfilePage
