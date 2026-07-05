// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/login_screen.dart';
import '../assessment/assessment_home.dart';
import '../checkin/daily_checkin_screen.dart';
import '../progress/progress_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // ---- Design tokens (from the new UI) ----
  static const Color pine = Color(0xFF123332);
  static const Color teal = Color(0xFF1C4B47);
  static const Color heroBg = Color(0xFF033A3C); // matches hero image bg
  static const Color mist = Color(0xFFEDF3EE);
  static const Color mintIcon = Color(0xFFE4F0E9);
  static const Color amber = Color(0xFFF2A65A);
  static const Color amberDeep = Color(0xFFE8842B);
  static const Color muted = Color(0xFF6E8480);

  String userName = '';
  Map<String, dynamic>? latestAssessment;
  bool loadingRecent = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadLatestAssessment();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'User';
    });
  }

  Future<void> loadLatestAssessment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/assessment/latest'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          latestAssessment = data['assessment'];
          loadingRecent = false;
        });
      } else {
        setState(() => loadingRecent = false);
      }
    } catch (e) {
      setState(() => loadingRecent = false);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mist,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadLatestAssessment,
          color: teal,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildHeroCard(),
                const SizedBox(height: 26),
                _sectionTitle('Quick actions'),
                const SizedBox(height: 13),
                _buildQuickActionsRow(),
                const SizedBox(height: 26),
                _buildRecentHeader(),
                const SizedBox(height: 13),
                _buildRecentCard(),
                const SizedBox(height: 26),
                _buildWellnessTip(),
                const SizedBox(height: 18),
                _buildDisclaimer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER  (no emoji)
  // ============================================================
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $userName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: pine,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'How are you feeling today?',
              style: TextStyle(fontSize: 13, color: muted),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [teal, Color(0xFF2E6560)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14123332),
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Color(0xFFEAF4EF),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: logout,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: teal,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // HERO: quote card + image on the right
  //
  // Add your uploaded illustration to the project:
  //   1. Save it as  assets/images/hero_meditation.png
  //   2. In pubspec.yaml:
  //        flutter:
  //          assets:
  //            - assets/images/hero_meditation.png
  // ============================================================
  Widget _buildHeroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 168),
        color: heroBg,
        child: Stack(
          children: [
            // Illustration fills the right side
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              width: 230,
              child: Image.asset(
                'assets/images/hero_meditation.png',
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
                errorBuilder: (context, error, stack) =>
                    const SizedBox.shrink(),
              ),
            ),
            // Fade so text stays readable
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.0, 0.36, 0.60, 0.82],
                    colors: [
                      heroBg,
                      heroBg,
                      heroBg.withOpacity(0.55),
                      heroBg.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Quote + CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 140, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '“Small steps every day\nlead to big changes.”',
                    style: TextStyle(
                      color: Color(0xFFEAF4EF),
                      fontSize: 18,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 34,
                    height: 3.5,
                    decoration: BoxDecoration(
                      color: amber,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DailyCheckInScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.35),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Check in now',
                            style: TextStyle(
                              color: Color(0xFFEAF4EF),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: Color(0xFFEAF4EF),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // QUICK ACTIONS — single row, no scrolling
  // Assessment | Insights | Daily analytics | My progress
  // ============================================================
  Widget _buildQuickActionsRow() {
    return Row(
      children: [
        Expanded(
          child: _actionTile(
            icon: Icons.assignment_turned_in_outlined,
            title: 'Assessment',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AssessmentHome(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _actionTile(
            icon: Icons.auto_awesome_outlined,
            title: 'Insights',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProgressScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _actionTile(
            icon: Icons.bar_chart_rounded,
            title: 'Daily\nanalytics',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DailyCheckInScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _actionTile(
            icon: Icons.flag_outlined,
            title: 'My\nprogress',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProgressScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F123332),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: mintIcon,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: teal, size: 22),
            ),
            const SizedBox(height: 9),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 10.5,
                height: 1.25,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17322E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // RECENT ACTIVITY (last assessment / daily check-in)
  // ============================================================
  Widget _buildRecentHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _sectionTitle('Recent activity'),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProgressScreen()),
            );
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View all',
                style: TextStyle(
                  fontSize: 13,
                  color: teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward_rounded, size: 14, color: teal),
            ],
          ),
        ),
      ],
    );
  }

  /// Max score used for the progress ring, based on assessment type.
  double _maxScoreFor(String type) {
    final t = type.toLowerCase();
    if (t.contains('phq')) return 27; // PHQ-9
    if (t.contains('gad')) return 21; // GAD-7
    return 27; // sensible default
  }

  Widget _buildRecentCard() {
    if (loadingRecent) {
      return _whiteCard(
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: teal),
          ),
        ),
      );
    }

    if (latestAssessment == null) {
      return _whiteCard(
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: mintIcon,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_outlined,
                color: teal,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'No activity yet. Start your first check-in.',
                style: TextStyle(fontSize: 13, color: muted),
              ),
            ),
          ],
        ),
      );
    }

    final riskLevel = (latestAssessment!['riskLevel'] ?? 'unknown').toString();
    final type = (latestAssessment!['type'] ?? 'Assessment').toString();
    final score = latestAssessment!['score'];
    final createdAt = latestAssessment!['createdAt'];

    String formattedDate = '';
    if (createdAt != null) {
      final date = DateTime.tryParse(createdAt.toString());
      if (date != null) {
        formattedDate = '${date.day}/${date.month}/${date.year}';
      }
    }

    Color riskColor = teal;
    switch (riskLevel.toLowerCase()) {
      case 'severe':
        riskColor = const Color(0xFFD85A30);
        break;
      case 'moderate':
        riskColor = amberDeep;
        break;
      case 'mild':
        riskColor = const Color(0xFF639922);
        break;
      case 'minimal':
      case 'low':
        riskColor = const Color(0xFF0F6E56);
        break;
    }

    final maxScore = _maxScoreFor(type);
    final double? ringValue = score is num
        ? (score / maxScore).clamp(0.0, 1.0).toDouble()
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProgressScreen()),
        );
      },
      child: _whiteCard(
        child: Row(
          children: [
            // Score ring
            SizedBox(
              width: 62,
              height: 62,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: ringValue ?? 1.0,
                    strokeWidth: 6,
                    color: riskColor,
                    backgroundColor: riskColor.withOpacity(0.14),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          score != null ? '$score' : '—',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            height: 1,
                            color: riskColor,
                          ),
                        ),
                        if (score != null)
                          Text(
                            '/${maxScore.toInt()}',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$type assessment',
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17322E),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      riskLevel[0].toUpperCase() + riskLevel.substring(1),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: riskColor,
                      ),
                    ),
                  ),
                  if (formattedDate.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 11,
                          color: muted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 11.5, color: muted),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: muted, size: 22),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // WELLNESS TIP
  // ============================================================
  Widget _buildWellnessTip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Wellness tip'),
        const SizedBox(height: 13),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFDFEDE4), Color(0xFFE9F3EB)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: teal,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.format_quote_rounded,
                  color: Color(0xFFEAF4EF),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Take a deep breath.\n',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: 'You\u2019ve got this. One moment at a time.',
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: Color(0xFF17322E),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
          const Icon(Icons.info_outline_rounded, color: muted, size: 15),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'This app is not a substitute for professional medical advice.',
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

  // ============================================================
  // Shared helpers
  // ============================================================
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: pine,
      ),
    );
  }

  Widget _whiteCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F123332),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}