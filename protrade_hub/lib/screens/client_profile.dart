import 'package:flutter/material.dart';
import '../widgets/post_job_widget.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  _ClientProfilePageState createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  final List<Map<String, dynamic>> _postedJobs = []; // Job list

  void _navigateToPostJob() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PostJobWidget(),
      ),
    );

    // Add the posted job to the list
    if (result != null && result is Map<String, String>) {
      setState(() {
        _postedJobs.add({
          'title': result['title'],
          'description': result['description'],
          'status': 'Open',
        });
      });
    }
  }

  void _requestCancellation(int index) {
    setState(() {
      _postedJobs[index]['status'] = 'Pending Cancellation';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job cancellation requested. Awaiting contractor confirmation.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Info
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Client Name',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('client@example.com'),
                    Text('+123 456 7890'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Post a Job Button
            ElevatedButton.icon(
              onPressed: _navigateToPostJob,
              icon: const Icon(Icons.add),
              label: const Text('Post a Job'),
            ),
            const SizedBox(height: 20),

            // Job List
            const Text(
              'Your Posted Jobs:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _postedJobs.isEmpty
                ? const Text('No jobs posted yet.')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _postedJobs.length,
                    itemBuilder: (context, index) {
                      final job = _postedJobs[index];
                      return Card(
                        child: ListTile(
                          title: Text(job['title'] ?? 'No Title'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(job['description'] ?? 'No Description'),
                              const SizedBox(height: 5),
                              Text(
                                'Status: ${job['status']}',
                                style: TextStyle(
                                  color: job['status'] == 'Pending Cancellation'
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                          trailing: job['status'] == 'Open'
                              ? IconButton(
                                  icon: const Icon(Icons.cancel, color: Colors.red),
                                  onPressed: () => _requestCancellation(index),
                                  tooltip: 'Request Job Cancellation',
                                )
                              : null,
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
