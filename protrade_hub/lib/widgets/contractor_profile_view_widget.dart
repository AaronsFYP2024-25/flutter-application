import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContractorProfileViewWidget extends StatelessWidget {
  final String contractorId;
  final String applicationId;

  const ContractorProfileViewWidget({
    super.key,
    required this.contractorId,
    required this.applicationId,
  });

  void _updateStatus(BuildContext context, String status) async {
    await FirebaseFirestore.instance
        .collection('job_applications')
        .doc(applicationId)
        .update({'status': status});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Application $status')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contractor Profile')),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('contractor_profiles').doc(contractorId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          var data = snapshot.data!.data()!;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text("Name: ${data['fullName']}"),
              Text("Phone: ${data['phone']}"),
              const SizedBox(height: 20),
              const Text("Availability:", style: TextStyle(fontWeight: FontWeight.bold)),
              ...(data['availability'] as List<dynamic>).map((e) => Text("• $e")).toList(),
              const SizedBox(height: 10),
              const Text("Specializations:", style: TextStyle(fontWeight: FontWeight.bold)),
              ...(data['specializations'] as List<dynamic>).map((e) => Text("• $e")).toList(),
              const SizedBox(height: 10),
              const Text("Portfolio:", style: TextStyle(fontWeight: FontWeight.bold)),
              ...(data['portfolio'] as List<dynamic>).map((url) => Image.network(url, height: 100)).toList(),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _updateStatus(context, 'approved'),
                    child: const Text('Approve'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _updateStatus(context, 'denied'),
                    child: const Text('Deny'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
