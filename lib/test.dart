import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckUserExistsPage extends StatefulWidget {
  const CheckUserExistsPage({super.key});

  @override
  State<CheckUserExistsPage> createState() => _CheckUserExistsPageState();
}

class _CheckUserExistsPageState extends State<CheckUserExistsPage> {
  String status = 'Checking...';

  @override
  void initState() {
    super.initState();
    _checkIfUserDocExists();
  }

  Future<void> _checkIfUserDocExists() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        setState(() => status = 'User not logged in');
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        setState(() => status = 'Document exists ✅');
      } else {
        setState(() => status = 'Document does not exist ❌');
      }
    } catch (e) {
      setState(() => status = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check User Document')),
      body: Center(
        child: Text(
          status,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
