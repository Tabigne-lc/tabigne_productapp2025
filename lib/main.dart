import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'background_model.dart';
import 'language_model.dart';
import 'log_in.dart';
import 'user_preference.dart';
import 'home_screen.dart';
import 'sign_up_screen.dart';
import 'detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Backgroundmodel()),
        ChangeNotifierProvider(create: (_) => LanguageModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopaholic App',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/signUp': (context) => SignUpScreen(),
          '/home': (context) => HomeScreen(),
          '/preferences': (context) => UserPreferencePage(),
          '/detail': (context) => DetailScreen(),
        },
      ),
    );
  }
}
