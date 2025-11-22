import 'package:flutter/material.dart';
import 'package:relax_doc/services/token_store.dart';
import 'package:relax_doc/screens/login_screen.dart';

class AuthGuard {
  static Future<bool> ensureLoggedIn(BuildContext context) async {
    final token = await TokenStore.getToken();
    if (token != null && token.isNotEmpty) return true;

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
    final after = await TokenStore.getToken();
    return (result == true) || (after != null && after.isNotEmpty);
  }

  static Future<void> logout(BuildContext context) async {
    await TokenStore.clearToken();
    await TokenStore.clearRole();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}
