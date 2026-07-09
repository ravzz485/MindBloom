import 'package:flutter/material.dart';
import '../../theme/mindbloom_theme.dart';
import '../../services/journal_service.dart';
import '../../services/emotion_engine.dart';
import 'journal_result_screen.dart';

/// Free writing — a clean open page with today's date.
class FreeJournalScreen extends StatefulWidget {
  final String userId;
  const FreeJournalScreen({super.key, required this.userId});

  @override
  State<FreeJournalScreen> createState() => _FreeJournalScreenState();
}

class _FreeJournalScreenState extends State<FreeJournalScreen> {
  final TextEditingController _controller = TextEditingController();
  String _mood = 'neutral';
  bool _saving = false;

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String get _todayLabel {
    final now = DateTime.now();
    return '${_weekdays[now.weekday - 1]}, ${_months[now.month - 1]} ${now.day}';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Write something first 🌱')));
      return;
    }
    setState(() => _saving = true);
    final ok = await JournalService.saveEntry(
      userId: widget.userId,
      entry: text,
      mood: _mood,
      prompt: 'free',
    );
    setState(() => _saving = false);
    if (!mounted) return;
    if (ok) {
      final result = EmotionEngine.analyze(text, _mood);
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
                    "Today's journal",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: MBColors.darkGreen,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48),
                child: Text(
                  _todayLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    color: MBColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),

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
                        color: selected
                            ? MBColors.meditationTile
                            : Colors.white,
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
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: 14,
                  style: const TextStyle(
                    color: MBColors.textPrimary,
                    height: 1.6,
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    hintText:
                        'Write your thoughts... no one is judging here 🌱',
                    hintStyle: TextStyle(color: MBColors.textSecondary),
                    contentPadding: EdgeInsets.all(18),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

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
}
