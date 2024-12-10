import 'package:flutter/material.dart';

class ManageAvailabilityWidget extends StatefulWidget {
  final Map<String, List<Map<String, String>>> availability;
  final void Function(String day, Map<String, String> slot) onAvailabilityAdded;
  final void Function(String day, Map<String, String> slot)
      onAvailabilityRemoved;
  final void Function(String day) onNewDayAdded;

  const ManageAvailabilityWidget({
    super.key,
    required this.availability,
    required this.onAvailabilityAdded,
    required this.onAvailabilityRemoved,
    required this.onNewDayAdded,
  });

  @override
  _ManageAvailabilityWidgetState createState() =>
      _ManageAvailabilityWidgetState();
}

class _ManageAvailabilityWidgetState extends State<ManageAvailabilityWidget> {
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _newDayController = TextEditingController();
  String? _selectedDay;

  void _addAvailability() {
    if (_selectedDay == null ||
        _startTimeController.text.isEmpty ||
        _endTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final startTime = _startTimeController.text;
    final endTime = _endTimeController.text;

    if (startTime.compareTo(endTime) >= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    final newSlot = {'start': startTime, 'end': endTime};
    widget.onAvailabilityAdded(_selectedDay!, newSlot);

    _startTimeController.clear();
    _endTimeController.clear();
    setState(() {
      _selectedDay = null;
    });
  }

  void _addNewDay() {
    final newDay = _newDayController.text.trim();
    if (newDay.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid day')),
      );
      return;
    }

    if (widget.availability.containsKey(newDay)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Day already exists')),
      );
      return;
    }

    widget.onNewDayAdded(newDay);
    _newDayController.clear();
    setState(() {
      _selectedDay = newDay;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$newDay has been added')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Availability',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  key: const Key('dayDropdown'),
                  value: _selectedDay,
                  onChanged: (value) {
                    setState(() {
                      _selectedDay = value;
                    });
                  },
                  items: widget.availability.keys
                      .map((day) => DropdownMenuItem(
                            key: Key('dropdown_$day'),
                            value: day,
                            child: Text(day),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Select Day',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Add New Day'),
                      content: TextField(
                        controller: _newDayController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Day',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          key: const Key('addNewDayButton'),
                          onPressed: () {
                            _addNewDay();
                            Navigator.pop(context);
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Add Day'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _startTimeController,
            decoration: const InputDecoration(
              labelText: 'Start Time (HH:mm)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _endTimeController,
            decoration: const InputDecoration(
              labelText: 'End Time (HH:mm)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addAvailability,
            child: const Text('Add Time Slot'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: widget.availability.entries
                  .expand((entry) => [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        ...entry.value.map((slot) => ListTile(
                              title: Text(
                                  'From ${slot['start']} to ${slot['end']}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  widget.onAvailabilityRemoved(entry.key, slot);
                                },
                              ),
                            )),
                        const Divider(),
                      ])
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
