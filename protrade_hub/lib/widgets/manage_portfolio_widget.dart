import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ManagePortfolioWidget extends StatefulWidget {
  final List<String> portfolio;
  final Function(String) onPortfolioAdded;
  final Function(String) onPortfolioRemoved;

  const ManagePortfolioWidget({
    super.key,
    required this.portfolio,
    required this.onPortfolioAdded,
    required this.onPortfolioRemoved,
  });

  @override
  _ManagePortfolioWidgetState createState() => _ManagePortfolioWidgetState();
}

class _ManagePortfolioWidgetState extends State<ManagePortfolioWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    File file = File(image.path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference storageRef = FirebaseStorage.instance.ref().child("portfolio/$fileName.jpg");
    await storageRef.putFile(file);
    String downloadUrl = await storageRef.getDownloadURL();

    widget.onPortfolioAdded(downloadUrl);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Portfolio")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text("Upload Image"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.portfolio.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Image.network(widget.portfolio[index], width: 50, height: 50, fit: BoxFit.cover),
                      title: const Text("Portfolio Image"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => widget.onPortfolioRemoved(widget.portfolio[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
