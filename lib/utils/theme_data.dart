import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.green,
  primaryColor: Colors.green,
  primaryColorLight: Colors.green,
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.black),
  ),
  tabBarTheme: const TabBarTheme(
    dividerColor: Color(0xFFFFFFFF),
    labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(fontSize: 15),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    displayLarge: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blue,
    textTheme: ButtonTextTheme.primary,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.blue,
  ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.green,
  ).copyWith(
    primary: Colors.green,
    // secondary: Colors.greenAccent,
    // onPrimary: Colors.white,
    // primaryContainer: Colors.green[700],
    // secondaryContainer: Colors.green[200],
  ),
);

// final ThemeData darkTheme = ThemeData(
//   useMaterial3: true,
//   primarySwatch: Colors.green,
//   primaryColor: Colors.green,
//   primaryColorLight: Colors.green,
//   scaffoldBackgroundColor: const Color(0xFF121212),
//   appBarTheme: const AppBarTheme(
//     iconTheme: IconThemeData(color: Colors.white),
//   ),
//   tabBarTheme: TabBarTheme(
//     dividerColor: Colors.green.withOpacity(0.1),
//     labelStyle: const TextStyle(
//       color: Colors.white,
//       fontSize: 16,
//       fontWeight: FontWeight.bold,
//     ),
//     unselectedLabelStyle: const TextStyle(
//       fontSize: 15,
//       color: Colors.white,
//     ),
//   ),
//   iconTheme: const IconThemeData(color: Colors.white),
//   textTheme: const TextTheme(
//     bodyLarge: TextStyle(color: Colors.white),
//     bodyMedium: TextStyle(color: Colors.white),
//     displayLarge: TextStyle(color: Colors.white),
//     titleLarge: TextStyle(color: Colors.white),
//   ),
//   buttonTheme: ButtonThemeData(
//     buttonColor: Colors.grey[800],
//     textTheme: ButtonTextTheme.primary,
//   ),
//   progressIndicatorTheme: const ProgressIndicatorThemeData(
//     color: Colors.blue,
//   ),
//   colorScheme: ColorScheme.fromSwatch(
//     primarySwatch: Colors.green,
//   ).copyWith(
//     primary: Colors.green,
//     // secondary: Colors.greenAccent,
//     // onPrimary: Colors.white,
//     // primaryContainer: Colors.green[700],
//     // secondaryContainer: Colors.green[200],
//   ),
// );

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.green,
  primaryColor: Colors.green,
  primaryColorLight: Colors.green,
  useMaterial3: true,
  scaffoldBackgroundColor: const Color.fromARGB(255, 45, 44, 44),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor: Color(0xFF1E1E1E),
  ),
  tabBarTheme: const TabBarTheme(
    dividerColor: Color.fromARGB(255, 45, 44, 44),
    labelStyle: TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    unselectedLabelStyle: TextStyle(fontSize: 15, color: Colors.grey),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    displayLarge: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.green,
    textTheme: ButtonTextTheme.primary,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.green,
  ),
  cardTheme: const CardTheme(
    color: Color.fromARGB(255, 27, 28, 27),
  ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.green,
    brightness: Brightness.dark,
  ).copyWith(
    primary: Colors.green.withOpacity(0.8),
    surface: const Color.fromARGB(255, 55, 48, 48),
  ),
);
