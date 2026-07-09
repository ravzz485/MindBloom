import 'package:flutter/material.dart';
import '../../data/meditation_methods.dart';
import '../../theme/mindbloom_theme.dart';
import 'meditation_session_screen.dart';

/// Meditation hub — all 6 methods in the same card language as the
/// "Recommended for You" screen. Tapping a card opens a bottom sheet
/// where the user chooses a 5 or 10 minute session.
class MeditationHubScreen extends StatelessWidget {
  const MeditationHubScreen({super.key});

  void _chooseDuration(BuildContext context, MeditationMethod method) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MBColors.card,
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
                    color: method.tileColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(method.icon, color: method.iconColor, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    method.name,
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
              method.description,
              style: const TextStyle(
                fontSize: 14.5,
                color: MBColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Choose your session length',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: MBColors.darkGreen,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _durationButton(ctx, method, 5),
                const SizedBox(width: 12),
                _durationButton(ctx, method, 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _durationButton(
    BuildContext ctx,
    MeditationMethod method,
    int minutes,
  ) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(ctx); // close sheet
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (_) => MeditationSessionScreen(
                method: method,
                durationMinutes: minutes,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MBColors.darkGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.timer_outlined, size: 22),
            const SizedBox(height: 4),
            Text(
              '$minutes minutes',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

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
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: MBColors.darkGreen,
                    ),
                  ),
                  const Icon(
                    Icons.local_florist_rounded,
                    color: MBColors.darkGreen,
                    size: 22,
                  ),
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
                'Meditation',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: MBColors.darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Six guided methods. Pick one, choose 5 or 10 minutes, and press start.',
                style: TextStyle(
                  fontSize: 15,
                  color: MBColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ...meditationMethods.map(
                (m) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _MethodCard(
                    method: m,
                    onTap: () => _chooseDuration(context, m),
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

class _MethodCard extends StatelessWidget {
  final MeditationMethod method;
  final VoidCallback onTap;

  const _MethodCard({required this.method, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                  color: method.tileColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(method.icon, size: 36, color: method.iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: MBColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      method.tagline,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: MBColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: const [
                        Icon(
                          Icons.timer_outlined,
                          size: 15,
                          color: MBColors.textSecondary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '5 min · 10 min',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: MBColors.textSecondary,
                          ),
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
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
