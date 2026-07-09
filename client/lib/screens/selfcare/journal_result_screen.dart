import 'package:flutter/material.dart';
import '../../theme/mindbloom_theme.dart';
import '../../services/emotion_engine.dart';
import 'meditation_hub_screen.dart';
import 'breathing_hub_screen.dart';
import 'relaxing_audio_screen.dart';
import 'mindfeed_screen.dart';

/// Shown after saving a journal entry: detected emotion,
/// personalized recommendations, and "what next" actions.
class JournalResultScreen extends StatelessWidget {
  final EmotionResult result;
  const JournalResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MBColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: MBColors.meditationIcon,
                    size: 26,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Entry saved',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: MBColors.darkGreen,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () =>
                        Navigator.popUntil(context, (r) => r.isFirst),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: MBColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Detected emotion card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: MBColors.card,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${result.emoji}  How you're doing",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: MBColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result.message,
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: MBColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Based on today's journal, I recommend:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: MBColors.darkGreen,
                ),
              ),
              const SizedBox(height: 10),

              // Handwritten note card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDFBF4), // soft paper
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8E2D0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.eco_rounded,
                          color: MBColors.meditationIcon,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            result.goal,
                            style: const TextStyle(
                              fontFamily: 'Caveat',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: MBColors.darkGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFFE8E2D0), height: 20),
                    ...result.tips.map(
                      (t) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          t,
                          style: const TextStyle(
                            fontFamily: 'Caveat',
                            fontSize: 21,
                            height: 1.25,
                            color: Color(0xFF3D4A42),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'What would you like to do next?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: MBColors.darkGreen,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _nextButton(
                    context,
                    '🧘',
                    'Start\nMeditation',
                    () => _go(context, const MeditationHubScreen()),
                  ),
                  const SizedBox(width: 10),
                  _nextButton(
                    context,
                    '🌬',
                    'Breathing\nExercise',
                    () => _go(context, const BreathingHubScreen()),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _nextButton(
                    context,
                    '🎵',
                    'Relaxing\nSounds',
                    () => _go(context, const RelaxingAudioScreen()),
                  ),
                  const SizedBox(width: 10),
                  _nextButton(
                    context,
                    '😊',
                    'Positive\nMemories',
                    () => _go(context, const MindFeedScreen(initialTab: 0)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.popUntil(context, (r) => r.isFirst),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: MBColors.darkGreen,
                    side: const BorderSide(color: MBColors.darkGreen),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text(
                    'Back home',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _go(BuildContext context, Widget screen) {
    Navigator.popUntil(context, (r) => r.isFirst);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _nextButton(
    BuildContext context,
    String emoji,
    String label,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: Material(
        color: MBColors.darkGreen,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
