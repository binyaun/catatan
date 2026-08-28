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
    const primaryTeal = Color(0xFF00695C);

    return MaterialApp(
      title: 'Catatan POLNES',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryTeal,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryTeal,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      ),
      home: HomeScreen(
        onToggleDarkMode: _toggleDarkMode,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}
