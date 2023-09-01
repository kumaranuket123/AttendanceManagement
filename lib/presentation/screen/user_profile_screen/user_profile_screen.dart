import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constant/assets.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String uid = '';

  @override
  void initState() {
    getUID();
    // TODO: implement initState
    super.initState();
  }

  getUID() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Center(
        child: uid.isEmpty
            ? CircularProgressIndicator()
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final doc = snapshots.data!.data();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(userIcon),
                        ),
                        Text(doc?['username']),
                        Text("Email: ${doc?['email']}"),
                        ElevatedButton(onPressed: () {}, child: Text("update"))
                      ],
                    );
                  }
                }),
      ),
    );
  }
}
