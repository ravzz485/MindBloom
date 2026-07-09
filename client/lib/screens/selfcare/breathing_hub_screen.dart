import 'package:flutter/material.dart';
import '../../data/breathing_exercises.dart';
import '../../theme/mindbloom_theme.dart';
import 'breathing_session_screen.dart';

/// Breathing hub — the 6 exercises grouped into their 3 categories.
class BreathingHubScreen extends StatelessWidget {
  const BreathingHubScreen({super.key});

  void _showDetail(BuildContext context, BreathingExercise ex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MBColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: ex.tileColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(ex.icon, color: ex.iconColor, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    ex.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: MBColors.darkGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              ex.description,
              style: const TextStyle(
                fontSize: 14.5,
                color: MBColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.eco_rounded, size: 18, color: ex.iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ex.benefit,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: ex.iconColor,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            if (ex.safetyNote != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MBColors.journalTile,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        size: 18, color: MBColors.journalIcon),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ex.safetyNote!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: MBColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              ex.isCycleBased ? 'How many cycles?' : 'How long?',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: MBColors.darkGreen,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: ex.isCycleBased
                  ? ex.cycleOptions
                      .map((c) => _optionButton(ctx, ex, cycles: c))
                      .toList()
                  : ex.minuteOptions
                      .map((m) => _optionButton(ctx, ex, minutes: m))
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionButton(BuildContext ctx, BreathingExercise ex,
      {int? minutes, int? cycles}) {
    final label = minutes != null ? '$minutes min' : '$cycles cycles';
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
            Navigator.push(
              ctx,
              MaterialPageRoute(
                builder: (_) => BreathingSessionScreen(
                  exercise: ex,
                  minutes: minutes,
                  cycles: cycles,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: MBColors.darkGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Column(
            children: [
              const Icon(Icons.timer_outlined, size: 22),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group exercises by category, preserving order.
    final categories = <String, List<BreathingExercise>>{};
    for (final ex in breathingExercises) {
      categories.putIfAbsent(ex.category, () => []).add(ex);
    }

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
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: MBColors.darkGreen),
                  ),
                  const Icon(Icons.local_florist_rounded,
                      color: MBColors.darkGreen, size: 22),
                  const SizedBox(width: 6),
                  const Text(
                    'Mind Bloom',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: MBColors.darkGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Breathing exercises',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: MBColors.darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Switch off fight-or-flight and turn on rest-and-digest. '
                'Follow the circle: it grows as you breathe in, shrinks as you breathe out.',
                style: TextStyle(
                    fontSize: 15, color: MBColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 24),
              for (final entry in categories.entries) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12, top: 4),
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: MBColors.darkGreen,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                ...entry.value.map(
                  (ex) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _ExerciseCard(
                      exercise: ex,
                      onTap: () => _showDetail(context, ex),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final BreathingExercise exercise;
  final VoidCallback onTap;

  const _ExerciseCard({required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final durationText = exercise.isCycleBased
        ? exercise.cycleOptions.map((c) => '$c cycles').join(' · ')
        : exercise.minuteOptions.map((m) => '$m min').join(' · ');

    return Material(
      color: MBColors.card,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: exercise.tileColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(exercise.icon, size: 36, color: exercise.iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: MBColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exercise.tagline,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: MBColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined,
                            size: 15, color: MBColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          durationText,
                          style: const TextStyle(
                              fontSize: 12.5, color: MBColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: MBColors.darkGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}