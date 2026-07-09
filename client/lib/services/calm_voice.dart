import 'package:flutter_tts/flutter_tts.dart';

/// Configures text-to-speech for a calm, soothing guidance voice.
/// Tries to find a female voice among the voices installed on the
/// device/browser; falls back gracefully if none is found.
class CalmVoice {
  static Future<void> configure(FlutterTts tts) async {
    // Slow and slightly warm — the biggest factor in sounding calm.
    await tts.setSpeechRate(0.38);
    await tts.setPitch(1.05);
    await tts.setVolume(1.0);

    try {
      final voices = await tts.getVoices;
      if (voices is! List) return;

      // Voice names differ per platform, e.g.:
      //  Chrome:  "Google UK English Female", "Microsoft Zira - English"
      //  Android: female network voices contain 'female' or codes below
      //  iOS:     "Samantha", "Karen", "Moira", "Tessa"
      const femaleHints = [
        'female',
        'zira', // Windows / Edge
        'samantha', // iOS / macOS
        'karen', // iOS (Australian)
        'moira', // iOS (Irish)
        'tessa', // iOS (South African)
        'serena',
        'x-tpf', 'x-iob', 'x-iog', // Android female voice codes
      ];

      Map? pick;
      for (final v in voices) {
        if (v is! Map) continue;
        final name = (v['name'] ?? '').toString().toLowerCase();
        if (femaleHints.any((h) => name.contains(h))) {
          pick = v;
          break;
        }
      }

      if (pick != null) {
        await tts.setVoice({
          'name': pick['name'].toString(),
          'locale': (pick['locale'] ?? 'en-US').toString(),
        });
      }
    } catch (_) {
      // If anything goes wrong, keep the default voice — never crash.
    }
  }
}
