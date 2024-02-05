import 'package:e_market_app/user_activity_cycle/user_activity_cycle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MaterialApp widget, which configures the overall theme and navigation
    return MaterialApp(
        // App title
        title: 'E-Market',

        // Disable the debug banner in the top-right corner
        debugShowCheckedModeBanner: false,

        // Define the theme for the entire app
        theme: ThemeData(
            // Define the default card theme
            cardTheme: const CardTheme(color: Colors.white),

            // Set the primary color for the app
            primaryColor: Colors.deepPurple,

            // Apply Google Fonts to the text theme
            textTheme:
                GoogleFonts.firaSansTextTheme(Theme.of(context).textTheme),

            // App bar theme configuration
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.deepPurple,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
            ),

            // Enable Material 3 design features
            useMaterial3: true),

        // Set the initial screen of the app to UserActivityCycleScreen
        home: UserActivityCycleScreen());
  }
}
