import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/edit_profile_widget.dart';
import '../widgets/manage_availability_widget.dart';
import '../widgets/manage_specializations_widget.dart';
import '../widgets/manage_portfolio_widget.dart';
import '../widgets/display_specializations_widget.dart';
import '../widgets/display_availability_widget.dart';
import '../widgets/display_portfolio_widget.dart';

class ContractorProfilePage extends StatefulWidget {
  const ContractorProfilePage({super.key});

  @override
  _ContractorProfilePageState createState() => _ContractorProfilePageState();
}

class _ContractorProfilePageState extends State<ContractorProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _cvUrl = "";
  String _fullName = "Contractor Name";
  String _email = "No Email";
  String _phone = "No Phone Number";
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

    DocumentSnapshot doc =
        await _firestore.collection('contractor_profiles').doc(contractorId).get();

    if (doc.exists && doc.data() != null) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      setState(() {
        _cvUrl = data["cvUrl"] ?? "";
        _fullName = data["fullName"] ?? "Contractor Name";
        _email = data["email"] ?? "No Email";
        _phone = data["phoneNumber"] ?? "No Phone Number";
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                      Text(
                        _fullName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(_email),
                      Text(_phone),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Edit Profile Button
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileWidget(
                        currentName: _fullName,
                        currentEmail: _email,
                        currentPhone: _phone,
                        onSave: (updatedData) {
                          setState(() {
                            _fullName = updatedData['name']!;
                            _email = updatedData['email']!;
                            _phone = updatedData['phone']!;
                          });

                          String? contractorId = _auth.currentUser?.uid;
                          if (contractorId != null) {
                            _firestore.collection("contractor_profiles").doc(contractorId).update({
                              "fullName": updatedData['name'],
                              "email": updatedData['email'],
                              "phoneNumber": updatedData['phone'],
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Availability Section
              ElevatedButton.icon(
                icon: const Icon(Icons.schedule),
                label: const Text("Manage Availability"),
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

                          String? contractorId = _auth.currentUser?.uid;
                          if (contractorId != null) {
                            _firestore.collection("contractor_profiles").doc(contractorId).update({
                              "availability": _availability,
                            });
                          }
                        },
                        onAvailabilityRemoved: (removedAvailability) {
                          setState(() {
                            _availability.remove(removedAvailability);
                          });

                          String? contractorId = _auth.currentUser?.uid;
                          if (contractorId != null) {
                            _firestore.collection("contractor_profiles").doc(contractorId).update({
                              "availability": _availability,
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
              ),

              // Specializations Section
              ElevatedButton.icon(
                icon: const Icon(Icons.work),
                label: const Text("Manage Specializations"),
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

                          String? contractorId = _auth.currentUser?.uid;
                          if (contractorId != null) {
                            _firestore.collection("contractor_profiles").doc(contractorId).update({
                              "specializations": _specializations,
                            });
                          }
                        },
                        onSpecializationRemoved: (removedSpecialization) {
                          setState(() {
                            _specializations.remove(removedSpecialization);
                          });

                          String? contractorId = _auth.currentUser?.uid;
                          if (contractorId != null) {
                            _firestore.collection("contractor_profiles").doc(contractorId).update({
                              "specializations": _specializations,
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
              ),

              // Portfolio Section
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text("Manage Portfolio"),
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

                          String? contractorId = _auth.currentUser?.uid;
                          if (contractorId != null) {
                            _firestore.collection("contractor_profiles").doc(contractorId).update({
                              "portfolio": _portfolio,
                            });
                          }
                        },
                        onPortfolioRemoved: (removedPortfolioItem) {
                          setState(() {
                            _portfolio.remove(removedPortfolioItem);
                          });

                          String? contractorId = _auth.currentUser?.uid;
                          if (contractorId != null) {
                            _firestore.collection("contractor_profiles").doc(contractorId).update({
                              "portfolio": _portfolio,
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Display Information
              DisplaySpecializationsWidget(specializations: _specializations),
              DisplayAvailabilityWidget(availability: _availability),
              DisplayPortfolioWidget(portfolio: _portfolio),
            ],
          ),
        ),
      ),
    );
  }
}
