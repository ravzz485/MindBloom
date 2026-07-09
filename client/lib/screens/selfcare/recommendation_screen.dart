import 'package:flutter/material.dart';
import '../../theme/mindbloom_theme.dart';
import 'meditation_hub_screen.dart';
import 'breathing_hub_screen.dart';
import 'journaling_hub_screen.dart';
import 'relaxing_audio_screen.dart';
import 'mindfeed_screen.dart';

class RecommendationScreen extends StatefulWidget {
  final String userId;
  final String riskLevel;

  const RecommendationScreen({
    super.key,
    this.userId = '',
    this.riskLevel = 'moderate',
  });

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  int _navIndex = 2; // "Insights" selected, as in the mockup

  void _open(Widget? screen, String name) {
    if (screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hook this card to your $name screen')),
      );
    }
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
              _topBar(),
              const SizedBox(height: 20),
              _header(),
              const SizedBox(height: 24),

              _RecommendationCard(
                title: 'Meditation',
                subtitle: 'Find your center with a guided session.',
                icon: Icons.self_improvement_rounded,
                tileColor: MBColors.meditationTile,
                iconColor: MBColors.meditationIcon,
                buttonIcon: Icons.play_arrow_rounded,
                onStart: () => _open(const MeditationHubScreen(), 'Meditation'),
              ),
              const SizedBox(height: 16),

              _RecommendationCard(
                title: 'Breathing exercises',
                subtitle: 'Calm your nervous system instantly.',
                icon: Icons.air_rounded,
                tileColor: MBColors.breathingTile,
                iconColor: MBColors.breathingIcon,
                buttonIcon: Icons.play_arrow_rounded,
                onStart: () => _open(const BreathingHubScreen(), 'Breathing'),
              ),
              const SizedBox(height: 16),

              _RecommendationCard(
                title: 'Journaling',
                subtitle: 'Release your thoughts onto the page.',
                icon: Icons.menu_book_rounded,
                tileColor: MBColors.journalTile,
                iconColor: MBColors.journalIcon,
                buttonIcon: Icons.edit_rounded,
                onStart: () => _open(
                  JournalingHubScreen(userId: widget.userId),
                  'Journal',
                ),
              ),
              const SizedBox(height: 16),

              _RecommendationCard(
                title: 'Relaxing audio',
                subtitle: 'Drift away with soothing soundscapes.',
                icon: Icons.headphones_rounded,
                tileColor: MBColors.audioTile,
                iconColor: MBColors.audioIcon,
                buttonIcon: Icons.volume_up_rounded,
                onStart: () =>
                    _open(const RelaxingAudioScreen(), 'Relaxing audio'),
              ),
              const SizedBox(height: 16),

              // ── MindFeed card, right after Relaxing audio ──
              _RecommendationCard(
                title: 'MindFeed',
                subtitle: 'Fresh mental wellness reads and tips.',
                icon: Icons.auto_awesome_mosaic_rounded,
                tileColor: MBColors.mindfeedTile,
                iconColor: MBColors.mindfeedIcon,
                buttonIcon: Icons.arrow_forward_rounded,
                buttonLabel: 'Open',
                onStart: () => _open(const MindFeedScreen(), 'MindFeed'),
              ),
              const SizedBox(height: 20),

              _weeklyProgressCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  // ── App bar row: logo + profile ──────────────────────────────────
  Widget _topBar() {
    return Row(
      children: [
        const Icon(
          Icons.local_florist_rounded,
          color: MBColors.darkGreen,
          size: 26,
        ),
        const SizedBox(width: 8),
        const Text(
          'Mind Bloom',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: MBColors.darkGreen,
          ),
        ),
        const Spacer(),
        CircleAvatar(
          radius: 22,
          backgroundColor: MBColors.darkGreen,
          child: const Icon(Icons.person, color: Colors.white),
        ),
      ],
    );
  }

  // ── Header: title + hero illustration ────────────────────────────
  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Recommended\nfor You',
                style: TextStyle(
                  fontSize: 34,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                  color: MBColors.darkGreen,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Personalized actions to help you find balance today.',
                style: TextStyle(
                  fontSize: 15,
                  color: MBColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 4,
          child: Image.asset(
            'assets/images/meditation_hero.png',
            height: 170,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              height: 150,
              decoration: BoxDecoration(
                color: MBColors.meditationTile,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.self_improvement_rounded,
                size: 72,
                color: MBColors.meditationIcon,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Weekly progress card ─────────────────────────────────────────
  Widget _weeklyProgressCard() {
    const progress = 0.75; // TODO(team): compute from completed sessions
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MBColors.card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Weekly Progress',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: MBColors.darkGreen,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "You're doing great! You've completed 4 sessions this week.",
                  style: TextStyle(
                    fontSize: 14,
                    color: MBColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 92,
            height: 92,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round,
                  color: MBColors.darkGreen,
                  backgroundColor: MBColors.background,
                ),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: MBColors.darkGreen,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '75%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Dark green bottom navigation ─────────────────────────────────
  Widget _bottomNav() {
    final items = [
      (Icons.home_outlined, 'Home'),
      (Icons.book_outlined, 'Journal'),
      (Icons.auto_awesome_outlined, 'Insights'),
      (Icons.person_outline_rounded, 'Profile'),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: MBColors.darkGreen,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final selected = i == _navIndex;
          return GestureDetector(
            onTap: () => setState(() => _navIndex = i),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? MBColors.deepGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(items[i].$1, color: Colors.white, size: 24),
                  const SizedBox(height: 2),
                  Text(
                    items[i].$2,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Reusable recommendation card (matches the mockup card) ─────────
class _RecommendationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color tileColor;
  final Color iconColor;
  final IconData buttonIcon;
  final String buttonLabel;
  final VoidCallback onStart;

  const _RecommendationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tileColor,
    required this.iconColor,
    required this.buttonIcon,
    required this.onStart,
    this.buttonLabel = 'Start',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MBColors.card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, size: 38, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: MBColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: MBColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: MBColors.darkGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            icon: Text(
              buttonLabel,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            label: Icon(buttonIcon, size: 20),
          ),
        ],
      ),
    );
  }
}
