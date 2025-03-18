import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/client_widgets.dart';

class ClientProfilePageWrapper extends StatefulWidget {
  const ClientProfilePageWrapper({super.key});

  @override
  _ClientProfilePageWrapperState createState() => _ClientProfilePageWrapperState();
}

class _ClientProfilePageWrapperState extends State<ClientProfilePageWrapper> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String clientId = '';

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        clientId = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return clientId.isEmpty
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : ClientProfilePage(clientId: clientId);
  }
}
