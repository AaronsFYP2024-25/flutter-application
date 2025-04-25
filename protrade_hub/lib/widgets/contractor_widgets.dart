import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/shared_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../widgets/shared_widgets.dart';

/// ================= CONTRACTOR PROFILE OVERVIEW =================
class ContractorProfileOverview extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String contractorId;
  final String profilePicUrl;
  
  const ContractorProfileOverview({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.contractorId,
    required this.profilePicUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(email),
            Text(phone),
          ],
        ),
      ),
    );
  }
}

/// ================= MANAGE AVAILABILITY WIDGET =================
class ManageAvailabilityWidget extends StatefulWidget {
  final List<String> availability;
  final Function(List<String>) onAvailabilityAdded;
  final String contractorId;

  const ManageAvailabilityWidget({
    super.key,
    required this.availability,
    required this.onAvailabilityAdded,
    required this.contractorId,
  });

  @override
  State<ManageAvailabilityWidget> createState() => _ManageAvailabilityWidgetState();
}

class _ManageAvailabilityWidgetState extends State<ManageAvailabilityWidget> {
  late List<String> _availabilityList;

  @override
  void initState() {
    super.initState();
    _availabilityList = List.from(widget.availability);
  }

  void _addAvailability(String availability) async {
    setState(() {
      _availabilityList.add(availability);
    });
    widget.onAvailabilityAdded(_availabilityList);

    await FirebaseFirestore.instance
        .collection('contractor_profiles')
        .doc(widget.contractorId)
        .update({'availability': _availabilityList});
  }

  void _removeAvailability(int index) async {
    setState(() {
      _availabilityList.removeAt(index);
    });
    widget.onAvailabilityAdded(_availabilityList);

    await FirebaseFirestore.instance
        .collection('contractor_profiles')
        .doc(widget.contractorId)
        .update({'availability': _availabilityList});
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _availabilityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Availability')),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: _availabilityList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_availabilityList[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeAvailability(index),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _availabilityController,
                    decoration: const InputDecoration(labelText: 'Add Availability'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_availabilityController.text.trim().isNotEmpty) {
                      _addAvailability(_availabilityController.text.trim());
                      _availabilityController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= MANAGE SPECIALIZATIONS WIDGET =================
class ManageSpecializationsWidget extends StatefulWidget {
  final List<String> specializations;
  final Function(List<String>) onSpecializationAdded;
  final String contractorId;

  const ManageSpecializationsWidget({
    super.key,
    required this.specializations,
    required this.onSpecializationAdded,
    required this.contractorId,
  });

  @override
  State<ManageSpecializationsWidget> createState() => _ManageSpecializationsWidgetState();
}

class _ManageSpecializationsWidgetState extends State<ManageSpecializationsWidget> {
  late List<String> _specializationList;

  @override
  void initState() {
    super.initState();
    _specializationList = List.from(widget.specializations);
  }

  void _addSpecialization(String specialization) async {
    setState(() {
      _specializationList.add(specialization);
    });
    widget.onSpecializationAdded(_specializationList);

    await FirebaseFirestore.instance
        .collection('contractor_profiles')
        .doc(widget.contractorId)
        .update({'specializations': _specializationList});
  }

  void _removeSpecialization(int index) async {
    setState(() {
      _specializationList.removeAt(index);
    });
    widget.onSpecializationAdded(_specializationList);

    await FirebaseFirestore.instance
        .collection('contractor_profiles')
        .doc(widget.contractorId)
        .update({'specializations': _specializationList});
  }
  @override
  Widget build(BuildContext context) {
    final TextEditingController _specializationController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Specializations')),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: _specializationList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_specializationList[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeSpecialization(index),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _specializationController,
                    decoration: const InputDecoration(labelText: 'Add Specialization'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_specializationController.text.trim().isNotEmpty) {
                      _addSpecialization(_specializationController.text.trim());
                      _specializationController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= MANAGE PORTFOLIO WIDGET =================
class ManagePortfolioWidget extends StatefulWidget {
  final List<String> portfolio;
  final Function(List<String>) onPortfolioAdded;
  final String contractorId;

  const ManagePortfolioWidget({
    super.key,
    required this.portfolio,
    required this.onPortfolioAdded,
    required this.contractorId,
  });

  @override
  State<ManagePortfolioWidget> createState() => _ManagePortfolioWidgetState();
}

class _ManagePortfolioWidgetState extends State<ManagePortfolioWidget> {
  late List<String> _portfolioList;

  @override
  void initState() {
    super.initState();
    _portfolioList = List.from(widget.portfolio);
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      String filePath = 'portfolio/${widget.contractorId}/$fileName';

      UploadTask uploadTask =
          FirebaseStorage.instance.ref().child(filePath).putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _portfolioList.add(downloadUrl);
      });
      widget.onPortfolioAdded(_portfolioList);

      await FirebaseFirestore.instance
          .collection('contractor_profiles')
          .doc(widget.contractorId)
          .update({'portfolio': _portfolioList});
    }
  }

  void _removePortfolio(int index) async {
    setState(() {
      _portfolioList.removeAt(index);
    });
    widget.onPortfolioAdded(_portfolioList);

    await FirebaseFirestore.instance
        .collection('contractor_profiles')
        .doc(widget.contractorId)
        .update({'portfolio': _portfolioList});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Portfolio')),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: _portfolioList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_portfolioList[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removePortfolio(index),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Add Portfolio Item'),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= CONTRACTOR PROFILE VIEW FOR CLIENT =================
class ContractorProfileViewWidget extends StatelessWidget {
  final String contractorId;

  const ContractorProfileViewWidget({super.key, required this.contractorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contractor Profile')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('contractor_profiles').doc(contractorId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Loading Contractor...'));
          }
          var contractor = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${contractor['name']}'),
                Text('Email: ${contractor['email']}'),
                Text('Phone: ${contractor['phone']}'),
                const SizedBox(height: 12),
                Text('Specializations: ${contractor['specializations']?.join(', ') ?? ''}'),
                const SizedBox(height: 12),
                Text('Availability: ${contractor['availability']?.join(', ') ?? ''}'),
                const SizedBox(height: 12),
                Text('Portfolio: ${contractor['portfolio']?.join(', ') ?? ''}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Accept / Deny buttons functionality will go here
                  },
                  child: const Text('Accept / Deny Buttons Placeholder'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ================= VIEW MY JOBS WIDGET =================
class ViewMyJobsWidget extends StatelessWidget {
  final String contractorId;

  const ViewMyJobsWidget({super.key, required this.contractorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Accepted Jobs')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('job_applications')
            .where('contractorId', isEqualTo: contractorId)
            .where('status', isEqualTo: 'Accepted')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var applications = snapshot.data!.docs;
          if (applications.isEmpty) {
            return const Center(child: Text('No Accepted Jobs.'));
          }
          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              var application = applications[index].data() as Map<String, dynamic>;
              String jobId = application['jobId'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('jobs').doc(jobId).get(),
                builder: (context, jobSnapshot) {
                  if (!jobSnapshot.hasData || !jobSnapshot.data!.exists) {
                    return const ListTile(title: Text('Loading job info...'));
                  }
                  var jobData = jobSnapshot.data!.data() as Map<String, dynamic>;
                  String clientId = jobData['clientId'];

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(jobData['title'] ?? 'No Title'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('County: ${jobData['county'] ?? 'Unknown'}'),
                              Text('Status: ${application['status']}'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.message),
                            label: const Text('Message Client'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MessagesPage(
                                    jobId: jobId,
                                    currentUserId: contractorId,
                                    otherUserId: clientId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
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
