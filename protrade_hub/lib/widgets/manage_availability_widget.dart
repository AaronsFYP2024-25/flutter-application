import 'package:flutter/material.dart';

class ManageAvailabilityWidget extends StatefulWidget {
  const ManageAvailabilityWidget({super.key});

  @override
  _ManageAvailabilityWidgetState createState() =>
      _ManageAvailabilityWidgetState();
}

class _ManageAvailabilityWidgetState extends State<ManageAvailabilityWidget> {
  final Map<String, List<Map<String, String>>> availability = {
    "Monday": [],
    "Tuesday": [],
    "Wednesday": [],
    "Thursday": [],
    "Friday": [],
    "Saturday": [],
    "Sunday": [],
  };

  String? selectedDay;
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  void addAvailability() {
    if (selectedDay == null ||
        startTimeController.text.isEmpty ||
        endTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final startTime = startTimeController.text;
    final endTime = endTimeController.text;

    // Validate time range
    if (startTime.compareTo(endTime) >= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    // Check for overlapping time slots
    final dayAvailability = availability[selectedDay!]!;
    for (var slot in dayAvailability) {
      if ((startTime.compareTo(slot['end']!) < 0) &&
          (endTime.compareTo(slot['start']!) > 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Time slots cannot overlap')),
        );
        return;
      }
    }

    setState(() {
      availability[selectedDay!]!.add({'start': startTime, 'end': endTime});
    });

    startTimeController.clear();
    endTimeController.clear();
    selectedDay = null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Availability',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              key: const Key('dayDropdown'),
              value: selectedDay,
              onChanged: (value) {
                setState(() {
                  selectedDay = value;
                });
              },
              items: availability.keys
                  .map((day) => DropdownMenuItem(
                        value: day,
                        child: Text(day),
                      ))
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Select Day',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('startTimeInput'),
              controller: startTimeController,
              decoration: const InputDecoration(
                labelText: 'Start Time (HH:mm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('endTimeInput'),
              controller: endTimeController,
              decoration: const InputDecoration(
                labelText: 'End Time (HH:mm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: addAvailability,
              child: const Text('Add Time Slot'),
            ),
            const SizedBox(height: 20),
            ...availability.entries.expand((entry) => [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  ...entry.value.map((slot) => ListTile(
                        title: Text('From ${slot['start']} to ${slot['end']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              entry.value.remove(slot);
                            });
                          },
                        ),
                      )),
                  const Divider(),
                ]),
          ],
        ),
      ),
    );
  }
}
