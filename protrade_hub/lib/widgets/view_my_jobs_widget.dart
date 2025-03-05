import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class ViewMyJobsWidget extends StatefulWidget {
  const ViewMyJobsWidget({super.key});

  @override
  _ViewMyJobsWidgetState createState() => _ViewMyJobsWidgetState();
}

class _ViewMyJobsWidgetState extends State<ViewMyJobsWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _myJobs = [];
  late StreamSubscription _jobSubscription;

  @override
  void initState() {
    super.initState();
    _fetchMyJobs();
  }

  // Fetch jobs where the contractor is assigned
  void _fetchMyJobs() {
    String? contractorId = _auth.currentUser?.uid;
    if (contractorId == null) return;

    _jobSubscription = _firestore
        .collection('jobs')
        .where('assignedTo', isEqualTo: contractorId)
        .snapshots()
        .listen((snapshot) {
      if (!mounted) return; // Prevent calling setState() after dispose
      setState(() {
        _myJobs = snapshot.docs.map((doc) {
          return {
            'jobId': doc.id,
            'title': doc['title'],
            'description': doc['description'],
            'status': doc['status'],
            'clientId': doc['clientId'],
          };
        }).toList();
      });
    }, onError: (error) {
      if (error is FirebaseException && error.code == 'permission-denied') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission denied: Unable to load jobs.')),
        );
      }
    });
  }

  @override
  void dispose() {
    _jobSubscription.cancel(); // Cancel Firestore listener when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Jobs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _myJobs.isEmpty
            ? const Center(child: Text('No assigned jobs yet'))
            : ListView.builder(
                itemCount: _myJobs.length,
                itemBuilder: (context, index) {
                  final job = _myJobs[index];
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
                    ),
                  );
                },
              ),
      ),
    );
  }
}
