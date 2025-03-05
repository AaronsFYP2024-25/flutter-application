import 'package:flutter/material.dart';

class ManageAvailabilityWidget extends StatefulWidget {
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
  _ManageAvailabilityWidgetState createState() => _ManageAvailabilityWidgetState();
}

class _ManageAvailabilityWidgetState extends State<ManageAvailabilityWidget> {
  final TextEditingController _controller = TextEditingController();

  void _addAvailability() {
    if (_controller.text.isNotEmpty) {
      widget.onAvailabilityAdded(_controller.text);
      _controller.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Availability")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Enter availability (e.g., Monday 9AM - 5PM)",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addAvailability,
              child: const Text("Add Availability"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.availability.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.availability[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => widget.onAvailabilityRemoved(widget.availability[index]),
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
