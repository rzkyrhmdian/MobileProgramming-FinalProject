import 'package:flutter/material.dart';
import 'package:mobileprogramming_finalproject/ui/navigation/landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://calyecnkauxycoxhvhpy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNhbHllY25rYXV4eWNveGh2aHB5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAzMzk4MjEsImV4cCI6MjA5NTkxNTgyMX0.UTITIorFrhLPU6tQRYIj1HlgPWOzO-1dlOn1EeuXViY',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      title: 'SiPatuh',
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      home: const LandingScreen(),
      debugShowCheckedModeBanner: false,
    ));
  }
}
