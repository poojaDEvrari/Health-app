import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:relax_doc/config.dart';
import 'package:relax_doc/services/token_store.dart';

class AuthService {
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? role,
  }) async {
    final uri = Uri.parse("$serverBase/auth-service/auth/login");
    final res = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "role": role ?? "",
      }),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Login failed: ${res.statusCode} ${res.body}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final token = _extractToken(data);
    if (token != null && token.isNotEmpty) {
      await TokenStore.saveToken(token);
    }
    return data;
  }

  static Future<Map<String, dynamic>> register({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required String role,
    required String address,
  }) async {
    final uri = Uri.parse("$serverBase/auth-service/auth/register");
    final res = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "password": password,
        "role": role,
        "address": address,
      }),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Register failed: ${res.statusCode} ${res.body}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final token = _extractToken(data);
    if (token != null && token.isNotEmpty) {
      await TokenStore.saveToken(token);
    }
    return data;
  }

  static String? _extractToken(Map<String, dynamic> data) {
    // Attempts common fields: token, accessToken, access_token, jwt
    final candidates = [
      'token',
      'accessToken',
      'access_token',
      'jwt',
      'data.token',
    ];
    for (final key in candidates) {
      if (key.contains('.')) {
        final parts = key.split('.');
        dynamic cur = data;
        for (final p in parts) {
          if (cur is Map<String, dynamic> && cur.containsKey(p)) {
            cur = cur[p];
          } else {
            cur = null;
            break;
          }
        }
        if (cur is String) return cur;
      } else if (data[key] is String) {
        return data[key] as String;
      }
    }
    return null;
  }
}
