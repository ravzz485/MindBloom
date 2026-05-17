import 'dart:convert';
import 'package:http/http.dart' as http;

class SelfcareService {
  static const String baseUrl = 'http://localhost:5000/api/selfcare';

  // Get all activities
  static Future<List<dynamic>> getActivities({
    String? type,
    String? riskLevel,
  }) async {
    String url = '$baseUrl/activities';
    List<String> params = [];
    if (type != null) params.add('type=$type');
    if (riskLevel != null) params.add('riskLevel=$riskLevel');
    if (params.isNotEmpty) url += '?${params.join('&')}';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    return data['data'];
  }

  // Get recommendations
  static Future<Map<String, dynamic>> getRecommendations(
    String userId,
    String riskLevel,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/recommendations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'riskLevel': riskLevel}),
    );
    final data = jsonDecode(response.body);
    return data['data'];
  }

  // Rate an activity
  static Future<bool> rateActivity(
    String userId,
    String activityId,
    int rating, {
    String? comment,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'activityId': activityId,
        'rating': rating,
        'comment': comment,
      }),
    );
    final data = jsonDecode(response.body);
    return data['success'];
  }

  // Get breathing pattern
  static Future<Map<String, dynamic>> getBreathingPattern(
    String riskLevel,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/breathing?riskLevel=$riskLevel'),
    );
    final data = jsonDecode(response.body);
    return data['data'];
  }

  // Get journal prompts
  static Future<List<dynamic>> getJournalPrompts(String mood) async {
    final response = await http.get(Uri.parse('$baseUrl/prompts?mood=$mood'));
    final data = jsonDecode(response.body);
    return data['data'];
  }

  // Save journal entry
  static Future<bool> saveJournalEntry(
    String userId,
    String entry,
    String mood, {
    String? prompt,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/journal'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'entry': entry,
        'mood': mood,
        'prompt': prompt,
      }),
    );
    final data = jsonDecode(response.body);
    return data['success'];
  }

  // Get emergency support
  static Future<List<dynamic>> getEmergencySupport() async {
    final response = await http.get(Uri.parse('$baseUrl/emergency'));
    final data = jsonDecode(response.body);
    return data['data'];
  }

  // Get ML insights
  static Future<Map<String, dynamic>> getMLInsights(String riskLevel) async {
    final response = await http.get(
      Uri.parse('$baseUrl/ml-insights?riskLevel=$riskLevel'),
    );
    final data = jsonDecode(response.body);
    return data['data'];
  }

  // Get journal entries
  static Future<List<dynamic>> getJournalEntries(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/journal/$userId'));
    final data = jsonDecode(response.body);
    return data['data'];
  }
}
