import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'log_in.dart'; // Assuming your login screen is named `log_in.dart`
import 'user_preference.dart'; // Assuming user preferences screen
import 'home_screen.dart'; // Your HomeScreen widget
import 'sign_up_screen.dart'; // Your SignUpScreen widget
import 'detail_screen.dart'; // Your DetailScreen widget for product details

void main() {
  runApp(MyApp()); // No need for `const` here
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopaholic App', // Set the app title
        theme: ThemeData(
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login', // Initial screen on launch
        routes: {
          '/login': (context) => LoginScreen(), // No `const` here
          '/signUp': (context) => SignUpScreen(), // No `const` here
          '/home': (context) => HomeScreen(), // No `const` here
          '/preferences': (context) => UserPreferencePage(), // No `const` here
          '/detail': (context) => DetailScreen(), // No `const` here
        },
      ),
    );
  }
}
