import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'detail_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beauty Store',
      theme: ThemeData(fontFamily: 'Arial'),
      home: const HomeScreen(),
      routes: {
        '/detail': (context) => const DetailScreen(),
      },
    );
  }
}
