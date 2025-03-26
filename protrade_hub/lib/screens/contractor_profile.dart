import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/contractor_widgets.dart';
import '../widgets/shared_widgets.dart';

class ContractorProfilePage extends StatefulWidget {
  const ContractorProfilePage({super.key});

  @override
  _ContractorProfilePageState createState() => _ContractorProfilePageState();
}

class _ContractorProfilePageState extends State<ContractorProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _currentIndex = 0;
  late String contractorId;
  String _name = 'Loading...';
  String _email = 'Loading...';
  String _phone = 'Loading...';
  String _county = 'Loading...';
  String _profilePicUrl = '';

  List<String> _availability = [];
  List<String> _specializations = [];
  List<String> _portfolio = [];

  @override
  void initState() {
    super.initState();
    contractorId = _auth.currentUser!.uid;
    _fetchContractorProfile();
  }

  void _fetchContractorProfile() async {
    try {
      var doc = await _firestore.collection('contractor_profiles').doc(contractorId).get();

      if (doc.exists) {
        setState(() {
          _name = doc['name'] ?? 'No Name';
          _email = doc['email'] ?? 'No Email';
          _phone = doc['phone'] ?? 'No Phone';
          _county = doc['county'] ?? 'No County';
          _profilePicUrl = doc['profilePicUrl'] ?? '';

          _availability = List<String>.from(doc['availability'] ?? []);
          _specializations = List<String>.from(doc['specializations'] ?? []);
          _portfolio = List<String>.from(doc['portfolio'] ?? []);
        });
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  final List<Widget> _tabs = [];

  @override
  Widget build(BuildContext context) {
    _tabs.clear();
    _tabs.addAll([
      SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 50,
              backgroundImage: _profilePicUrl.isNotEmpty
                  ? NetworkImage(_profilePicUrl)
                  : const NetworkImage('https://via.placeholder.com/150'),
            ),
            const SizedBox(height: 12),
            Text(_name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(_email),
            Text(_phone),
            Text('County: $_county'),
          ],
        ),
      ),
      ManageAvailabilityWidget(
        availability: _availability,
        onAvailabilityAdded: (newList) {
          setState(() {
            _availability = newList;
          });
        },
        contractorId: contractorId,
      ),
      ManageSpecializationsWidget(
        specializations: _specializations,
        onSpecializationAdded: (newList) {
          setState(() {
            _specializations = newList;
          });
        },
        contractorId: contractorId,
      ),
      ManagePortfolioWidget(
        portfolio: _portfolio,
        onPortfolioAdded: (newList) {
          setState(() {
            _portfolio = newList;
          });
        },
        contractorId: contractorId,
      ),
      ViewMyJobsWidget(contractorId: contractorId),
    ]);

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
      body: _tabs[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewJobsWidget(contractorId: contractorId),
            ),
          );
        },
        child: const Icon(Icons.work),
        tooltip: 'View Available Jobs',
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey[50],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Overview'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Availability'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Specializations'),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Portfolio'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'My Jobs'),
        ],
      ),
    );
  }
}
