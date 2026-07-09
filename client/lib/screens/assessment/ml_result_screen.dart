// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../assessment/ai_checkin_screen.dart';

/// NOTE: add to pubspec.yaml dependencies:
///   url_launcher: ^6.2.0
/// (used for the helpline call button)

class MLResultScreen extends StatelessWidget {
  final String mlPrediction;
  final double mlConfidence;
  final String detectedIssue;
  final String riskLevel;
  final String disclaimer;

  const MLResultScreen({
    super.key,
    required this.mlPrediction,
    required this.mlConfidence,
    required this.detectedIssue,
    required this.riskLevel,
    required this.disclaimer,
  });

  // ---- Design tokens ----
  static const Color pine = Color(0xFF123332);
  static const Color teal = Color(0xFF1C4B47);
  static const Color heroBg = Color(0xFF033A3C);
  static const Color mist = Color(0xFFEDF3EE);
  static const Color muted = Color(0xFF6E8480);
  static const Color ink = Color(0xFF17322E);
  static const Color coral = Color(0xFFC94F35);
  static const Color amberDeep = Color(0xFFE8842B);
  static const Color green = Color(0xFF2C8A4B);

  // ============================================================
  // CONFIGURE FOR YOUR REGION:
  // Sri Lanka national mental health helpline is 1926 —
  // please verify the right number(s) for your audience.
  // ============================================================
  static const String helplineNumber = '1926';

  // ------------------------------------------------------------
  // Risk tier: high / moderate / low
  // ------------------------------------------------------------
  String get _tier {
    final r = riskLevel.toLowerCase();
    if (r.contains('high') || r.contains('severe')) return 'high';
    if (r.contains('moderate') || r.contains('medium') || r.contains('mild')) {
      return 'moderate';
    }
    final hasIssue = _issue != 'none';
    if (hasIssue && mlConfidence >= 80) return 'high';
    if (hasIssue && mlConfidence >= 50) return 'moderate';
    return 'low';
  }

  // ------------------------------------------------------------
  // Issue: depression / anxiety / stress / none
  // ------------------------------------------------------------
  String get _issue {
    final combined =
        '${mlPrediction.toLowerCase()} ${detectedIssue.toLowerCase()}';
    if (combined.contains('depress')) return 'depression';
    if (combined.contains('anx')) return 'anxiety';
    if (combined.contains('stress')) return 'stress';
    return 'none';
  }

  String get _issueLabel {
    switch (_issue) {
      case 'depression':
        return 'Depression';
      case 'anxiety':
        return 'Anxiety';
      case 'stress':
        return 'Stress';
      default:
        return 'None detected';
    }
  }

  String get _issueInSentence {
    switch (_issue) {
      case 'depression':
        return 'depression';
      case 'anxiety':
        return 'anxiety';
      case 'stress':
        return 'stress';
      default:
        return 'emotional distress';
    }
  }

  String get _issueTip {
    switch (_issue) {
      case 'stress':
        return 'Alongside support, small daily breaks and saying no to extra load can ease the pressure.';
      case 'anxiety':
        return 'Grounding and breathing exercises can calm the moment, and support helps with the bigger picture.';
      default:
        return 'These options are free and confidential.';
    }
  }

  Color get _accent {
    switch (_tier) {
      case 'high':
        return coral;
      case 'moderate':
        return amberDeep;
      default:
        return green;
    }
  }

  String get _headline {
    if (_tier == 'low') return 'No strong signs detected';
    return 'You may be going through a hard time';
  }

  String get _subtitle {
    if (_tier == 'low') {
      return 'Your responses do not show strong indicators of ${_issue == 'none' ? 'depression or anxiety' : _issueInSentence} right now. Keep taking care of yourself.';
    }
    final strength = _tier == 'high' ? 'strong signs' : 'some signs';
    return 'Your answers show $strength of $_issueInSentence. That takes courage to share \u2014 and support can genuinely help.';
  }

  // ------------------------------------------------------------
  // Action helpers
  // ------------------------------------------------------------
  Future<void> _callHelpline() async {
    final uri = Uri.parse('tel:$helplineNumber');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _analyzeMyLevel(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AICheckInScreen(),
      ),
    );
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mist,
      body: Column(
        children: [
          _header(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
              child: Column(
                children: [
                  _gauge(),
                  const SizedBox(height: 16),
                  Text(
                    _headline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: pine,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      _subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.55,
                        color: muted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _tier == 'low'
                      ? _momentumCard(context)
                      : _supportCard(context),
                  const SizedBox(height: 16),
                  _detailsCard(),
                  const SizedBox(height: 14),
                  _disclaimerNote(),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Back to home',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: teal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: heroBg,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 20, 18),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: Colors.white.withOpacity(0.22)),
                  ),
                  child: const Center(
                    child: Text(
                      '\u2190',
                      style: TextStyle(
                        color: Color(0xFFEAF4EF),
                        fontSize: 16,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Check-In Results',
                style: TextStyle(
                  color: Color(0xFFEAF4EF),
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gauge() {
    return SizedBox(
      width: 132,
      height: 132,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: (mlConfidence / 100).clamp(0.0, 1.0),
            strokeWidth: 10,
            color: _accent,
            backgroundColor: _accent.withOpacity(0.14),
            strokeCap: StrokeCap.round,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${mlConfidence.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    height: 1,
                    color: _accent,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'CONFIDENCE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // High / moderate risk: priority support card
  // Depression -> helpline only
  // Anxiety / Stress -> helpline + "Analyze My Level"
  // ------------------------------------------------------------
  Widget _supportCard(BuildContext context) {
    final isHigh = _tier == 'high';
    final gradient = isHigh
        ? const [Color(0xFFB33D2B), Color(0xFFD96038), Color(0xFFE8842B)]
        : const [Color(0xFFD98A2B), Color(0xFFE8A34B)];

    final showAnalyzeButton = _issue == 'anxiety' || _issue == 'stress';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withOpacity(0.32),
            blurRadius: 36,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isHigh ? 'REACH OUT NOW \u2014 YOU MATTER' : 'WORTH TAKING SERIOUSLY',
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isHigh
                ? 'You don\u2019t have to face this alone'
                : 'Talking to someone can really help',
            style: const TextStyle(
              color: Color(0xFFFFF7F2),
              fontSize: 17.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isHigh
                ? 'Talking to someone today can make a real difference. $_issueTip'
                : 'Consider reaching out this week \u2014 support at this stage makes a big difference. $_issueTip',
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontSize: 12.5,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 16),
          // Primary: call helpline
          GestureDetector(
            onTap: _callHelpline,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7F2),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '\u260E  Call mental health helpline',
                  style: TextStyle(
                    color: Color(0xFFA93A22),
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5,
                  ),
                ),
              ),
            ),
          ),
          // Only anxiety/stress get the extra "Analyze My Level" button.
          // Depression shows helpline only.
          if (showAnalyzeButton) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _analyzeMyLevel(context),
              child: Container(
                width: double.infinity,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.35)),
                ),
                child: const Center(
                  child: Text(
                    'Analyze My Level',
                    style: TextStyle(
                      color: Color(0xFFFFF7F2),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Low risk: keep-the-momentum card
  // Buttons: "View wellness tips" + "Analyze My Level"
  // ------------------------------------------------------------
  Widget _momentumCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C4B47), Color(0xFF2E6B57)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: teal.withOpacity(0.28),
            blurRadius: 36,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KEEP THE MOMENTUM',
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Small habits protect your wellbeing',
            style: TextStyle(
              color: Color(0xFFEAF4EF),
              fontSize: 17.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'A daily check-in helps you notice changes early \u2014 and celebrate the good days too.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontSize: 12.5,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4EF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Set a daily check-in reminder',
                  style: TextStyle(
                    color: teal,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ghostButton('View wellness tips', () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ghostButton(
                  'Analyze My Level',
                  () => _analyzeMyLevel(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ghostButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.35)),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFFFF7F2),
              fontWeight: FontWeight.w700,
              fontSize: 12,
              height: 1.25,
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // Details + disclaimer
  // ------------------------------------------------------------
  Widget _detailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12123332),
            blurRadius: 26,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _detailRow('AI confidence', '${mlConfidence.toStringAsFixed(1)}%'),
          const Divider(height: 1, color: Color(0xFFE4EDE6)),
          _detailRow('Detected issue', _issueLabel),
          const Divider(height: 1, color: Color(0xFFE4EDE6)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Risk level',
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    riskLevel.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: _accent,
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: muted, fontSize: 13)),
          Text(
            value,
            style: const TextStyle(
              color: ink,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _disclaimerNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 30,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFC4D6CC),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              disclaimer,
              style: const TextStyle(
                fontSize: 11.5,
                color: muted,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}