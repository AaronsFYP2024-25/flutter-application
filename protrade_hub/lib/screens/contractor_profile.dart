import 'package:flutter/material.dart';

class ContractorProfilePage extends StatefulWidget {
  const ContractorProfilePage({super.key});

  @override
  _ContractorProfilePageState createState() => _ContractorProfilePageState();
}

class _ContractorProfilePageState extends State<ContractorProfilePage> {
  List<String> specializations = [];
  final TextEditingController specializationController = TextEditingController();

  final List<String> jobTags = ["Plumber", "Electrician", "Carpenter", "Painter"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contractor Profile'),
      ),
      body: Padding(
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
                        key: Key('specialization-$specialization'), // Assign unique key
                        label: Text(specialization),
                        onDeleted: () {
                          setState(() {
                            specializations.remove(specialization);
                          });
                        },
                        deleteIcon: const Icon(Icons.close), // Ensure the delete icon is set
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              key: const Key('specializationInput'), // Assign unique key
              controller: specializationController,
              decoration: InputDecoration(
                labelText: 'Add Specialization',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  key: const Key('addSpecializationButton'), // Assign unique key
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final newSpecialization = specializationController.text.trim();
                    if (newSpecialization.isNotEmpty &&
                        !specializations.contains(newSpecialization)) {
                      setState(() {
                        specializations.add(newSpecialization);
                      });
                      specializationController.clear();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Filtered Jobs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: jobTags
                    .where((job) => specializations.any((tag) => job.contains(tag)))
                    .map((job) => Card(
                          key: Key('job-$job'), // Assign unique key
                          child: ListTile(
                            title: Text(job),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
