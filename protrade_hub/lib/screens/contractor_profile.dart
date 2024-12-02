import 'package:flutter/material.dart';
import 'package:protrade_hub/widgets/edit_profile_widget.dart';
import '../widgets/contractor_profile_overview.dart';
import '../widgets/manage_specializations_widget.dart';
import '../widgets/manage_availability_widget.dart';

class ContractorProfilePage extends StatefulWidget {
  const ContractorProfilePage({super.key});

  @override
  _ContractorProfilePageState createState() => _ContractorProfilePageState();
}

class _ContractorProfilePageState extends State<ContractorProfilePage> {
  List<String> specializations = ['Plumber', 'Electrician'];
  Map<String, List<Map<String, String>>> availability = {
    "Monday": [],
    "Tuesday": [],
  };

  int _selectedIndex = 0;

  void _onSpecializationAdded(String specialization) {
    setState(() {
      specializations.add(specialization);
    });
  }

  void _onSpecializationRemoved(String specialization) {
    setState(() {
      specializations.remove(specialization);
    });
  }

  void _onAvailabilityAdded(String day, Map<String, String> slot) {
    setState(() {
      availability[day] ??= [];
      availability[day]!.add(slot);
    });
  }

  void _onAvailabilityRemoved(String day, Map<String, String> slot) {
    setState(() {
      availability[day]?.remove(slot);
    });
  }

  void _onNewDayAdded(String day) {
    setState(() {
      if (!availability.containsKey(day)) {
        availability[day] = [];
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ContractorProfileOverview(
        specializations: specializations,
        availability: availability,
        onEdit: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfileWidget(
                currentName: "John Doe",
                currentEmail: "johndoe@example.com",
                currentPhone: "+1234567890",
                onSave: (updatedProfile) {
                  // Handle updated profile details here
                },
              ),
            ),
          );
        },
      ),
      ManageSpecializationsWidget(
        specializations: specializations,
        onSpecializationAdded: _onSpecializationAdded,
        onSpecializationRemoved: _onSpecializationRemoved,
      ),
      ManageAvailabilityWidget(
        availability: availability,
        onAvailabilityAdded: _onAvailabilityAdded,
        onAvailabilityRemoved: _onAvailabilityRemoved,
        onNewDayAdded: _onNewDayAdded, // Pass callback to add new days dynamically
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contractor Profile'),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Overview',
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
