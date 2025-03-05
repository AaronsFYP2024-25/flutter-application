import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/view_jobs_widget.dart';
import '../widgets/manage_availability_widget.dart';
import '../widgets/manage_specializations_widget.dart';
import '../widgets/manage_portfolio_widget.dart';

class ContractorProfilePage extends StatefulWidget {
  const ContractorProfilePage({super.key});

  @override
  _ContractorProfilePageState createState() => _ContractorProfilePageState();
}

class _ContractorProfilePageState extends State<ContractorProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _contractorName = "Contractor Name";
  String _email = "No Email";
  String _phone = "No Phone Number";
  List<String> _availability = [];
  List<String> _specializations = [];
  List<String> _portfolio = [];

  @override
  void initState() {
    super.initState();
    _fetchContractorProfile();
  }

  // Fetches contractor profile details from Firestore
  void _fetchContractorProfile() async {
    String? contractorId = _auth.currentUser?.uid;
    if (contractorId == null) return;

    DocumentSnapshot doc =
        await _firestore.collection("contractor_profiles").doc(contractorId).get();

    if (doc.exists && doc.data() != null) {
      setState(() {
        _contractorName = doc["fullName"] ?? "Contractor Name";
        _email = doc["email"] ?? "No Email";
        _phone = doc["phoneNumber"] ?? "No Phone Number";
        _availability = List<String>.from(doc["availability"] ?? []);
        _specializations = List<String>.from(doc["specializations"] ?? []);
        _portfolio = List<String>.from(doc["portfolio"] ?? []);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contractor Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Info
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
                    Text(_contractorName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(_email),
                    Text(_phone),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // View Available Jobs Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewJobsWidget()),
                );
              },
              icon: const Icon(Icons.work),
              label: const Text('View Available Jobs'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Manage Availability
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageAvailabilityWidget(
                      availability: _availability, 
                      onAvailabilityAdded: (newAvailability) {
                        setState(() {
                          _availability.add(newAvailability);
                        });
                      },
                      onAvailabilityRemoved: (removedAvailability) {
                        setState(() {
                          _availability.remove(removedAvailability);
                        });
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.schedule),
              label: const Text('Availability'),
            ),

            // Manage Specializations
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageSpecializationsWidget(
                      specializations: _specializations, 
                      onSpecializationAdded: (newSpecialization) {
                        setState(() {
                          _specializations.add(newSpecialization);
                        });
                      },
                      onSpecializationRemoved: (removedSpecialization) {
                        setState(() {
                          _specializations.remove(removedSpecialization);
                        });
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.build),
              label: const Text('Specializations'),
            ),

            // Manage Portfolio
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManagePortfolioWidget(
                      portfolio: _portfolio, 
                      onPortfolioAdded: (newPortfolioItem) {
                        setState(() {
                          _portfolio.add(newPortfolioItem);
                        });
                      },
                      onPortfolioRemoved: (removedPortfolioItem) {
                        setState(() {
                          _portfolio.remove(removedPortfolioItem);
                        });
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.image),
              label: const Text('Portfolio'),
            ),
          ],
        ),
      ),
    );
  }
}
