import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContractorProfileViewWidget extends StatelessWidget {
  final String contractorId;
  final String applicationId;
  final String jobId;
  final String clientId;

  const ContractorProfileViewWidget({
    super.key,
    required this.contractorId,
    required this.applicationId,
    required this.jobId,
    required this.clientId,
  });

  // Approve contractor
  void _approveApplication(BuildContext context) async {
    await FirebaseFirestore.instance.collection('jobs').doc(jobId).update({
      'assignedTo': contractorId,
      'status': 'In Progress',
    });

    await FirebaseFirestore.instance.collection('job_applications').doc(applicationId).update({
      'status': 'Approved',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contractor approved for this job!')),
    );

    Navigator.pop(context);
  }

  // Reject contractor
  void _rejectApplication(BuildContext context) async {
    await FirebaseFirestore.instance.collection('job_applications').doc(applicationId).update({
      'status': 'Rejected',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contractor application rejected.')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contractor Profile")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection("contractor_profiles").doc(contractorId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Contractor profile not found.'));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text("Name: ${data['fullName']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("Phone: ${data['phone']}"),
              const SizedBox(height: 20),

              // Work Hours
              const Text("Work Hours", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              data['availability'] != null
                  ? Column(
                      children: (data['availability'] as List<dynamic>)
                          .map((hour) => Text("• $hour"))
                          .toList(),
                    )
                  : const Text("No work hours available."),

              const SizedBox(height: 20),

              // Specializations
              const Text("Specializations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              data['specializations'] != null
                  ? Column(
                      children: (data['specializations'] as List<dynamic>)
                          .map((spec) => Text("• $spec"))
                          .toList(),
                    )
                  : const Text("No specializations listed."),

              const SizedBox(height: 20),

              // Portfolio
              const Text("Portfolio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              data['portfolio'] != null
                  ? Column(
                      children: (data['portfolio'] as List<dynamic>)
                          .map((work) => Image.network(work, height: 100))
                          .toList(),
                    )
                  : const Text("No portfolio items available."),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => _approveApplication(context),
                child: const Text('Accept'),
              ),
              ElevatedButton(
                onPressed: () => _rejectApplication(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Deny'),
              ),
            ],
          );
        },
      ),
    );
  }
}
