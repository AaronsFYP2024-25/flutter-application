import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ================= LOGOUT BUTTON =================
class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButton({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onLogout,
      icon: const Icon(Icons.logout),
      label: const Text('Logout'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

/// ================= DISPLAY SPECIALIZATIONS WIDGET =================
class DisplaySpecializationsWidget extends StatelessWidget {
  final List<String> specializations;

  const DisplaySpecializationsWidget({super.key, required this.specializations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Specializations:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...specializations.map((spec) => Text('- $spec')).toList(),
      ],
    );
  }
}

/// ================= DISPLAY AVAILABILITY WIDGET =================
class DisplayAvailabilityWidget extends StatelessWidget {
  final List<String> availability;

  const DisplayAvailabilityWidget({super.key, required this.availability});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Availability:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...availability.map((avail) => Text('- $avail')).toList(),
      ],
    );
  }
}

/// ================= DISPLAY PORTFOLIO WIDGET =================
class DisplayPortfolioWidget extends StatelessWidget {
  final List<String> portfolio;

  const DisplayPortfolioWidget({super.key, required this.portfolio});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Portfolio:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...portfolio.map((item) => Text('- $item')).toList(),
      ],
    );
  }
}

/// ================= VIEW JOBS WIDGET =================
class ViewJobsWidget extends StatelessWidget {
  final String contractorId;

  const ViewJobsWidget({super.key, required this.contractorId});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Available Jobs')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('jobs').where('status', isEqualTo: 'Open').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var jobs = snapshot.data!.docs;

          if (jobs.isEmpty) {
            return const Center(child: Text('No jobs available.'));
          }

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              var job = jobs[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(job['title']),
                  subtitle: Text(job['description']),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await _firestore.collection('job_applications').add({
                        'jobId': job.id,
                        'contractorId': contractorId,
                        'status': 'Applied',
                        'appliedAt': Timestamp.now(),
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Applied for job')),
                      );
                    },
                    child: const Text('Apply'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
