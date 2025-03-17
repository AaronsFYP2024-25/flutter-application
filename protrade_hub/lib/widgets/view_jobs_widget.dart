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

  // Fetch open jobs
  void _fetchJobs() {
    _firestore
        .collection('jobs')
        .where('status', isEqualTo: 'Open')
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

  // Apply for a job
  void _applyForJob(String jobId) async {
    String? contractorId = _auth.currentUser?.uid;
    if (contractorId == null) return;

    // Check if contractor already applied
    var existingApplication = await _firestore
        .collection('job_applications')
        .where('jobId', isEqualTo: jobId)
        .where('contractorId', isEqualTo: contractorId)
        .get();

    if (existingApplication.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have already applied for this job.')),
      );
      return;
    }

    await _firestore.collection('job_applications').add({
      'jobId': jobId,
      'contractorId': contractorId,
      'status': 'Pending',
      'appliedAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Application submitted! Waiting for client approval.')),
    );
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
                        onPressed: () => _applyForJob(job['jobId']),
                        child: const Text('Apply for Job'),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
