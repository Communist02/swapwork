import 'package:flutter/material.dart';

class AppThemes {
  ThemeMode getMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  ThemeData light() {
    final Color accentColor = Colors.amber.shade600;

    final ThemeData base = ThemeData(
      brightness: Brightness.light,
      primaryColor: accentColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFAFAFA),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[700],
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.black,
      ),
      indicatorColor: accentColor,
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
      ), colorScheme: ColorScheme.fromSwatch(primarySwatch: _materialColor(accentColor)).copyWith(secondary: accentColor),
    );
    return base;
  }

  ThemeData dark() {
    const Color primaryColor = Color(0xFF202020);
    const Color cardColor = Color(0xFF272727);

    final ThemeData base = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: _materialColor(Colors.white),
      primaryColor: primaryColor,
      backgroundColor: primaryColor,
      scaffoldBackgroundColor: primaryColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        backgroundColor: cardColor,
        foregroundColor: Colors.grey[400],
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.white,
      ),
      splashColor: Colors.white10,
      cardColor: cardColor,
      indicatorColor: Colors.white,
    );
    return base;
  }
}

MaterialColor _materialColor(Color color) {
  List<double> strengths = [.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
