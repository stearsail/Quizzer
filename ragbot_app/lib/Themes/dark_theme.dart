import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFF3F6F4)),
      displayMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.normal,
          color: Color(0xFFF3F6F4)),
      displaySmall: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: Color(0xFFF3F6F4))),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF2E2E2E),
    titleTextStyle: TextStyle(
        fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFFF3F6F4)),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
      height: 65,
      color: Color(0xFF2E2E2E),
      surfaceTintColor: Colors.transparent),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedLabelStyle: TextStyle(fontSize: 15),
    backgroundColor: Color(0xFF2E2E2E),
    unselectedItemColor: Color.fromARGB(255, 216, 216, 216),
    selectedItemColor: Color(0xFF488ABA),
  ),
  cardTheme: const CardTheme(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      surfaceTintColor: Colors.transparent,
      color: Color.fromARGB(255, 82, 82, 82)),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: CircleBorder(),
      backgroundColor: Color(0xFF6738FF),
      foregroundColor: Color.fromARGB(255, 255, 255, 255)),
  dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF2E2E2E),
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(color: Color(0xFFF3F6F4)),
      contentTextStyle: TextStyle(color: Color(0xFFF3F6F4))),
  elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Color(0xFF4E4E4E)),
          surfaceTintColor: MaterialStatePropertyAll(Colors.transparent),
          foregroundColor: MaterialStatePropertyAll(Color(0xFFF3F6F4)))),
);
