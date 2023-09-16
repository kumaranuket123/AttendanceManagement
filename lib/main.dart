import 'package:attendence_management/auth/auth_screen.dart';
import 'package:attendence_management/constant/constants.dart';
import 'package:attendence_management/presentation/screen/home_screen/ui/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: StreamBuilder(
        initialData: const CircularProgressIndicator(),
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, user) {
          if (user.hasData) {
            return const HomeScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
