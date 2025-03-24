import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/client_widgets.dart';
import '../widgets/shared_widgets.dart'; // Import your shared widgets (where PostJobWidget is)

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
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: _profilePicUrl.isNotEmpty
                  ? NetworkImage(_profilePicUrl)
                  : const NetworkImage('https://via.placeholder.com/150'),
            ),
            const SizedBox(width: 12),
            Text(_name),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: ClientJobsWidget(clientId: clientId),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to Post Job page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostJobWidget(clientId: clientId), // Make sure PostJobWidget is imported
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
