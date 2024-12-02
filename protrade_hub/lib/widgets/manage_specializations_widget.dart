import 'package:flutter/material.dart';

class ManageSpecializationsWidget extends StatefulWidget {
  const ManageSpecializationsWidget({super.key});

  @override
  _ManageSpecializationsWidgetState createState() =>
      _ManageSpecializationsWidgetState();
}

class _ManageSpecializationsWidgetState
    extends State<ManageSpecializationsWidget> {
  List<String> specializations = [];
  final TextEditingController specializationController =
      TextEditingController();

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
