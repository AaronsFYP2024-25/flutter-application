import 'package:flutter/material.dart';
import 'package:protrade_hub/widgets/contractor_profile_overview.dart';
import 'package:protrade_hub/widgets/manage_specializations_widget.dart';
import 'package:protrade_hub/widgets/manage_availability_widget.dart';

class ContractorProfilePage extends StatefulWidget {
  const ContractorProfilePage({super.key});

  @override
  _ContractorProfilePageState createState() => _ContractorProfilePageState();
}

class _ContractorProfilePageState extends State<ContractorProfilePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ContractorProfileOverview(),
    const ManageSpecializationsWidget(),
    const ManageAvailabilityWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contractor Profile'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Specializations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Availability',
          ),
        ],
      ),
    );
  }
}
