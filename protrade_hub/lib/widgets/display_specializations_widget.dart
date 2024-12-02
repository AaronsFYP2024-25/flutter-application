import 'package:flutter/material.dart';

class DisplaySpecializationsWidget extends StatelessWidget {
  const DisplaySpecializationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with actual data
    final List<String> specializations = ['Plumber', 'Electrician', 'Carpenter'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Specializations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: specializations
                  .map((specialization) => Chip(
                        label: Text(specialization),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
