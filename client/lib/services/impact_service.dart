import 'dart:convert';
import 'package:http/http.dart' as http;

class ImpactService {
  // Change this if your backend runs on another machine/IP.
  // If testing on Android emulator, use 10.0.2.2 instead of localhost.
  static const String baseUrl = 'http://10.0.2.2:5000/api/impact';

  // Common headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };

  /// GET /dashboard
  static Future<Map<String, dynamic>> getDashboard() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard'),
      headers: headers,
    );

    return jsonDecode(response.body);
  }

  /// GET /charts
  static Future<Map<String, dynamic>> getCharts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/charts'),
      headers: headers,
    );

    return jsonDecode(response.body);
  }

  /// GET /insights
  static Future<Map<String, dynamic>> getInsights() async {
    final response = await http.get(
      Uri.parse('$baseUrl/insights'),
      headers: headers,
    );

    return jsonDecode(response.body);
  }

  /// GET /monthly-report
  static Future<Map<String, dynamic>> getMonthlyReport() async {
    final response = await http.get(
      Uri.parse('$baseUrl/monthly-report'),
      headers: headers,
    );

    return jsonDecode(response.body);
  }

  /// GET /history
  static Future<Map<String, dynamic>> getHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/history'),
      headers: headers,
    );

    return jsonDecode(response.body);
  }
}
