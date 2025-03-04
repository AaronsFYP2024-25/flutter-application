import 'package:flutter/material.dart';

class DisplayAvailabilityWidget extends StatelessWidget {
  final List<String> availability;

  const DisplayAvailabilityWidget({super.key, required this.availability});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Availability", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        availability.isEmpty
            ? const Text("No availability set.")
            : Column(
                children: availability.map((time) => Text(time)).toList(),
              ),
      ],
    );
  }
}
