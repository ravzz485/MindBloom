import 'dart:convert';
import 'package:http/http.dart' as http;

/// ⚠️ SET THIS ONCE to your PC's Wi-Fi IPv4 (run `ipconfig`).
/// The phone can't use "localhost" — that means the phone itself.
const String kBaseUrl = 'http://192.168.8.160:5000'; // ← CHANGE THE IP

class JournalService {
  /// Saves an entry. [prompt] tells us which mode it was:
  /// 'guided' or 'free' (and later 'voice').
  static Future<bool> saveEntry({
    required String userId,
    required String entry,
    required String mood,
    required String prompt,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('$kBaseUrl/api/selfcare/journal'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'userId': userId,
              'entry': entry,
              'mood': mood,
              'prompt': prompt,
            }),
          )
          .timeout(const Duration(seconds: 5));
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchEntries(String userId) async {
    try {
      final res = await http
          .get(Uri.parse('$kBaseUrl/api/selfcare/journal/$userId'))
          .timeout(const Duration(seconds: 5));
      final body = jsonDecode(res.body);
      final list =
          (body['entries'] ?? body['data'] ?? body['journals'] ?? []) as List;
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }
}

/// Shared mood options (emoji, backend value).
const List<(String, String)> kMoods = [
  ('😌', 'calm'),
  ('😊', 'happy'),
  ('😐', 'neutral'),
  ('😟', 'anxious'),
  ('😫', 'stressed'),
  ('😢', 'sad'),
  ('😠', 'angry'),
];
