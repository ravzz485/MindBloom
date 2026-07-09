// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ml_result_screen.dart';

class AICheckInScreen extends StatefulWidget {
  const AICheckInScreen({super.key});

  @override
  State<AICheckInScreen> createState() => _AICheckInScreenState();
}

class _AICheckInScreenState extends State<AICheckInScreen>
    with TickerProviderStateMixin {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // ---- Deep ocean palette (derived from brand #033A3C) ----
  static const Color oceanDark = Color(0xFF02282E);
  static const Color oceanMid = Color(0xFF043A45);
  static const Color oceanLight = Color(0xFF0A4D52);
  static const Color mistBlue = Color(0xFF7EC7D9);
  static const Color mistBlueSoft = Color(0xFF9FD4E2);
  static const Color textLight = Color(0xFFF2FAF5);

  final List<String> questions = [
    'How have you been feeling emotionally over the past 2 weeks?',
    'Have you found it hard to enjoy things you normally like?',
    'How has your sleep and energy been lately?',
    'Have you noticed any changes in your appetite or how you feel about yourself?',
    'Have you had trouble focusing or concentrating?',
    'Do you ever feel restless, on edge, or physically anxious? Tell me about it.',
    'What has been causing you the most stress or worry lately?',
    'How connected do you feel to the people around you?',
    'Have you had any thoughts that scare or worry you?',
    'Is there anything else you would like to share about how you are doing?'
  ];

  // Index of the sensitive question (0-based) — triggers a safety check
  static const int sensitiveQuestionIndex = 8;

  // Basic crisis keyword flags — kept minimal and non-exhaustive on purpose
  final List<String> crisisKeywords = [
    'suicide',
    'kill myself',
    'end my life',
    'not want to live',
    'want to die',
    'hurt myself',
    'self harm',
    'self-harm',
    'no reason to live',
  ];

  late List<TextEditingController> controllers;
  late final AnimationController _breath; // lotus glow + star twinkle
  late final AnimationController _ripple; // expanding water rings
  int currentQuestion = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      questions.length,
      (index) => TextEditingController(),
    );
    _breath = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _ripple = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    _breath.dispose();
    _ripple.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // Safety check (unchanged logic)
  // ------------------------------------------------------------
  bool _containsCrisisLanguage(String text) {
    final lower = text.toLowerCase();
    return crisisKeywords.any((word) => lower.contains(word));
  }

  Future<void> _showSafetyDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.red),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'You are not alone',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
        content: const Text(
          'It sounds like you might be going through something really difficult right now. '
          'Please consider reaching out to a mental health professional or a crisis helpline — '
          'you deserve support, and help is available.\n\n'
          'If you are in immediate danger, please contact your local emergency services right away.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Continue',
              style: TextStyle(color: oceanMid),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Navigation between questions (unchanged logic)
  // ------------------------------------------------------------
  Future<void> _goToNextOrSubmit() async {
    // Run safety check right after the sensitive question is answered
    if (currentQuestion == sensitiveQuestionIndex) {
      final answer = controllers[sensitiveQuestionIndex].text;
      if (_containsCrisisLanguage(answer)) {
        await _showSafetyDialog();
      }
    }

    if (currentQuestion < questions.length - 1) {
      FocusScope.of(context).unfocus();
      setState(() {
        currentQuestion++;
      });
    } else {
      submitCheckIn();
    }
  }

  void _goToPrevious() {
    if (currentQuestion > 0) {
      FocusScope.of(context).unfocus();
      setState(() {
        currentQuestion--;
      });
    }
  }

  // ------------------------------------------------------------
  // Submit to ML API (unchanged logic)
  // ------------------------------------------------------------
  Future<void> submitCheckIn() async {
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      // Combine all answers into one paragraph
      final combinedText = controllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .join('. ');

      final response = await http.post(
        Uri.parse('$baseUrl/assessment/ml-analyze'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'text': combinedText}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MLResultScreen(
                mlPrediction: data['mlPrediction'] ?? 'unknown',
                mlConfidence: (data['mlConfidence'] ?? 0).toDouble(),
                detectedIssue: data['detectedIssue'] ?? 'general',
                riskLevel: data['riskLevel'] ?? 'low',
                disclaimer:
                    data['disclaimer'] ?? 'This is not a medical diagnosis.',
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Error: ${data['message'] ?? 'Something went wrong'}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => isLoading = false);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  bool get _isLast => currentQuestion == questions.length - 1;

  String get _stageWord {
    if (_isLast) return 'LAST QUESTION';
    if (currentQuestion >= 7) return 'ALMOST THERE';
    if (currentQuestion >= 3) return 'GOING DEEPER';
    return 'LET\u2019S BEGIN';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [oceanDark, oceanMid, oceanLight],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            _decorativeRings(),
            _lotusHeader(),
            SafeArea(
              child: Column(
                children: [
                  _topBar(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(30, 128, 30, 10),
                      child: _questionArea(),
                    ),
                  ),
                  _bottomArea(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Faint concentric arcs behind the lotus
  Widget _decorativeRings() {
    Widget ring(double size, double opacity) {
      return Positioned(
        top: -size * 0.42,
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(opacity),
                width: 1.5,
              ),
            ),
          ),
        ),
      );
    }

    return Stack(children: [ring(340, 0.09), ring(480, 0.05)]);
  }

  // ------------------------------------------------------------
  // Lotus floating on rippling water + twinkling stars
  // ------------------------------------------------------------
  Widget _lotusHeader() {
    Widget star(double size, double top, double? left, double? right,
        double baseOpacity) {
      return Positioned(
        top: top,
        left: left,
        right: right,
        child: FadeTransition(
          opacity: Tween(begin: baseOpacity * 0.4, end: baseOpacity).animate(
            CurvedAnimation(parent: _breath, curve: Curves.easeInOut),
          ),
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEAF6FA),
            ),
          ),
        ),
      );
    }

    return Positioned(
      top: 48,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 150,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Soft glow behind the scene
            Positioned(
              top: 0,
              child: Container(
                width: 170,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: mistBlueSoft.withOpacity(0.22),
                      blurRadius: 60,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
            // Expanding water ripples
            Positioned(
              top: 58,
              child: AnimatedBuilder(
                animation: _ripple,
                builder: (context, _) => CustomPaint(
                  size: const Size(300, 90),
                  painter: _RipplePainter(progress: _ripple.value),
                ),
              ),
            ),
            // The lotus (gently breathing)
            Positioned(
              top: 8,
              child: ScaleTransition(
                scale: Tween(begin: 0.97, end: 1.03).animate(
                  CurvedAnimation(parent: _breath, curve: Curves.easeInOut),
                ),
                child: CustomPaint(
                  size: const Size(110, 72),
                  painter: _LotusPainter(),
                ),
              ),
            ),
            // Stars
            star(2.5, 10, 106, null, 0.85),
            star(2.0, 66, 66, null, 0.5),
            star(2.0, 18, null, 100, 0.65),
            star(1.6, 76, null, 78, 0.45),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // Top bar
  // ------------------------------------------------------------
  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.18)),
              ),
              child: const Center(
                child: Text(
                  '\u2190',
                  style: TextStyle(color: textLight, fontSize: 16, height: 1),
                ),
              ),
            ),
          ),
          Text(
            '${currentQuestion + 1} of ${questions.length}',
            style: TextStyle(
              color: textLight.withOpacity(0.7),
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Question + glass answer box (animated between questions)
  // ------------------------------------------------------------
  Widget _questionArea() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 380),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) {
        return FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.06, 0),
              end: Offset.zero,
            ).animate(anim),
            child: child,
          ),
        );
      },
      child: Column(
        key: ValueKey(currentQuestion),
        children: [
          Text(
            _stageWord,
            style: const TextStyle(
              color: mistBlueSoft,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            questions[currentQuestion],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'serif',
              color: textLight,
              fontSize: 24,
              height: 1.42,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 26),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(0.20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: TextField(
              controller: controllers[currentQuestion],
              minLines: 4,
              maxLines: 7,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                color: textLight,
                fontSize: 14.5,
                height: 1.6,
              ),
              cursorColor: mistBlue,
              decoration: InputDecoration(
                // Override any global theme fill (prevents white-on-white)
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Type your answer here...',
                hintStyle: TextStyle(
                  color: textLight.withOpacity(0.5),
                  fontSize: 14.5,
                ),
                contentPadding: const EdgeInsets.all(18),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'There are no wrong answers.',
            style: TextStyle(
              color: textLight.withOpacity(0.55),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Bottom: dots + Continue + Previous
  // ------------------------------------------------------------
  Widget _bottomArea() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 6, 26, 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(questions.length, (i) {
              final isCurrent = i == currentQuestion;
              final isDone = i < currentQuestion;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 3.5),
                width: isCurrent ? 24 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isCurrent || isDone
                      ? mistBlue
                      : Colors.white.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: isLoading ? null : _goToNextOrSubmit,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: textLight,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 34,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: oceanMid,
                        ),
                      )
                    : Text(
                        _isLast
                            ? 'Analyze my answers  \u2192'
                            : 'Continue  \u2192',
                        style: const TextStyle(
                          color: oceanDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: 0.2,
                        ),
                      ),
              ),
            ),
          ),
          if (currentQuestion > 0)
            GestureDetector(
              onTap: isLoading ? null : _goToPrevious,
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  '\u2190  Previous question',
                  style: TextStyle(
                    color: textLight.withOpacity(0.6),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// Painters
// ============================================================

/// Misty blue lotus flower with a dark base leaf.
class _LotusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Design space is 110 x 72; scale to given size.
    final sx = size.width / 110;
    final sy = size.height / 72;
    canvas.scale(sx, sy);

    Paint fill(Color c, [double opacity = 1]) =>
        Paint()..color = c.withOpacity(opacity);

    // Center petal
    final center = Path()
      ..moveTo(55, 10)
      ..quadraticBezierTo(63, 22, 62, 30)
      ..quadraticBezierTo(61, 41, 55, 48)
      ..quadraticBezierTo(49, 41, 48, 30)
      ..quadraticBezierTo(47, 22, 55, 10)
      ..close();
    canvas.drawPath(center, fill(const Color(0xFFCFEAF2), 0.95));

    // Inner side petals
    final leftInner = Path()
      ..moveTo(36, 20)
      ..quadraticBezierTo(50, 26, 55, 48)
      ..quadraticBezierTo(39, 44, 30, 28)
      ..quadraticBezierTo(32, 23, 36, 20)
      ..close();
    canvas.drawPath(leftInner, fill(const Color(0xFF9ED4E2), 0.9));

    final rightInner = Path()
      ..moveTo(74, 20)
      ..quadraticBezierTo(60, 26, 55, 48)
      ..quadraticBezierTo(71, 44, 80, 28)
      ..quadraticBezierTo(78, 23, 74, 20)
      ..close();
    canvas.drawPath(rightInner, fill(const Color(0xFF9ED4E2), 0.9));

    // Outer side petals
    final leftOuter = Path()
      ..moveTo(20, 36)
      ..quadraticBezierTo(33, 39, 42, 49)
      ..quadraticBezierTo(30, 52, 17, 41)
      ..quadraticBezierTo(18, 38, 20, 36)
      ..close();
    canvas.drawPath(leftOuter, fill(const Color(0xFF6FA9BC), 0.85));

    final rightOuter = Path()
      ..moveTo(90, 36)
      ..quadraticBezierTo(77, 39, 68, 49)
      ..quadraticBezierTo(80, 52, 93, 41)
      ..quadraticBezierTo(92, 38, 90, 36)
      ..close();
    canvas.drawPath(rightOuter, fill(const Color(0xFF6FA9BC), 0.85));

    // Base leaf / pad
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(55, 52), width: 52, height: 14),
      fill(const Color(0xFF0A4D52), 0.9),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Three expanding, fading elliptical ripples under the lotus.
class _RipplePainter extends CustomPainter {
  final double progress; // 0..1, looping

  _RipplePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, 18);

    for (int i = 0; i < 3; i++) {
      // Stagger each ring by a third of the loop
      final t = (progress + i / 3) % 1.0;
      final rx = 55 + t * 90; // expands outward
      final ry = rx * 0.28;
      final opacity = (1 - t) * 0.45; // fades as it grows

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3
        ..color = const Color(0xFF7EC7D9).withOpacity(opacity);

      canvas.drawOval(
        Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) =>
      oldDelegate.progress != progress;
}