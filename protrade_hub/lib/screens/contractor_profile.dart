import 'package:flutter/material.dart';
import 'package:protrade_hub/widgets/display_portfolio_widget.dart';
import 'package:protrade_hub/widgets/edit_profile_widget.dart';
import '../widgets/contractor_profile_overview.dart';
import '../widgets/manage_specializations_widget.dart';
import '../widgets/manage_availability_widget.dart';
import '../widgets/manage_portfolio_widget.dart';
import '../widgets/view_jobs_widget.dart';

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

  List<Map<String, dynamic>> mockPortfolio = [
    {
      'title': 'Bathroom Renovation',
      'description': 'Complete bathroom renovation with modern fixtures.',
      'images': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
    },
    {
      'title': 'Kitchen Remodel',
      'description': 'Custom kitchen design with new cabinetry and lighting.',
      'images': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
    },
  ];

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

  void _onAvailabilityAdded(String day, Map<String, String> availabilityItem) {
    setState(() {
      availability[day]?.add(availabilityItem);
    });
  }

  void _onNewDayAdded(String day) {
    setState(() {
      if (!availability.containsKey(day)) {
        availability[day] = [];
      }
    });
  }

  void _onAvailabilityRemoved(String day, Map<String, String> availabilityItem) {
    setState(() {
      availability[day]?.remove(availabilityItem);
    });
  }

  void _addPortfolioItem(Map<String, dynamic> newItem) {
    if (mockPortfolio.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only have up to 6 portfolio items.')),
      );
      return;
    }

    setState(() {
      mockPortfolio.add(newItem);
    });
  }

  void _deletePortfolioItem(int index) {
    setState(() {
      mockPortfolio.removeAt(index);
    });
  }

  void _onItemTapped(int index) {
    print('Navigating to tab: \$index'); // Debug output
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      'Contractor Profile',
      'Manage Specializations',
      'Manage Availability',
      'Portfolio',
      'Manage Portfolio',
      'Available Jobs',
    ];

    final List<Widget> pages = [
      Center(
        child: ContractorProfileOverview(
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
      ),
      Center(
        child: ManageSpecializationsWidget(
          specializations: specializations,
          onSpecializationAdded: _onSpecializationAdded,
          onSpecializationRemoved: _onSpecializationRemoved,
        ),
      ),
      Center(
        child: ManageAvailabilityWidget(
          availability: availability,
          onAvailabilityAdded: _onAvailabilityAdded,
          onAvailabilityRemoved: _onAvailabilityRemoved,
          onNewDayAdded: _onNewDayAdded,
        ),
      ),
      Center(
        child: DisplayPortfolioWidget(portfolio: mockPortfolio),
      ),
      Center(
        child: ManagePortfolioWidget(
          portfolio: mockPortfolio,
          onPortfolioAdded: _addPortfolioItem,
          onPortfolioDeleted: _deletePortfolioItem,
        ),
      ),
      Center(
        child: const ViewJobsWidget(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        centerTitle: true,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Overview'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Specializations'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Availability'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_album), label: 'Portfolio'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Manage Portfolio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Look for Jobs'),
        ],
      ),
    );
  }
}
