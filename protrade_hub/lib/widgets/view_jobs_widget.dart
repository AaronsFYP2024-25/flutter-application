import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewJobsWidget extends StatefulWidget {
  const ViewJobsWidget({super.key});

  @override
  _ViewJobsWidgetState createState() => _ViewJobsWidgetState();
}

class _ViewJobsWidgetState extends State<ViewJobsWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _jobs = [];

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  void _fetchJobs() {
    _firestore
        .collection('jobs')
        .where('status', isEqualTo: 'Open') // Only show open jobs
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _jobs = snapshot.docs.map((doc) {
          return {
            'jobId': doc.id,
            'title': doc['title'],
            'description': doc['description'],
            'status': doc['status'],
            'clientId': doc['clientId'],
          };
        }).toList();
      });
    });
  }

  void _acceptJob(String jobId) async {
    String? contractorId = _auth.currentUser?.uid;
    if (contractorId == null) return;

    // Show a confirmation dialog before accepting the job
    bool confirm = await _showConfirmationDialog();
    if (!confirm) return;

    await _firestore.collection('jobs').doc(jobId).update({
      'status': 'In Progress',
      'assignedTo': contractorId,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job accepted successfully!')),
    );
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Job Acceptance"),
            content: const Text("Are you sure you want to accept this job?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Accept"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Jobs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _jobs.isEmpty
            ? const Center(child: Text('No available jobs'))
            : ListView.builder(
                itemCount: _jobs.length,
                itemBuilder: (context, index) {
                  final job = _jobs[index];
                  return Card(
                    child: ListTile(
                      title: Text(job['title'] ?? 'No Title'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(job['description'] ?? 'No Description'),
                          const SizedBox(height: 5),
                          Text("Status: ${job['status']}", style: const TextStyle(color: Colors.blue)),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => _acceptJob(job['jobId']),
                        child: const Text('Accept Job'),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
