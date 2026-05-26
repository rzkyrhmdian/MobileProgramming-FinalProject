import 'package:flutter/material.dart';
import 'package:mobileprogramming_finalproject/screens/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      title: 'SiPatuh',
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      home: LandingPage(),
      debugShowCheckedModeBanner: false,
    ));
  }
}
