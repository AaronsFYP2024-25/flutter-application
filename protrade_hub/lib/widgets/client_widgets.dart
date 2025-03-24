import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ================= CLIENT PROFILE PAGE =================
class ClientProfilePage extends StatefulWidget {
  final String clientId;
  const ClientProfilePage({super.key, required this.clientId});

  @override
  _ClientProfilePageState createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Client Profile')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('Your Posted Jobs:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('jobs')
                  .where('clientId', isEqualTo: widget.clientId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                var jobs = snapshot.data!.docs;
                if (jobs.isEmpty) return const Center(child: Text('No jobs posted yet.'));
                return ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    var job = jobs[index].data() as Map<String, dynamic>;
                    var jobId = jobs[index].id;
                    return Card(
                      child: ListTile(
                        title: Text(job['title']),
                        subtitle: Text('Status: ${job['status']}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobDetailsPage(jobId: jobId),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostJobWidget(clientId: widget.clientId)),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Post a New Job'),
            ),
          )
        ],
      ),
    );
  }
}

/// ================= POST JOB WIDGET =================
class PostJobWidget extends StatefulWidget {
  final String clientId;
  const PostJobWidget({super.key, required this.clientId});

  @override
  _PostJobWidgetState createState() => _PostJobWidgetState();
}

class _PostJobWidgetState extends State<PostJobWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _submitJob() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('jobs').add({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'status': 'Open',
        'clientId': widget.clientId,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Job')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Job Title'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Job Description'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitJob,
                child: const Text('Post Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= EDIT JOB WIDGET =================
class EditJobWidget extends StatefulWidget {
  final String jobId;
  const EditJobWidget({super.key, required this.jobId});

  @override
  _EditJobWidgetState createState() => _EditJobWidgetState();
}

class _EditJobWidgetState extends State<EditJobWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadJobData();
  }

  Future<void> _loadJobData() async {
    var doc = await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).get();
    var data = doc.data();
    if (data != null) {
      _titleController.text = data['title'];
      _descriptionController.text = data['description'];
    }
  }

  Future<void> _updateJob() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).update({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Job')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Job Title'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Job Description'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateJob,
                child: const Text('Update Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= JOB DETAILS PAGE =================
class JobDetailsPage extends StatelessWidget {
  final String jobId;
  const JobDetailsPage({super.key, required this.jobId});

  Future<DocumentSnapshot> _fetchJobDetails() {
    return FirebaseFirestore.instance.collection('jobs').doc(jobId).get();
  }

  Future<void> _deleteJob(BuildContext context) async {
    await FirebaseFirestore.instance.collection('jobs').doc(jobId).delete();
    Navigator.pop(context);
  }

  Future<void> _cancelJob(BuildContext context) async {
    await FirebaseFirestore.instance.collection('jobs').doc(jobId).update({'status': 'Cancelled'});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Details')),
      body: FutureBuilder<DocumentSnapshot>(
        future: _fetchJobDetails(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Job not found'));
          }
          var job = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${job['title']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Description: ${job['description']}'),
                const SizedBox(height: 10),
                Text('Status: ${job['status']}'),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditJobWidget(jobId: jobId)),
                      ),
                      child: const Text('Edit Job'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _cancelJob(context),
                      child: const Text('Cancel Job'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _deleteJob(context),
                      child: const Text('Delete Job'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Applicants:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(child: ViewJobApplicationsWidget(jobId: jobId)),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ================= VIEW JOB APPLICATIONS WIDGET =================
class ViewJobApplicationsWidget extends StatelessWidget {
  final String jobId;
  const ViewJobApplicationsWidget({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('job_applications')
          .where('jobId', isEqualTo: jobId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        var applications = snapshot.data!.docs;
        if (applications.isEmpty) return const Text('No applications yet.');

        return ListView.builder(
          itemCount: applications.length,
          itemBuilder: (context, index) {
            var application = applications[index].data() as Map<String, dynamic>;
            var contractorId = application['contractorId'];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('contractor_profiles').doc(contractorId).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const ListTile(title: Text('Loading...'));
                var contractor = snapshot.data!.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(contractor['name']),
                  subtitle: Text('Specializations: ${contractor['specializations']?.join(', ') ?? ''}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContractorProfileViewWidget(contractorId: contractorId),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

/// ================= Contractor Profile View =================
class ContractorProfileViewWidget extends StatelessWidget {
  final String contractorId;

  const ContractorProfileViewWidget({super.key, required this.contractorId});

  Future<DocumentSnapshot> _fetchContractorProfile() {
    return FirebaseFirestore.instance.collection('contractor_profiles').doc(contractorId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contractor Profile')),
      body: FutureBuilder<DocumentSnapshot>(
        future: _fetchContractorProfile(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Loading profile...'));
          }

          var contractor = snapshot.data!.data() as Map<String, dynamic>;
          var name = contractor['name'] ?? 'N/A';
          var email = contractor['email'] ?? 'N/A';
          var phone = contractor['phone'] ?? 'N/A';
          var specializations = contractor['specializations'] ?? [];
          var availability = contractor['availability'] ?? [];
          var portfolio = contractor['portfolio'] ?? [];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text('Name: $name', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Email: $email'),
                Text('Phone: $phone'),
                const SizedBox(height: 10),
                const Text('Specializations:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...specializations.map<Widget>((s) => Text('- $s')).toList(),
                const SizedBox(height: 10),
                const Text('Availability:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...availability.map<Widget>((a) => Text('- $a')).toList(),
                const SizedBox(height: 10),
                const Text('Portfolio:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...portfolio.map<Widget>((p) => Text('- $p')).toList(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Accept application logic
                        Navigator.pop(context, 'accepted');
                      },
                      child: const Text('Accept'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Deny application logic
                        Navigator.pop(context, 'denied');
                      },
                      child: const Text('Deny'),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}



// ClientJobsWidget - Displays jobs posted by the client
class ClientJobsWidget extends StatelessWidget {
  final String clientId;

  const ClientJobsWidget({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('jobs')
          .where('clientId', isEqualTo: clientId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var jobs = snapshot.data!.docs;

        if (jobs.isEmpty) {
          return const Center(child: Text('No jobs posted yet.'));
        }

        return ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            var job = jobs[index].data();
            var jobId = jobs[index].id;

            return Card(
              child: ListTile(
                title: Text('Title: ${job['title']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description: ${job['description']}'),
                    Text('Status: ${job['status']}'),
                  ],
                ),
                onTap: () {
                  // Navigate to job details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailsPage(jobId: jobId),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

