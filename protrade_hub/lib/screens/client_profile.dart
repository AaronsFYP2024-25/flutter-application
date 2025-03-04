import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/post_job_widget.dart';
import '../widgets/edit_job_widget.dart';
import '../widgets/view_jobs_widget.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  _ClientProfilePageState createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _postedJobs = [];
  String _clientName = "";
  String _clientEmail = "";
  String _clientPhone = "";

  @override
  void initState() {
    super.initState();
    _fetchClientData();
    _fetchPostedJobs();
  }

  void _fetchClientData() async {
    String? clientId = _auth.currentUser?.uid;
    if (clientId == null) return;

    DocumentSnapshot clientDoc =
        await _firestore.collection('users').doc(clientId).get();
    if (clientDoc.exists) {
      setState(() {
        _clientName = clientDoc['fullName'] ?? 'Unknown';
        _clientEmail = clientDoc['email'] ?? 'Unknown';
        _clientPhone = clientDoc['phone'] ?? 'Unknown';
      });
    }
  }

  void _fetchPostedJobs() {
    String? clientId = _auth.currentUser?.uid;
    if (clientId == null) return;

    _firestore
        .collection('jobs')
        .where('clientId', isEqualTo: clientId)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _postedJobs = snapshot.docs.map((doc) {
          return {
            'jobId': doc.id,
            'title': doc['title'],
            'description': doc['description'],
            'status': doc['status'],
          };
        }).toList();
      });
    });
  }

  void _navigateToPostJob() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PostJobWidget()),
    );
  }

  void _navigateToEditJob(String jobId, String title, String description) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditJobWidget(
          jobId: jobId,
          currentTitle: title,
          currentDescription: description,
        ),
      ),
    );
  }

  void _requestCancellation(String jobId) async {
    await _firestore.collection('jobs').doc(jobId).update({
      'status': 'Cancelled',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job cancellation requested.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Client Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Client Info
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_clientName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(_clientEmail),
                    Text(_clientPhone),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _navigateToPostJob,
              icon: const Icon(Icons.add),
              label: const Text('Post a Job'),
            ),
            const SizedBox(height: 20),

            // Job List
            const Text('Your Posted Jobs:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: _postedJobs.isEmpty
                  ? const Center(child: Text('No jobs posted yet.'))
                  : ListView.builder(
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
                                    color: job['status'] == 'Cancelled' ? Colors.red : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _navigateToEditJob(job['jobId'], job['title'], job['description']),
                                  tooltip: 'Edit Job',
                                ),
                                if (job['status'] == 'Open')
                                  IconButton(
                                    icon: const Icon(Icons.cancel, color: Colors.red),
                                    onPressed: () => _requestCancellation(job['jobId']),
                                    tooltip: 'Cancel Job',
                                  ),
                              ],
                            ),
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
