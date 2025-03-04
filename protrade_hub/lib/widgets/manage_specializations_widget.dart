import 'package:flutter/material.dart';

class ManageSpecializationsWidget extends StatelessWidget {
  final List<String> specializations;
  final Function(String) onSpecializationAdded;
  final Function(String) onSpecializationRemoved;

  const ManageSpecializationsWidget({
    super.key,
    required this.specializations,
    required this.onSpecializationAdded,
    required this.onSpecializationRemoved,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Specializations")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Enter specialization (e.g., Plumber, Electrician)"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  onSpecializationAdded(_controller.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add Specialization"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: specializations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(specializations[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onSpecializationRemoved(specializations[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
