import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/manage_availability_widget.dart';
import '../widgets/manage_specializations_widget.dart';
import '../widgets/manage_portfolio_widget.dart';
import '../widgets/edit_profile_widget.dart';

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
  List<String> _availability = [];
  List<String> _specializations = [];
  List<String> _portfolio = [];

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    String? contractorId = _auth.currentUser?.uid;
    if (contractorId == null) return;

    DocumentSnapshot doc = await _firestore.collection("contractor_profiles").doc(contractorId).get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data() as Map<String, dynamic>;

      setState(() {
        _cvUrl = data["cvUrl"] ?? "";
        _fullName = data["fullName"] ?? "Contractor Name";
        _email = data["email"] ?? "No Email";
        _phone = data["phoneNumber"] ?? "No Phone Number";
        
        // ✅ Ensure lists are initialized correctly to prevent errors
        _availability = (data["availability"] as List<dynamic>?)?.cast<String>() ?? [];
        _specializations = (data["specializations"] as List<dynamic>?)?.cast<String>() ?? [];
        _portfolio = (data["portfolio"] as List<dynamic>?)?.cast<String>() ?? [];
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
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(_email),
                    Text(_phone),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ✅ Buttons for Sections
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileWidget(
                    currentName: _fullName, 
                    currentEmail: _email, // ✅ Fix: Pass email
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              icon: const Icon(Icons.schedule),
              label: const Text("Manage Availability"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageAvailabilityWidget(
                    availability: _availability,
                    onAvailabilityAdded: (newAvailability) { // ✅ Fix: Handle added availability
                      setState(() {
                        _availability.add(newAvailability);
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              icon: const Icon(Icons.work),
              label: const Text("Manage Specializations"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageSpecializationsWidget(
                    specializations: _specializations,
                    onSpecializationAdded: (newSpecialization) { // ✅ Fix: Handle added specialization
                      setState(() {
                        _specializations.add(newSpecialization);
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text("Manage Portfolio"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManagePortfolioWidget(
                    portfolio: _portfolio,
                    onPortfolioAdded: (newPortfolioItem) { // ✅ Fix: Handle added portfolio items
                      setState(() {
                        _portfolio.add(newPortfolioItem);
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

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
