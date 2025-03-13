import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'contractor_profile_view_widget.dart';

class ViewJobApplicationsWidget extends StatelessWidget {
  final String jobId;
  final String clientId;

  const ViewJobApplicationsWidget({super.key, required this.jobId, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Applications')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('job_applications')
            .where('jobId', isEqualTo: jobId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No applications yet.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var application = doc.data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text('Contractor ID: ${application['contractorId']}'),
                  subtitle: Text('Status: ${application['status']}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContractorProfileViewWidget(
                            contractorId: application['contractorId'],
                            applicationId: doc.id,
                            jobId: jobId,
                            clientId: clientId,
                          ),
                        ),
                      );
                    },
                    child: const Text('View Profile'),
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
