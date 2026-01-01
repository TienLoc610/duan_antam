import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/role_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AnTamApp());
}

class AnTamApp extends StatelessWidget {
  const AnTamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'An Tâm System',
      theme: ThemeData(
        fontFamily: 'Arimo',
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const RoleSelectionScreen(),
    );
  }
}