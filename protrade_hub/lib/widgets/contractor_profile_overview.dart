import 'package:flutter/material.dart';

class ContractorProfileOverview extends StatelessWidget {
  final List<String> specializations;
  final Map<String, List<Map<String, String>>> availability;
  final VoidCallback onEdit;

  const ContractorProfileOverview({
    super.key,
    required this.specializations,
    required this.availability,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final String name = "John Doe"; // Replace with actual data
    final String email = "johndoe@example.com";
    final String phone = "+1234567890";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture and Name
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150', // Replace with actual image URL
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(email),
                  Text(phone),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Specializations
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Specializations',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: specializations
                        .map((specialization) => Chip(label: Text(specialization)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Availability
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Availability',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...availability.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...entry.value.map((slot) =>
                            Text('From ${slot['start']} to ${slot['end']}')).toList(),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Edit Button
          ElevatedButton(
            onPressed: onEdit,
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }
}
