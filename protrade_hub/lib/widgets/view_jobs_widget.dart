import 'package:flutter/material.dart';

class ViewJobsWidget extends StatelessWidget {
  const ViewJobsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> jobs = [
      {'title': 'Fix Electrical Wiring', 'description': 'Rewire the entire living room and install new sockets. Make sure the work is completed within 2 days.'},
      {'title': 'Plumbing Work', 'description': 'Fix the leaking pipes in the kitchen and check the water heater for maintenance.'},
      {'title': 'Carpentry Job', 'description': 'Install new kitchen cabinets with a modern design. Ensure the measurements are accurate.'},
    ];

    void _showJobDetails(BuildContext context, Map<String, String> job) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(job['title'] ?? 'Job Details'),
            content: SingleChildScrollView(
              child: Text(
                job['description'] ?? 'No description available.',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            actions: [
              // Accept Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Job accepted!')),
                  );
                },
                child: const Text('Accept'),
              ),
              // Close Button
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Card(
          child: ListTile(
            title: Text(
              job['title'] ?? 'No Title',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              (job['description'] ?? '').length > 50
                  ? '${job['description']!.substring(0, 50)}...' // Show a short preview
                  : job['description']!,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showJobDetails(context, job), // Open the popup dialog
          ),
        );
      },
    );
  }
}
