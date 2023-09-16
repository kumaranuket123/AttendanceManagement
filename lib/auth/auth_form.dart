import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/constants.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //------------------------------------------
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  String _userName = "";
  bool isLoginPage = true;
  String error = "";
  bool isClicked = false;

  //------------------------------------------

  startAuthentication() async {
    error = "";
    if (_formKey.currentState != null) {
      final validity = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (validity) {
        _formKey.currentState!.save();
        submitForm(_email, _password, _userName);
      } else {
        debugPrint("form state is null");
        setState(() {
          isClicked = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Please Check Email or Password"),
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            elevation: 10,
          ),
        );
      }
    }
  }

  submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential currentUserCredential;
    try {
      if (isLoginPage) {
        currentUserCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        currentUserCredential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String? uid;
        if (currentUserCredential.user != null) {
          uid = currentUserCredential.user!.uid;
          await FirebaseFirestore.instance.collection("users").doc(uid).set({
            'username': username,
            'email': email,
          });
        }
      }
    } catch (err) {
      error = err.toString();
      debugPrint("$err");
    }
    setState(() {
      isClicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isLoginPage)
              TextFormField(
                keyboardType: TextInputType.name,
                key: const ValueKey(valueKeyUser),
                validator: (value) {
                  if (value!.isEmpty) {
                    return errorTextUser;
                  }
                  return null;
                },
                onSaved: (value) {
                  _userName = value ?? "";
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide()),
                  labelText: labelTextUserField,
                  labelStyle: GoogleFonts.roboto(),
                ),
              ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              key: const ValueKey(valueKeyEmail),
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return errorTextEmail;
                }
                return null;
              },
              onSaved: (value) {
                _email = value ?? "";
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide()),
                labelText: labelTextEmailField,
                labelStyle: GoogleFonts.roboto(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              key: const ValueKey(valueKeyPassword),
              validator: (value) {
                if (value!.isEmpty || value.length < 5) {
                  return errorTextPassword;
                }
                return null;
              },
              onSaved: (value) {
                _password = value ?? "";
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide()),
                labelText: labelTextPasswordField,
                labelStyle: GoogleFonts.roboto(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              error,
              style: TextStyle(color: Colors.red),
            ),
            ElevatedButton(
              onPressed: () {
                error = "";
                isClicked = true;
                startAuthentication();
              },
              child: isClicked
                  ? const CircularProgressIndicator.adaptive()
                  : Text(
                      isLoginPage ? login : signUp,
                      style: GoogleFonts.roboto(),
                    ),
            ),
            const SizedBox(height: 10),
            TextButton(
                onPressed: () {
                  isLoginPage = !isLoginPage;
                  setState(() {});
                },
                child: isLoginPage
                    ? Text("Not a account?")
                    : Text("Already have a account?"))
          ],
        ),
      ),
    );
  }
}
