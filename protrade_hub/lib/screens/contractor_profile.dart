import 'package:flutter/material.dart';

class ContractorProfilePage extends StatefulWidget {
  const ContractorProfilePage({super.key});

  @override
  _ContractorProfilePageState createState() => _ContractorProfilePageState();
}

class _ContractorProfilePageState extends State<ContractorProfilePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ContractorDetailsPage(),
    const ManageSpecializationsPage(),
    const ManageAvailabilityPage(),
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

class ContractorDetailsPage extends StatelessWidget {
  const ContractorDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Welcome to Your Profile!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Here you can manage your specializations and availability.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ManageSpecializationsPage extends StatefulWidget {
  const ManageSpecializationsPage({super.key});

  @override
  _ManageSpecializationsPageState createState() =>
      _ManageSpecializationsPageState();
}

class _ManageSpecializationsPageState extends State<ManageSpecializationsPage> {
  List<String> specializations = [];
  final TextEditingController specializationController = TextEditingController();

  void addSpecialization() {
    final newSpecialization = specializationController.text.trim();
    if (newSpecialization.isNotEmpty &&
        !specializations.contains(newSpecialization)) {
      setState(() {
        specializations.add(newSpecialization);
      });
      specializationController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Specializations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            children: specializations
                .map((specialization) => Chip(
                      key: Key('specialization-$specialization'),
                      label: Text(specialization),
                      onDeleted: () {
                        setState(() {
                          specializations.remove(specialization);
                        });
                      },
                      deleteIcon: const Icon(Icons.close),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: specializationController,
            decoration: InputDecoration(
              labelText: 'Add Specialization',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: addSpecialization,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ManageAvailabilityPage extends StatefulWidget {
  const ManageAvailabilityPage({super.key});

  @override
  _ManageAvailabilityPageState createState() =>
      _ManageAvailabilityPageState();
}

class _ManageAvailabilityPageState extends State<ManageAvailabilityPage> {
  final Map<String, List<Map<String, String>>> availability = {
    "Monday": [],
    "Tuesday": [],
    "Wednesday": [],
    "Thursday": [],
    "Friday": [],
    "Saturday": [],
    "Sunday": [],
  };

  String? selectedDay;
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  void addAvailability() {
    if (selectedDay == null ||
        startTimeController.text.isEmpty ||
        endTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final startTime = startTimeController.text;
    final endTime = endTimeController.text;

    // Validate time range
    if (startTime.compareTo(endTime) >= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    // Check for overlapping time slots
    final dayAvailability = availability[selectedDay!]!;
    for (var slot in dayAvailability) {
      if ((startTime.compareTo(slot['end']!) < 0) &&
          (endTime.compareTo(slot['start']!) > 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Time slots cannot overlap')),
        );
        return;
      }
    }

    // Add valid time slot
    setState(() {
      availability[selectedDay!]!.add({'start': startTime, 'end': endTime});
    });

    // Clear inputs
    startTimeController.clear();
    endTimeController.clear();
    selectedDay = null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Availability',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedDay,
            onChanged: (value) {
              setState(() {
                selectedDay = value;
              });
            },
            items: availability.keys
                .map((day) => DropdownMenuItem(
                      value: day,
                      child: Text(day),
                    ))
                .toList(),
            decoration: const InputDecoration(
              labelText: 'Select Day',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: startTimeController,
            decoration: const InputDecoration(
              labelText: 'Start Time (HH:mm)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: endTimeController,
            decoration: const InputDecoration(
              labelText: 'End Time (HH:mm)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: addAvailability,
            child: const Text('Add Time Slot'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: availability.entries
                  .expand((entry) => [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        ...entry.value.map((slot) => ListTile(
                              title: Text(
                                  'From ${slot['start']} to ${slot['end']}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    entry.value.remove(slot);
                                  });
                                },
                              ),
                            )),
                        const Divider(),
                      ])
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
