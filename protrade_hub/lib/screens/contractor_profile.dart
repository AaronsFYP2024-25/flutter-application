import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ContractorProfilePage extends StatefulWidget {
  const ContractorProfilePage({super.key});

  @override
  _ContractorProfilePageState createState() => _ContractorProfilePageState();
}

class _ContractorProfilePageState extends State<ContractorProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _cvUrl = "";
  String _fullName = "";
  String _email = "";
  String _phone = "";

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    String? contractorId = _auth.currentUser?.uid;
    if (contractorId == null) return;

    DocumentSnapshot doc =
        await _firestore.collection("contractor_profiles").doc(contractorId).get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data() as Map<String, dynamic>;

      setState(() {
        _cvUrl = data["cvUrl"] ?? "";
        _fullName = data["fullName"] ?? "Contractor Name";
        _email = data["email"] ?? "No Email";
        _phone = data["phoneNumber"] ?? "No Phone Number";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contractor Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ✅ Profile Info
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_fullName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(_email),
                    Text(_phone),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ✅ Display CV Download/Open Button
            if (_cvUrl.isNotEmpty) ...[
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text("View CV"),
                onPressed: () async {
                  final Uri url = Uri.parse(_cvUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Could not open CV.")),
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
