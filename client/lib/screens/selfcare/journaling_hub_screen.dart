import 'package:flutter/material.dart';
import '../../theme/mindbloom_theme.dart';
import 'guided_journal_screen.dart';
import 'free_journal_screen.dart';
//import 'journal_entries_screen.dart';
import 'voice_journal_screen.dart';
import 'pin_lock_screen.dart';

/// Journaling hub — three ways to journal + link to past entries.
class JournalingHubScreen extends StatelessWidget {
  final String userId;
  const JournalingHubScreen({super.key, required this.userId});

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
                'Journaling',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: MBColors.darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Release your thoughts. Choose the way that feels right today.',
                style: TextStyle(
                  fontSize: 15,
                  color: MBColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              _ModeCard(
                title: 'Guided journaling',
                subtitle: 'Meaningful questions to gently guide you.',
                icon: Icons.tips_and_updates_rounded,
                tileColor: MBColors.journalTile,
                iconColor: MBColors.journalIcon,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GuidedJournalScreen(userId: userId),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _ModeCard(
                title: 'Free writing',
                subtitle: 'A blank page — write whatever flows.',
                icon: Icons.edit_note_rounded,
                tileColor: MBColors.meditationTile,
                iconColor: MBColors.meditationIcon,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FreeJournalScreen(userId: userId),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _ModeCard(
                title: 'Voice journal',
                subtitle: 'Speak your thoughts, we write them down.',
                icon: Icons.mic_rounded,
                tileColor: MBColors.audioTile,
                iconColor: MBColors.audioIcon,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VoiceJournalScreen(userId: userId),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Past entries link
              Material(
                color: MBColors.darkGreen,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PinLockScreen(userId: userId),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'My entries',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
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

class _ModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color tileColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tileColor,
    required this.iconColor,
    required this.onTap,
  });

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
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, size: 34, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
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
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: MBColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
