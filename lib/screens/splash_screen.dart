import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relax_doc/screens/login_screen.dart';
import 'package:relax_doc/screens/home_screen.dart';
import 'package:relax_doc/theme/app_theme.dart';
import 'package:relax_doc/services/token_store.dart';
import 'package:relax_doc/screens/vendor_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _routeNext();
  }

  Future<void> _routeNext() async {
    // Optional splash delay
    await Future.delayed(const Duration(seconds: 2));
    final token = await TokenStore.getToken();
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      final role = await TokenStore.getRole();
      if (role != null && role.toUpperCase() == 'VENDOR') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const VendorDashboardScreen(
              dashboard: <String, dynamic>{},
              stats: <String, dynamic>{},
            ),
          ),
        );
        return;
      }
    }
    // Default for all unauthenticated (or non-vendor) flows: show Home first
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.lightBgGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 24),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo_big.png',
                    width: 140,
                    height: 140,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stack) => const Icon(
                      Icons.local_hospital,
                      size: 120,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Relax Doc',
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Smart Healthcare Simplified',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF212121),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Loading',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF212121),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
