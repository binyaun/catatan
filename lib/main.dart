import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const CatatanPolnesApp());
}

class CatatanPolnesApp extends StatelessWidget {
  const CatatanPolnesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan POLNES',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00695C), // POLNES Teal primary theme
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      ),
      home: const HomeScreen(),
    );
  }
}
