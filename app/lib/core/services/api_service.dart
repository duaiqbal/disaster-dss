import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Service connecting to the FastAPI backend with timeout, error recovery,
/// and offline tolerance.
class ApiService {
  // 10.0.2.2 is Android emulator's loopback to host localhost:8000.
  // Can be configured for local testing or physical devices via LAN IP.
  static String baseUrl = 'http://10.0.2.2:8000';

  static const Duration timeoutDuration = Duration(seconds: 4);

  /// Helper to perform safe GET requests
  static Future<dynamic> get(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(uri).timeout(timeoutDuration);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } on SocketException {
      // Offline or backend unreachable
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Helper to perform safe POST requests
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
