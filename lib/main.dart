import 'package:flutter/material.dart';
// import 'package:sample01/my-reference/Animation_visualizer/screens/home/home_screen.dart';
import 'package:sample01/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visualize AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
          primary: Colors.blueGrey,
          onPrimary: Colors.white,
          secondary: Colors.cyanAccent,
          onSecondary: Colors.black,
          surface: Colors.grey[900],
          onSurface: Colors.white70,
          background: Colors.grey[900],
          onBackground: Colors.white70,
          error: Colors.red,
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: Colors.grey[850],
          margin: const EdgeInsets.all(0),
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.cyanAccent,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.cyanAccent,
          inactiveTrackColor: Colors.grey[700],
          thumbColor: Colors.cyanAccent,
          overlayColor: Colors.cyanAccent.withOpacity(0.2),
          valueIndicatorColor: Colors.blueGrey,
          valueIndicatorTextStyle: const TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade700, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.grey),
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIconColor: Colors.grey,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.grey[200]),
          bodyMedium: TextStyle(color: Colors.grey[300]),
          titleLarge: TextStyle(color: Colors.grey[50]),
          titleMedium: TextStyle(color: Colors.grey[100]),
          labelLarge: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white70,
        ),
      ),
      home: const HomeScreen(), // Start with the Home Screen
    );
  }
}