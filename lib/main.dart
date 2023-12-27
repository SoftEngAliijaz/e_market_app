import 'package:e_market_app/screens/user_screens/user_activity_cycle.dart';
import 'package:flutter/material.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ///title
      title: 'E-Market',

      ///debugShowCheckedModeBanner
      debugShowCheckedModeBanner: false,

      ///theme
      theme: ThemeData(
        ///colorScheme
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        ///cardTheme
        cardTheme: const CardTheme(color: Colors.white),

        ///primaryColor
        primaryColor: Colors.deepPurple,

        ///fontFamily
        fontFamily: 'roboto',

        ///app bar theme
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),

        ///useMaterial3
        useMaterial3: true,
      ),

      ///home initial screen
      home: const UserActivityCycleScreen(),
    );
  }
}
