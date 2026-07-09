// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'ai_checkin_screen.dart';

class AssessmentHome extends StatelessWidget {
  const AssessmentHome({super.key});

  // ---- Design tokens (same as HomeScreen) ----
  static const Color pine = Color(0xFF123332);
  static const Color teal = Color(0xFF1C4B47);
  static const Color heroBg = Color(0xFF033A3C);
  static const Color mist = Color(0xFFEDF3EE);
  static const Color mintIcon = Color(0xFFE4F0E9);
  static const Color amber = Color(0xFFF2A65A);
  static const Color amberDeep = Color(0xFFE8842B);
  static const Color muted = Color(0xFF6E8480);

  // ---- Daily rotating wellness tips ----
  // Add as many as you like; one is shown per day automatically.
  static const List<Map<String, String>> _tips = [
    // ---- Mindfulness ----
    {
      'category': 'Mindfulness',
      'title': 'Step outside for 5 minutes',
      'body':
          'A little morning sunlight helps reset your body clock and gently lifts your mood.',
    },
    {
      'category': 'Mindfulness',
      'title': 'Notice 5 things around you',
      'body':
          'Name 5 things you can see, 4 you can hear, 3 you can touch. It brings your mind back to now.',
    },
    {
      'category': 'Mindfulness',
      'title': 'Eat one meal without screens',
      'body':
          'Slowing down to actually taste your food is a small act of calm in a busy day.',
    },
    {
      'category': 'Mindfulness',
      'title': 'Pause before you react',
      'body':
          'When something stresses you, take one slow breath before responding. That tiny gap helps.',
    },
    // ---- Breathing ----
    {
      'category': 'Breathing',
      'title': 'Try the 4-7-8 breath',
      'body':
          'Inhale for 4 seconds, hold for 7, exhale for 8. Two rounds can calm a racing mind.',
    },
    {
      'category': 'Breathing',
      'title': 'Box breathing for focus',
      'body':
          'Breathe in 4, hold 4, out 4, hold 4. Repeat 4 times whenever your thoughts feel scattered.',
    },
    {
      'category': 'Breathing',
      'title': 'Sigh it out',
      'body':
          'Two quick inhales through the nose, one long exhale through the mouth. Repeat 3 times.',
    },
    // ---- Sleep ----
    {
      'category': 'Sleep',
      'title': 'Wind down without screens',
      'body':
          'Putting your phone away 30 minutes before bed helps your brain prepare for deeper sleep.',
    },
    {
      'category': 'Sleep',
      'title': 'Keep a steady wake-up time',
      'body':
          'Waking at the same time daily, even on weekends, makes falling asleep easier at night.',
    },
    {
      'category': 'Sleep',
      'title': 'Cool your room tonight',
      'body':
          'A slightly cooler bedroom helps your body drift into deeper, more restful sleep.',
    },
    {
      'category': 'Sleep',
      'title': 'Park your worries on paper',
      'body':
          'If thoughts keep you awake, write them down for tomorrow. Your mind can let go of what is saved.',
    },
    // ---- Movement ----
    {
      'category': 'Movement',
      'title': 'A short walk counts',
      'body':
          'Even 10 minutes of walking releases tension and gives your mind a gentle reset.',
    },
    {
      'category': 'Movement',
      'title': 'Stretch when you wake up',
      'body':
          'One minute of gentle stretching tells your body the day has started on your terms.',
    },
    {
      'category': 'Movement',
      'title': 'Stand up every hour',
      'body':
          'Long sitting drains energy. A quick stand and stretch keeps your body and mood lighter.',
    },
    {
      'category': 'Movement',
      'title': 'Dance to one song',
      'body':
          'Put on a song you love and move however you like. Three minutes can shift a whole mood.',
    },
    // ---- Gratitude ----
    {
      'category': 'Gratitude',
      'title': 'Name one good thing',
      'body':
          'Before sleeping, think of one thing that went well today, however small.',
    },
    {
      'category': 'Gratitude',
      'title': 'Thank someone today',
      'body':
          'A short thank-you message brightens their day, and quietly lifts yours too.',
    },
    {
      'category': 'Gratitude',
      'title': 'Notice a small comfort',
      'body':
          'Warm tea, soft light, a quiet moment. Naming small comforts trains your mind to find more.',
    },
    // ---- Connection ----
    {
      'category': 'Connection',
      'title': 'Reach out to someone',
      'body':
          'A quick message to a friend or family member can lift both of your days.',
    },
    {
      'category': 'Connection',
      'title': 'Ask someone how they really are',
      'body':
          'Listening fully to someone else is one of the fastest ways to feel connected yourself.',
    },
    {
      'category': 'Connection',
      'title': 'Share something you enjoyed',
      'body':
          'Send a friend a song, photo, or article you liked. Small shares keep bonds warm.',
    },
    // ---- Hydration & Nutrition ----
    {
      'category': 'Hydration',
      'title': 'Drink a glass of water',
      'body':
          'Mild dehydration can affect focus and mood. Keep a bottle within reach today.',
    },
    {
      'category': 'Hydration',
      'title': 'Start your day with water',
      'body':
          'A glass of water before your first coffee or tea helps your body wake up gently.',
    },
    // ---- Rest & Boundaries ----
    {
      'category': 'Rest',
      'title': 'Take a real break',
      'body':
          'A 5-minute break away from your desk restores more focus than pushing through tiredness.',
    },
    {
      'category': 'Rest',
      'title': 'It is okay to say no',
      'body':
          'Protecting your time and energy is not selfish. It is how you stay well for what matters.',
    },
    {
      'category': 'Rest',
      'title': 'Do one thing slowly',
      'body':
          'Pick one small task today and do it without rushing. Slowness is a form of rest.',
    },
    // ---- Self-kindness ----
    {
      'category': 'Kindness',
      'title': 'Talk to yourself like a friend',
      'body':
          'If a friend made your mistake, what would you say to them? Say that to yourself.',
    },
    {
      'category': 'Kindness',
      'title': 'Celebrate a small win',
      'body':
          'Finished something today, even something tiny? That counts. Let yourself feel it.',
    },
    {
      'category': 'Kindness',
      'title': 'Progress over perfection',
      'body':
          'You do not need a perfect day. One small healthy choice already moves you forward.',
    },
    {
      'category': 'Kindness',
      'title': 'Unfollow what drains you',
      'body':
          'Curate your feed like your home. Keep what inspires you, mute what weighs you down.',
    },
  ];

  Map<String, String> get _todaysTip {
    final dayOfYear =
        DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return _tips[dayOfYear % _tips.length];
  }

  void _startCheckIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AICheckInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mist,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Start your check-in',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: pine,
                    ),
                  ),
                  const SizedBox(height: 13),
                  _buildCheckInCard(context),
                  const SizedBox(height: 26),
                  const Text(
                    'Today\u2019s wellness tip',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: pine,
                    ),
                  ),
                  const SizedBox(height: 13),
                  _buildDailyTipCard(),
                  const SizedBox(height: 22),
                  _buildDisclaimer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER — image blended edge-to-edge like the dashboard hero
  // ============================================================
  Widget _buildHeader(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Container(
        width: double.infinity,
        color: heroBg, // same green as the lotus image background
        child: Stack(
          children: [
            // Illustration fills the right side, flush to the edge
            Positioned(
              top: 26,
              right: 12,
              bottom: 22,
              width: 150,
              child: Image.asset(
                'assets/images/hero_meditation.png',
                fit: BoxFit.contain,
                alignment: Alignment.centerRight,
                errorBuilder: (context, error, stack) =>
                    const SizedBox.shrink(),
              ),
            ),
            // Fade so the text side stays clean (same as dashboard hero)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.0, 0.45, 0.60, 0.80],
                    colors: [
                      heroBg,
                      heroBg,
                      heroBg.withOpacity(0.45),
                      heroBg.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 20, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '\u2190',
                            style: TextStyle(
                              color: Color(0xFFEAF4EF),
                              fontSize: 18,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Title + underline (image sits behind, on the right)
                    Padding(
                      padding: const EdgeInsets.only(left: 4, right: 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ASSESSMENT CENTER',
                            style: TextStyle(
                              color: const Color(0xFFA8C5B4),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.6,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Understand your mental wellbeing',
                            style: TextStyle(
                              color: Color(0xFFEAF4EF),
                              fontSize: 22,
                              height: 1.25,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 34,
                            height: 3.5,
                            decoration: BoxDecoration(
                              color: amber,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // AI CHECK-IN CARD
  // ============================================================
  Widget _buildCheckInCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _startCheckIn(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12123332),
              blurRadius: 26,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: mintIcon,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'AI',
                      style: TextStyle(
                        color: teal,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Check-In',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                          color: pine,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Smart mental wellness analysis',
                        style: TextStyle(fontSize: 12.5, color: muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Answer 15 short questions in your own words. Our trained AI model analyzes your responses and predicts your mental wellness stage.',
              style: TextStyle(
                fontSize: 13,
                height: 1.55,
                color: Color(0xFF4E635F),
              ),
            ),
            const SizedBox(height: 16),
            // Meta chips
            Row(
              children: [
                _metaChip('15 questions'),
                const SizedBox(width: 8),
                _metaChip('5–8 mins'),
              ],
            ),
            const SizedBox(height: 18),
            // Start button
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () => _startCheckIn(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: teal,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Start check-in',
                        style: TextStyle(
                          color: Color(0xFFEAF4EF),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '\u2192',
                        style: TextStyle(
                          color: Color(0xFFEAF4EF),
                          fontSize: 15,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: mist,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: amberDeep,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF17322E),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DAILY WELLNESS TIP — rotates automatically each day
  // ============================================================
  Widget _buildDailyTipCard() {
    final tip = _todaysTip;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDFEDE4), Color(0xFFE9F3EB)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: teal,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '\u201C',
                style: TextStyle(
                  color: Color(0xFFEAF4EF),
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: amberDeep.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tip['category']!.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: Color(0xFFB06A1F),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tip['title']!,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: pine,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  tip['body']!,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: Color(0xFF4E635F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DISCLAIMER
  // ============================================================
  Widget _buildDisclaimer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            margin: const EdgeInsets.only(top: 2),
            height: 30,
            decoration: BoxDecoration(
              color: muted.withOpacity(0.45),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'This is an AI-powered screening tool only and not a substitute for professional medical diagnosis.',
              style: TextStyle(
                color: muted.withOpacity(0.95),
                fontSize: 11.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}