import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:relax_doc/config.dart';

class KycService {
  // Uses multipart if any file is provided. Otherwise sends JSON.
  static Future<void> submitVendorKyc(Map<String, dynamic> payload, {
    File? adharCard,
    File? panCard,
    File? gstCertificate,
    File? medicalCertificate,
  }) async {
    final uri = Uri.parse("$serverBase/vendor-kyc");

    final hasFiles = adharCard != null || panCard != null || gstCertificate != null || medicalCertificate != null;
    if (!hasFiles) {
      final res = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw Exception('KYC submit failed: ${res.statusCode} ${res.body}');
      }
      return;
    }

    final request = http.MultipartRequest('POST', uri);
    // Add fields (stringify nulls as empty or skip)
    payload.forEach((key, value) {
      if (value != null) {
        request.fields[key] = value is String ? value : jsonEncode(value);
      }
    });

    Future<void> addFile(String field, File? file) async {
      if (file == null) return;
      request.files.add(await http.MultipartFile.fromPath(field, file.path));
    }

    await addFile('adharCard', adharCard);
    await addFile('panCard', panCard);
    await addFile('gstCertificate', gstCertificate);
    await addFile('medicalCertificate', medicalCertificate);

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('KYC submit failed: ${res.statusCode} ${res.body}');
    }
  }
}
