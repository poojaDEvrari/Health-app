import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relax_doc/theme/app_theme.dart';
import 'package:relax_doc/widgets/role_selector.dart';
import 'package:relax_doc/screens/personal_information_screen.dart';
import 'package:relax_doc/screens/business_information_screen.dart';
import 'package:relax_doc/screens/vendor_dashboard_screen.dart';
import 'package:relax_doc/screens/sign_up_screen.dart';
import 'package:relax_doc/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  UserRole role = UserRole.customer;
  bool hidePassword = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.lightBgGradient,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        Center(
                          child: Image.asset(
                            'assets/images/welcome_illustration.png',
                            height: 140,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            'Welcome to RelaxDoc',
                            style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            'Smart Healthcare Simplified',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        RoleSelector(
                          value: role,
                          onChanged: (r) => setState(() => role = r),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Email or Mobile number',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: passwordController,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => hidePassword = !hidePassword),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                              child: const Text('Login Via OTP'),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                              child: const Text('Forgot Password?'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  final email = emailController.text.trim();
                                  final password = passwordController.text;
                                  if (email.isEmpty || password.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please enter email and password')),
                                    );
                                    return;
                                  }

                                  final roleStr = (role == UserRole.vendor) ? 'VENDOR' : 'CUSTOMER';

                                  setState(() => isLoading = true);
                                  try {
                                    final res = await AuthService.login(
                                      email: email,
                                      password: password,
                                      role: roleStr,
                                    );
                                    if (!mounted) return;
                                    if (role == UserRole.vendor) {
                                      final isNew = AuthService.inferVendorIsNew(res);
                                      if (isNew) {
                                        Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(builder: (_) => const BusinessInformationScreen()),
                                          (route) => false,
                                        );
                                      } else {
                                        Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (_) => VendorDashboardScreen(
                                              dashboard: const <String, dynamic>{},
                                              stats: const <String, dynamic>{},
                                            ),
                                          ),
                                          (route) => false,
                                        );
                                      }
                                    } else {
                                      Navigator.of(context).pop(true);
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Login failed: $e')),
                                    );
                                  } finally {
                                    if (mounted) setState(() => isLoading = false);
                                  }
                                },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
                              children: [
                                const TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                  text: 'Create Account',
                                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const SignUpScreen(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
