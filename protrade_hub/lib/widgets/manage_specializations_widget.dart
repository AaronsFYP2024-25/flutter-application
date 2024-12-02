import 'package:flutter/material.dart';

class ManageSpecializationsWidget extends StatefulWidget {
  final List<String> specializations;
  final ValueChanged<String> onSpecializationAdded;
  final ValueChanged<String> onSpecializationRemoved;

  const ManageSpecializationsWidget({
    super.key,
    required this.specializations,
    required this.onSpecializationAdded,
    required this.onSpecializationRemoved,
  });

  @override
  _ManageSpecializationsWidgetState createState() =>
      _ManageSpecializationsWidgetState();
}

class _ManageSpecializationsWidgetState
    extends State<ManageSpecializationsWidget> {
  final TextEditingController _specializationController =
      TextEditingController();

  void _addSpecialization() {
    final newSpecialization = _specializationController.text.trim();
    if (newSpecialization.isNotEmpty &&
        !widget.specializations.contains(newSpecialization)) {
      widget.onSpecializationAdded(newSpecialization);
      _specializationController.clear();
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
            children: widget.specializations
                .map((specialization) => Chip(
                      label: Text(specialization),
                      onDeleted: () =>
                          widget.onSpecializationRemoved(specialization),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _specializationController,
            decoration: InputDecoration(
              labelText: 'Add Specialization',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addSpecialization,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
