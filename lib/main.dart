import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const CatatanPolnesApp());
}

class CatatanPolnesApp extends StatefulWidget {
  const CatatanPolnesApp({super.key});

  @override
  State<CatatanPolnesApp> createState() => _CatatanPolnesAppState();
}

class _CatatanPolnesAppState extends State<CatatanPolnesApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleDarkMode() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Gen Z Electric Purple / Violet primary theme
    const primaryViolet = Color(0xFF6C5CE7);
    const darkBackground = Color(0xFF12131C);
    const darkSurface = Color(0xFF1E1E2C);

    return MaterialApp(
      title: 'Catatan POLNES',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryViolet,
          brightness: Brightness.light,
          primary: primaryViolet,
          surfaceTint: primaryViolet.withValues(alpha: 0.05),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryViolet,
          brightness: Brightness.dark,
          surface: darkSurface,
        ),
        scaffoldBackgroundColor: darkBackground,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      home: HomeScreen(
        onToggleDarkMode: _toggleDarkMode,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}
