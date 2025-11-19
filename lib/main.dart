import 'package:flutter/material.dart';
import 'package:relax_doc/theme/app_theme.dart';
import 'package:relax_doc/screens/splash_screen.dart';

void main() {
  runApp(const RelaxDocApp());
}

class RelaxDocApp extends StatelessWidget {
  const RelaxDocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relax Doc',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
