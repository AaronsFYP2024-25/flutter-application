import 'package:flutter/material.dart';

class ManageSpecializationsWidget extends StatefulWidget {
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
  _ManageSpecializationsWidgetState createState() => _ManageSpecializationsWidgetState();
}

class _ManageSpecializationsWidgetState extends State<ManageSpecializationsWidget> {
  final TextEditingController _controller = TextEditingController();

  void _addSpecialization() {
    String newSpecialization = _controller.text.trim();
    if (newSpecialization.isNotEmpty && !widget.specializations.contains(newSpecialization)) {
      widget.onSpecializationAdded(newSpecialization);
      _controller.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Specializations")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Enter specialization (e.g., Plumber, Electrician)",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addSpecialization,
              child: const Text("Add Specialization"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.specializations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.specializations[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => widget.onSpecializationRemoved(widget.specializations[index]),
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
