import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'view_job_applications_widget.dart';
import 'edit_job_widget.dart';

class ViewMyJobsWidget extends StatelessWidget {
  final String clientId;
  const ViewMyJobsWidget({super.key, required this.clientId});

  void _deleteJob(BuildContext context, String jobId) async {
    try {
      await FirebaseFirestore.instance.collection('jobs').doc(jobId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting job: $e')),
      );
    }
  }

  void _cancelJob(BuildContext context, String jobId) async {
    try {
      await FirebaseFirestore.instance.collection('jobs').doc(jobId).update({'status': 'Cancelled'});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job cancelled')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cancelling job: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Posted Jobs')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('clientId', isEqualTo: clientId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text('No jobs posted.'));

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text(data['title']),
                  subtitle: Text(data['description']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewJobApplicationsWidget(
                          jobId: doc.id,
                          clientId: clientId,
                          jobTitle: data['title'],
                          jobDescription: data['description'],
                          jobStatus: data['status'],
                        ),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteJob(context, doc.id),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
