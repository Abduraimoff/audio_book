import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static ThemeData theme() {
    return ThemeData(
      iconTheme: const IconThemeData(color: Colors.white),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        elevation: 0,
        selectedIconTheme: IconThemeData(color: Colors.amber[800]),
        unselectedIconTheme: const IconThemeData(color: Colors.white),
      ),
      scaffoldBackgroundColor: Colors.black,
      textTheme: Typography.englishLike2018.apply(
        bodyColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 20,
        ),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light, // For iOS: (dark icons)
          statusBarIconBrightness: Brightness.dark, // For Android: (dark icons)
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
