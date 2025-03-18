import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/contractor_widgets.dart';
import '../widgets/shared_widgets.dart';

class ContractorProfilePage extends StatefulWidget {
  const ContractorProfilePage({super.key});

  @override
  _ContractorProfilePageState createState() => _ContractorProfilePageState();
}

class _ContractorProfilePageState extends State<ContractorProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _currentIndex = 0; // Controls BottomNavigationBar index
  late String contractorId;

  // Placeholder profile info
  String _name = '';
  String _email = '';
  String _phone = '';
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
    // Fetch data logic (implement as needed from Firestore)
    setState(() {
      _name = 'Contractor Name';
      _email = 'contractor@example.com';
      _phone = '+1234567890';
    });
  }

  final List<Widget> _tabs = [];

  @override
  Widget build(BuildContext context) {
    _tabs.clear();
    _tabs.addAll([
      ContractorProfileOverview(
        name: _name,
        email: _email,
        phone: _phone,
        contractorId: contractorId,
      ),
      ManageAvailabilityWidget(
        availability: _availability,
        onAvailabilityAdded: (newAvailability) {
          setState(() {
            _availability = newAvailability;
          });
        },
        contractorId: contractorId,
      ),
      ManageSpecializationsWidget(
        specializations: _specializations,
        onSpecializationAdded: (newSpecializations) {
          setState(() {
            _specializations = newSpecializations;
          });
        },
        contractorId: contractorId,
      ),
      ManagePortfolioWidget(
        portfolio: _portfolio,
        onPortfolioAdded: (newPortfolio) {
          setState(() {
            _portfolio = newPortfolio;
          });
        },
        contractorId: contractorId,
      ),
      ViewMyJobsWidget(contractorId: contractorId),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contractor Profile'),
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
        currentIndex: _currentIndex,
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
