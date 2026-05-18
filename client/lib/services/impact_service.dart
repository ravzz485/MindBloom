import 'dart:convert';
import 'package:http/http.dart' as http;

class ImpactService {
  // Android emulator: 10.0.2.2
  // Windows desktop or web: use http://localhost:5000/api/impact
  static const String baseUrl = 'http://10.0.2.2:5000/api/impact';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };

  static Future<Map<String, dynamic>> getDashboard() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getCharts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/charts'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getInsights() async {
    final response = await http.get(
      Uri.parse('$baseUrl/insights'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getMonthlyReport() async {
    final response = await http.get(
      Uri.parse('$baseUrl/monthly-report'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/history'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }
}
                                                                                                                                                                                                                                                                                          