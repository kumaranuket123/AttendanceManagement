import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:toast/toast.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController txtTitleController = TextEditingController();
  TextEditingController txtDescController = TextEditingController();

  addTaskOfFirebase() async {
    FocusScope.of(context).unfocus();

    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String uid = user!.uid;

    var time = DateTime.now();

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection("myTask")
        .doc(time.toString())
        .set({
      'title': txtTitleController.text,
      'description': txtDescController.text
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              autocorrect: true,
              decoration: const InputDecoration(
                  label: Text("Enter Title"), border: OutlineInputBorder()),
              controller: txtTitleController,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                  label: Text("Enter Description"),
                  border: OutlineInputBorder()),
              controller: txtDescController,
              maxLines: 8,
              minLines: 1,
            ),
            ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (txtDescController.text.isEmpty ||
                      txtTitleController.text.isEmpty) {
                    debugPrint("error");
                    Toast.show(
                      "Please Check Empty Fields",
                      duration: Toast.lengthLong,
                      gravity: Toast.center,
                    );
                    return;
                  }
                  addTaskOfFirebase();
                  Navigator.pop(context);
                },
                child: const Text("Submit"))
          ],
        ),
      ),
    );
  }
}
