import 'package:flutter/material.dart';

class DisplayAvailabilityWidget extends StatelessWidget {
  const DisplayAvailabilityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with actual data
    final Map<String, List<Map<String, String>>> availability = {
      "Monday": [
        {"start": "09:00", "end": "17:00"}
      ],
      "Tuesday": [
        {"start": "10:00", "end": "16:00"}
      ],
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Availability',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  ...entry.value.map((slot) => Text(
                      'From ${slot['start']} to ${slot['end']}')).toList(),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
