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
    // Try Authorization header first
    String? token = _extractTokenFromAuthHeader(res.headers);
    token ??= _extractToken(data);
    if (token != null && token.isNotEmpty) {
      await TokenStore.saveToken(token);
      // Prefer role from API response over selector
      final detectedRole = _extractRole(data) ?? role;
      if (detectedRole != null && detectedRole.isNotEmpty) {
        await TokenStore.saveRole(detectedRole);
      }
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
        // Provide multiple common key casings to maximize backend compatibility
        "firstname": firstname,
        "firstName": firstname,
        "lastname": lastname,
        "lastName": lastname,
        "email": email,
        // Some backends expect username; mirror email when absent
        "username": email,
        "password": password,
        // Role in all caps as requested
        "role": role,
        // Sometimes backends accept userRole or accountType
        "userRole": role,
        "accountType": role,
        "address": address,
      }),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Register failed: ${res.statusCode} ${res.body}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    String? token = _extractTokenFromAuthHeader(res.headers);
    token ??= _extractToken(data);
    if (token != null && token.isNotEmpty) {
      await TokenStore.saveToken(token);
      final detectedRole = _extractRole(data) ?? role;
      if (detectedRole.isNotEmpty) {
        await TokenStore.saveRole(detectedRole);
      }
    }
    return data;
  }

  static String? _extractToken(Map<String, dynamic> data) {
    // 1) Check common flat or nested keys
    final directKeys = ['token', 'accessToken', 'access_token', 'jwt'];
    for (final k in directKeys) {
      final v = data[k];
      if (v is String && v.isNotEmpty) return v;
    }

    // 2) Recursive search through the json for any plausible token string
    String? found;
    void walk(dynamic node) {
      if (found != null) return;
      if (node is String) {
        if (_looksLikeToken(node)) {
          found = node;
        }
        return;
      }
      if (node is Map) {
        for (final entry in node.entries) {
          final key = entry.key.toString().toLowerCase();
          final val = entry.value;
          if (key.contains('token') || key.contains('access')) {
            if (val is String && _looksLikeToken(val)) {
              found = val;
              return;
            }
          }
          walk(val);
          if (found != null) return;
        }
      } else if (node is List) {
        for (final item in node) {
          walk(item);
          if (found != null) return;
        }
      }
    }
    walk(data);
    return found;
  }

  static String? _extractTokenFromAuthHeader(Map<String, String> headers) {
    final auth = headers['authorization'] ?? headers['Authorization'];
    if (auth != null && auth.toLowerCase().startsWith('bearer ')) {
      final token = auth.substring(7).trim();
      if (token.isNotEmpty) return token;
    }
    return null;
  }

  static bool _looksLikeToken(String s) {
    // Heuristic: JWT typically has two dots; any long-ish string also acceptable
    if (s.split('.').length == 3) return true;
    return s.length >= 20;
  }

  // Heuristic helper to decide if a vendor is new/unonboarded from login/registration response
  static bool inferVendorIsNew(Map<String, dynamic> data) {
    // Accept any of these common shapes
    // { isNewVendor: true }
    final v1 = data['isNewVendor'];
    if (v1 is bool) return v1;

    // { vendorExists: false }
    final v2 = data['vendorExists'];
    if (v2 is bool) return !v2;

    // { data: { hasKyc: false } }
    final inner = data['data'];
    if (inner is Map<String, dynamic>) {
      final hasKyc = inner['hasKyc'];
      if (hasKyc is bool) return !hasKyc;
      final profileCompleted = inner['profileCompleted'];
      if (profileCompleted is bool) return !profileCompleted;
    }

    // If role is vendor and we cannot find any explicit KYC/profile flags,
    // treat as NEW to force BusinessInformationScreen first.
    final role = _extractRole(data)?.toUpperCase();
    if (role == 'VENDOR') {
      return true;
    }
    // Default to existing vendor otherwise
    return false;
  }

  // Try to pull a role string such as 'VENDOR' or 'CUSTOMER' from common response shapes
  static String? _extractRole(Map<String, dynamic> data) {
    String? normalize(dynamic v) => v is String ? v.trim() : null;
    final direct = normalize(data['role']);
    if (direct != null && direct.isNotEmpty) return direct;
    final user = data['user'];
    if (user is Map<String, dynamic>) {
      final r = normalize(user['role']);
      if (r != null && r.isNotEmpty) return r;
    }
    final inner = data['data'];
    if (inner is Map<String, dynamic>) {
      final r = normalize(inner['role']);
      if (r != null && r.isNotEmpty) return r;
      final profile = inner['profile'];
      if (profile is Map<String, dynamic>) {
        final rp = normalize(profile['role']);
        if (rp != null && rp.isNotEmpty) return rp;
      }
    }
    return null;
  }
}
