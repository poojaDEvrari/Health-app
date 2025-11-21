import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relax_doc/theme/app_theme.dart';
import 'package:relax_doc/screens/home_screen.dart';
import 'package:relax_doc/widgets/role_selector.dart';
import 'package:relax_doc/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  UserRole role = UserRole.customer;
  bool hidePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    addressController.dispose();
    super.dispose();
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Image.asset(
                    'assets/images/image1.png',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Sign Up',
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 16),
                RoleSelector(
                  value: role,
                  onChanged: (r) => setState(() => role = r),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: firstNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF6B6C70)),
                    hintText: 'First name',
                    hintStyle: GoogleFonts.poppins(color: Color(0xFF6B6C70)),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6B6C70)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: lastNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.badge, color: Color(0xFF6B6C70)),
                    hintText: 'Last name',
                    hintStyle: GoogleFonts.poppins(color: Color(0xFF6B6C70)),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6B6C70)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.alternate_email, color: Color(0xFF6B6C70)),
                    hintText: 'Email ID',
                    hintStyle: GoogleFonts.poppins(color: Color(0xFF6B6C70)),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6B6C70)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF6B6C70)),
                    hintText: 'Password',
                    hintStyle: GoogleFonts.poppins(color: Color(0xFF6B6C70)),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6B6C70)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => hidePassword = !hidePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.home_outlined, color: Color(0xFF6B6C70)),
                    hintText: 'Address',
                    hintStyle: GoogleFonts.poppins(color: Color(0xFF6B6C70)),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6B6C70)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
                    children: [
                      const TextSpan(text: "By signing up, you're agree to our "),
                      TextSpan(
                        text: 'Terms And Condition',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final email = emailController.text.trim();
                          final first = firstNameController.text.trim();
                          final last = lastNameController.text.trim();
                          final pwd = passwordController.text;
                          final addr = addressController.text.trim();

                          if (email.isEmpty || first.isEmpty || last.isEmpty || pwd.isEmpty || addr.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill all fields')),
                            );
                            return;
                          }

                          String roleStr;
                          roleStr = (role == UserRole.vendor) ? 'VENDOR' : 'CUSTOMER';

                          setState(() => isLoading = true);
                          try {
                            await AuthService.register(
                              firstname: first,
                              lastname: last,
                              email: email,
                              password: pwd,
                              role: roleStr,
                              address: addr,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Registration successful. Please log in.')),
                            );
                            if (mounted) Navigator.of(context).pop();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Registration failed: $e')),
                            );
                          } finally {
                            if (mounted) setState(() => isLoading = false);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
