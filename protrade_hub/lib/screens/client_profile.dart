import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/client_widgets.dart';
import '../widgets/shared_widgets.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  _ClientProfilePageState createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String clientId;
  String _name = 'Loading...';
  String _email = 'Loading...';
  String _phone = 'Loading...';
  String _county = 'Loading...';
  String _profilePicUrl = '';

  @override
  void initState() {
    super.initState();
    clientId = _auth.currentUser!.uid;
    _fetchClientProfile();
  }

  void _fetchClientProfile() async {
    try {
      var doc = await _firestore.collection('client_profiles').doc(clientId).get();

      if (doc.exists) {
        setState(() {
          _name = doc['name'] ?? 'Client Name';
          _email = doc['email'] ?? 'client@example.com';
          _phone = doc['phone'] ?? 'No Phone';
          _county = doc['county'] ?? 'No County';
          _profilePicUrl = doc.data()?.containsKey('profilePicUrl') == true ? doc['profilePicUrl'] : '';
        });
      }
    } catch (e) {
      print('Error fetching client profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profilePicUrl.isNotEmpty
                    ? NetworkImage(_profilePicUrl)
                    : const NetworkImage('https://via.placeholder.com/150'),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                _name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            Text('Email: $_email', style: Theme.of(context).textTheme.bodyMedium),
            Text('Phone: $_phone', style: Theme.of(context).textTheme.bodyMedium),
            Text('County: $_county', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Expanded(child: ClientJobsWidget(clientId: clientId)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostJobWidget(clientId: clientId),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Post a Job'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
