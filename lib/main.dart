import 'package:flutter/material.dart';
import 'package:wulflex_admin/screens/splash_screens/splash_screen_1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override                                                                                                                                                           
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wulflex Admin',
      theme: ThemeData(
      ),
      home: const ScreenSplash1()
    );
  }
}