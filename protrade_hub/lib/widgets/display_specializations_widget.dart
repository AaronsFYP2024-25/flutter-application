import 'package:flutter/material.dart';

class DisplaySpecializationsWidget extends StatelessWidget {
  final List<String> specializations;

  const DisplaySpecializationsWidget({super.key, required this.specializations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Specializations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        specializations.isEmpty
            ? const Text("No specializations added.")
            : Column(
                children: specializations.map((spec) => Text(spec)).toList(),
              ),
      ],
    );
  }
}
