import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // For state management
import '/models/background_model.dart'; // Custom background color model
import '/models/language_model.dart';   // Custom language toggle model
import 'log_in.dart';
import 'user_preference.dart';
import 'home_screen.dart';
import 'detail_screen.dart';

void main() {
  runApp(const MyApp()); // Entry point of the Flutter app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Backgroundmodel and LanguageModel are provided at the root level
        // so they can be accessed anywhere in the app via Provider.of<>()
        ChangeNotifierProvider(create: (_) => Backgroundmodel()),
        ChangeNotifierProvider(create: (_) => LanguageModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Removes debug banner
        title: 'Shopaholic App', // App title
        theme: ThemeData(
          primarySwatch: Colors.pink, // App primary theme color
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login', // Start the app at the login screen
        routes: {
          // Define navigation routes for the app
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/preferences': (context) => UserPreferencePage(),
          '/detail': (context) => DetailScreen(),
        },
      ),
    );
  }
}
