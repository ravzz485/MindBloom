import 'package:flutter/material.dart';
import '../../theme/mindbloom_theme.dart';
import '../../services/journal_service.dart';
import '../../services/emotion_engine.dart';
import 'journal_result_screen.dart';

/// Guided journaling — six meaningful questions. Answer one or all.
/// Answers are saved as ONE combined entry with category headings.
class GuidedJournalScreen extends StatefulWidget {
  final String userId;
  const GuidedJournalScreen({super.key, required this.userId});

  @override
  State<GuidedJournalScreen> createState() => _GuidedJournalScreenState();
}

class _GuidedJournalScreenState extends State<GuidedJournalScreen> {
  static const List<(String, String, String)> _categories = [
    ('🧠', 'Stress Relief', "What's been on your mind today?"),
    ('🙏', 'Gratitude', 'List 3 things you are grateful for today.'),
    ('🪞', 'Reflection', 'What challenged you today?'),
    ('💚', 'Self Care', "What's one thing you did for yourself today?"),
    ('🌞', 'Positive Thinking', 'What made you smile today?'),
    ('🍃', 'Letting Go', "What's something you want to release today?"),
  ];

  final Map<int, TextEditingController> _controllers = {};
  String _mood = 'neutral';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _categories.length; i++) {
      _controllers[i] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    // Combine answered questions into one entry with headings.
    final parts = <String>[];
    for (int i = 0; i < _categories.length; i++) {
      final text = _controllers[i]!.text.trim();
      if (text.isNotEmpty) {
        parts.add('${_categories[i].$1} ${_categories[i].$2}\n$text');
      }
    }
    if (parts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Answer at least one question first 🌱')),
      );
      return;
    }

    setState(() => _saving = true);
    final ok = await JournalService.saveEntry(
      userId: widget.userId,
      entry: parts.join('\n\n'),
      mood: _mood,
      prompt: 'guided',
    );
    setState(() => _saving = false);

    if (!mounted) return;
    if (ok) {
      final result = EmotionEngine.analyze(parts.join('\n\n'), _mood);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => JournalResultScreen(result: result)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not reach the server — is it running? Not saved.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MBColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: MBColors.darkGreen,
                    ),
                  ),
                  const Text(
                    'Guided journaling',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: MBColors.darkGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Answer one question, or all of them — whatever helps today.',
                style: TextStyle(
                  fontSize: 14,
                  color: MBColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),

              _moodRow(),
              const SizedBox(height: 16),

              for (int i = 0; i < _categories.length; i++) ...[
                _questionCard(i),
                const SizedBox(height: 14),
              ],

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MBColors.darkGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.check_rounded),
                  label: Text(
                    _saving ? 'Saving...' : 'Save entry',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _moodRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How are you feeling?',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: MBColors.darkGreen,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: kMoods.map((m) {
            final selected = _mood == m.$2;
            return GestureDetector(
              onTap: () => setState(() => _mood = m.$2),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? MBColors.meditationTile : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? MBColors.meditationIcon
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  '${m.$1} ${m.$2}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: MBColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _questionCard(int i) {
    final c = _categories[i];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MBColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${c.$1} ${c.$2}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: MBColors.darkGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            c.$3,
            style: const TextStyle(
              fontSize: 13.5,
              color: MBColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controllers[i],
            maxLines: 3,
            minLines: 1,
            style: const TextStyle(color: MBColors.textPrimary, height: 1.5),
            decoration: InputDecoration(
              hintText: 'Write here (optional)...',
              hintStyle: const TextStyle(
                color: MBColors.textSecondary,
                fontSize: 13.5,
              ),
              filled: true,
              fillColor: MBColors.background,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
