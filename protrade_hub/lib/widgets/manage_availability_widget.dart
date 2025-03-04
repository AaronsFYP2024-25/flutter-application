import 'package:flutter/material.dart';

class ManageAvailabilityWidget extends StatelessWidget {
  final List<String> availability;
  final Function(String) onAvailabilityAdded;
  final Function(String) onAvailabilityRemoved;

  const ManageAvailabilityWidget({
    super.key,
    required this.availability,
    required this.onAvailabilityAdded,
    required this.onAvailabilityRemoved,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Availability")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: const InputDecoration(labelText: "Enter availability")),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  onAvailabilityAdded(_controller.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add Availability"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: availability.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(availability[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onAvailabilityRemoved(availability[index]),
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
