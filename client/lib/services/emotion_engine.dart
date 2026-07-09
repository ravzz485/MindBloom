/// Keyword-based mood detection + recommendation engine.
/// Detects one of 7 moods (calm, happy, neutral, anxious, stressed,
/// sad, angry) from the journal text, with the user's self-selected
/// mood acting as a strong prior (+2). Each mood maps to a goal and
/// five curated recommendations.
class EmotionResult {
  final String mood; // e.g. 'stressed'
  final String emoji;
  final String goal; // "Goal: Lower stress levels."
  final String message; // friendly one-liner
  final List<String> tips; // five recommendations
  const EmotionResult(
    this.mood,
    this.emoji,
    this.goal,
    this.message,
    this.tips,
  );
}

class EmotionEngine {
  static const Map<String, List<String>> _keywords = {
    'calm': [
      'calm',
      'peaceful',
      'relaxed',
      'content',
      'balanced',
      'serene',
      'at ease',
      'settled',
      'quiet mind',
    ],
    'happy': [
      'happy',
      'joy',
      'grateful',
      'thankful',
      'smile',
      'smiled',
      'proud',
      'excited',
      'love',
      'wonderful',
      'great day',
      'amazing',
      'blessed',
    ],
    'anxious': [
      'anxious',
      'anxiety',
      'worry',
      'worried',
      'nervous',
      'panic',
      'afraid',
      'fear',
      'scared',
      'what if',
      'overthink',
      'racing',
      'restless',
      'uneasy',
    ],
    'stressed': [
      'stress',
      'stressed',
      'pressure',
      'overwhelm',
      'too much',
      'deadline',
      'busy',
      'exhausted',
      'burnout',
      'tense',
      'tired',
      "can't cope",
      'no time',
      "can't sleep",
    ],
    'sad': [
      'sad',
      'down',
      'cry',
      'cried',
      'lonely',
      'alone',
      'empty',
      'hopeless',
      'miss',
      'lost',
      'hurt',
      'depressed',
      'unhappy',
      'heartbroken',
    ],
    'angry': [
      'angry',
      'anger',
      'mad',
      'furious',
      'annoyed',
      'irritated',
      'unfair',
      'hate',
      'frustrated',
      'frustrating',
      'rage',
      'fed up',
    ],
    // 'neutral' has no keywords — it's the fallback.
  };

  static EmotionResult analyze(String text, String selfMood) {
    final lower = text.toLowerCase();
    final scores = <String, int>{for (final k in _keywords.keys) k: 0};

    for (final entry in _keywords.entries) {
      for (final word in entry.value) {
        if (lower.contains(word)) scores[entry.key] = scores[entry.key]! + 1;
      }
    }

    // The mood the user picked gets a strong head start.
    if (scores.containsKey(selfMood)) {
      scores[selfMood] = scores[selfMood]! + 2;
    }

    String top = 'neutral';
    int best = 0;
    scores.forEach((k, v) {
      if (v > best) {
        best = v;
        top = k;
      }
    });
    if (selfMood == 'neutral' && best <= 2) top = 'neutral';

    return _results[top] ?? _results['neutral']!;
  }

  static const Map<String, EmotionResult> _results = {
    'calm': EmotionResult(
      'calm',
      '😌',
      'Goal: Maintain emotional balance.',
      'You sound wonderfully balanced today. Let\'s keep that going.',
      [
        '🌿 Take a 10-minute nature walk.',
        '📖 Write 3 things you\'re grateful for.',
        '🧘 Practice 5 minutes of mindful breathing.',
        '📚 Read a chapter of a favorite book.',
        '🎵 Listen to calming instrumental music.',
      ],
    ),
    'happy': EmotionResult(
      'happy',
      '😊',
      'Goal: Reinforce positive emotions.',
      'There\'s real light in your words today. Savor and share it!',
      [
        '📸 Capture a happy moment with a photo.',
        '💌 Send a kind message to someone you care about.',
        '🎨 Spend 15 minutes on a hobby.',
        '🙏 Write down today\'s best moment.',
        '🌞 Go outside and enjoy some fresh air.',
      ],
    ),
    'neutral': EmotionResult(
      'neutral',
      '😐',
      'Goal: Increase energy and engagement.',
      'A steady day. A small spark of activity could lift it further.',
      [
        '🚶 Take a short 10-minute walk.',
        '🎧 Listen to an uplifting playlist.',
        '📝 Set one small goal for today.',
        '💧 Drink a glass of water and stretch.',
        '🌱 Try a new activity or learn something for 10 minutes.',
      ],
    ),
    'anxious': EmotionResult(
      'anxious',
      '😟',
      'Goal: Reduce anxiety and regain a sense of control.',
      'Some worry showed up in your words. Let\'s slow things down together.',
      [
        '🌬 Practice the 4-4-4 breathing technique.',
        '📝 Write down your worries, then list what you can control.',
        '☕ Take a break from social media for 30 minutes.',
        '🎵 Listen to gentle nature sounds.',
        '🧘 Try a 5-minute guided relaxation session.',
      ],
    ),
    'stressed': EmotionResult(
      'stressed',
      '😫',
      'Goal: Lower stress levels.',
      'It sounds like today carried some pressure. Be gentle with yourself.',
      [
        '🌬 Take 10 slow, deep breaths.',
        '🚶 Go for a 15-minute walk.',
        '💧 Drink water and take a short screen break.',
        '🎵 Listen to relaxing music.',
        '📋 Break one big task into three smaller steps.',
      ],
    ),
    'sad': EmotionResult(
      'sad',
      '😢',
      'Goal: Encourage self-care and connection.',
      'It seems like a heavy day. Your feelings are valid, and they pass.',
      [
        '☀ Spend a few minutes outside in daylight.',
        '📞 Talk to a trusted friend or family member.',
        '❤️ Write down one thing you\'re thankful for.',
        '🎵 Listen to comforting or uplifting music.',
        '🧸 Do one comforting activity — reading, drawing, a favorite show.',
      ],
    ),
    'angry': EmotionResult(
      'angry',
      '😠',
      'Goal: Calm the body before reacting.',
      'Strong feelings came through. Let\'s cool the body down first.',
      [
        '🌬 Take slow deep breaths for 5 minutes.',
        '🚶 Go for a brisk walk.',
        '📝 Write down what made you angry before responding.',
        '💪 Do light exercise or stretching.',
        '🎵 Listen to calming music until you feel more relaxed.',
      ],
    ),
  };
}
