import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:relax_doc/config.dart';

class DashboardService {
  static Future<Map<String, dynamic>> fetchVendorDashboard() async {
    final uri = Uri.parse('$serverBase/dashboard-service/dashboard/vendor-dashboard');
    final res = await http.post(uri, headers: {"Content-Type": "application/json"}, body: '');
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Dashboard fetch failed: ${res.statusCode} ${res.body}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return (body['data'] ?? {}) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> fetchVendorDashboardStats() async {
    final uri = Uri.parse('$serverBase/dashboard-service/dashboard/vendor-dashboard/stats');
    final res = await http.post(uri, headers: {"Content-Type": "application/json"}, body: '');
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Dashboard stats fetch failed: ${res.statusCode} ${res.body}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return (body['data'] ?? {}) as Map<String, dynamic>;
  }
}
