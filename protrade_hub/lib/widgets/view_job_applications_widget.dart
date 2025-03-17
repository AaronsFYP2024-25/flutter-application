import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'contractor_profile_view_widget.dart';
import 'edit_job_widget.dart';

class ViewJobApplicationsWidget extends StatelessWidget {
  final String jobId;
  final String clientId;
  final String jobTitle;
  final String jobDescription;
  final String jobStatus;

  const ViewJobApplicationsWidget({
    super.key,
    required this.jobId,
    required this.clientId,
    required this.jobTitle,
    required this.jobDescription,
    required this.jobStatus,
  });

  void _cancelJob(BuildContext context) async {
    await FirebaseFirestore.instance.collection('jobs').doc(jobId).update({'status': 'Cancelled'});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job cancelled')));
  }

  void _deleteJob(BuildContext context) async {
    await FirebaseFirestore.instance.collection('jobs').doc(jobId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job deleted')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(jobTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditJobWidget(jobId: jobId),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => _cancelJob(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteJob(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(title: Text("Description: $jobDescription")),
          ListTile(title: Text("Status: $jobStatus")),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Applicants:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('job_applications')
                  .where('jobId', isEqualTo: jobId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                if (snapshot.data!.docs.isEmpty) return const Text("No applications yet.");

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text("Contractor: ${data['contractorId']}"),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContractorProfileViewWidget(
                              contractorId: data['contractorId'],
                              applicationId: snapshot.data!.docs[index].id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
