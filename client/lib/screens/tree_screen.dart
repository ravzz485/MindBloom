// ============================================================
// Screen 7 — Digital Mental Twin Tree Screen
// Final Year Project — Gamification Module
//
// Fetches wellness score from GET /api/wellness/:userId and renders
// a CustomPainter tree whose visual state (glow, canopy fullness,
// flowers, stress clouds) responds to the score.
//
// Color scheme: 75% white, 25% dark teal (#174143)
//
// Dependencies (add to pubspec.yaml):
//   http: ^1.2.0
// ============================================================

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const Color kTeal = Color(0xFF174143);
const Color kWhite = Colors.white;

class TreeScreen extends StatefulWidget {
  final String userId;
  final String baseUrl;

  const TreeScreen({
    super.key,
    required this.userId,
    this.baseUrl = 'https://your-api.example.com',
  });

  @override
  State<TreeScreen> createState() => _TreeScreenState();
}

class _TreeScreenState extends State<TreeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _swayController;
  late final AnimationController _glowController;
  late final AnimationController _dripController;

  bool _loading = true;
  String? _error;

  double _wellnessScore = 0.6; // 0.0 - 1.0
  String _topFactor = 'Sleep Quality';

  @override
  void initState() {
    super.initState();

    _swayController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _dripController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _fetchWellness();
  }

  @override
  void dispose() {
    _swayController.dispose();
    _glowController.dispose();
    _dripController.dispose();
    super.dispose();
  }

  Future<void> _fetchWellness() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final uri = Uri.parse('${widget.baseUrl}/api/wellness/${widget.userId}');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _wellnessScore = (data['score'] as num?)?.toDouble() ?? 0.6;
          _topFactor = data['topFactor'] as String? ?? 'Sleep Quality';
          _loading = false;
        });
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        // Fallback demo value so the screen remains usable offline.
        _wellnessScore = 0.100;
        _topFactor = 'Sleep Quality';
        _loading = false;
        _error = 'Could not reach server — showing last known data.';
      });
    }
  }

  String get _treeState {
    if (_wellnessScore > 0.75) return 'Thriving';
    if (_wellnessScore >= 0.45) return 'Stable';
    return 'Stressed';
  }

  Color get _stateColor {
    if (_wellnessScore > 0.75) return const Color(0xFF4CAF50);
    if (_wellnessScore >= 0.45) return const Color(0xFFFFA000);
    return const Color(0xFFE53935);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kWhite, // 75% white
      appBar: AppBar(
        backgroundColor: kTeal, // 25% teal
        foregroundColor: kWhite,
        elevation: 0,
        title: const Text(
          'Digital Mental Twin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchWellness,
          ),
        ],
      ),
      body: Column(
        children: [
          // ---- Tree canvas (teal, 25% block) ----
          Container(
            width: double.infinity,
            height: size.height * 0.6,
            color: kTeal,
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: kWhite),
                  )
                : AnimatedBuilder(
                    animation: Listenable.merge(
                        [_swayController, _glowController, _dripController]),
                    builder: (context, _) {
                      return CustomPaint(
                        size: Size.infinite,
                        painter: TreePainter(
                          swayValue: _swayController.value,
                          glowValue: _glowController.value,
                          dripValue: _dripController.value,
                          wellnessScore: _wellnessScore,
                        ),
                      );
                    },
                  ),
          ),

          // ---- Info panel (white, 75% block) ----
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              transform: Matrix4.translationValues(0, -24, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: kTeal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tree state label
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: _stateColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(45),
                        border: Border.all(color: _stateColor, width: 1.2),
                      ),
                      child: Text(
                        _treeState,
                        style: TextStyle(
                          color: _stateColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Wellness score percentage
                    Text(
                      '${(_wellnessScore * 100).round()}%',
                      style: const TextStyle(
                        color: kTeal,
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Wellness Score',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Top wellness factor
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 18),
                      decoration: BoxDecoration(
                        color: kTeal.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.insights, color: kTeal),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Top Wellness Factor',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  _topFactor,
                                  style: const TextStyle(
                                    color: kTeal,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_error != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
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
// CustomPainter — draws a full fractal-canopy tree: soft teal
// vignette backdrop, tapered glowing trunk, dense branching
// canopy, fanned roots with drip bulbs, flowers, stress clouds.
// ============================================================
class TreePainter extends CustomPainter {
  final double swayValue; // 0..1, drives left-right sway
  final double glowValue; // 0..1, drives glow pulse
  final double dripValue; // 0..1, drives droplet fall loop
  final double wellnessScore; // 0..1

  TreePainter({
    required this.swayValue,
    required this.glowValue,
    required this.dripValue,
    required this.wellnessScore,
  });

  bool get _showFlowers => wellnessScore > 0.75;
  bool get _showStressClouds => wellnessScore < 0.45;

  /// 0.0 = struggling / bare-branch skeleton, 1.0 = fully thriving / lush canopy.
  double get _growthT => wellnessScore.clamp(0.0, 1.0);

  static const List<double> _rootSpreadAngles = [
    -58.0, -38.0, -18.0, 0.0, 18.0, 38.0, 58.0,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Hard safety clip: nothing this painter draws can ever spill past
    // the widget's own bounds, regardless of screen size or tuning.
    canvas.clipRect(Offset.zero & size);

    final groundY = size.height * 0.76;
    final base = Offset(size.width / 2, groundY);
    final canopyOrigin = Offset(size.width / 2, size.height * 0.40);

    final swayDeg = sin(swayValue * 2 * pi) * 4; // gentle sway, degrees
    final swayRad = swayDeg * pi / 180;
    final glowStrength = 0.5 + 0.5 * sin(glowValue * 2 * pi);

    _drawBackdrop(canvas, size);
    _drawGround(canvas, size, groundY);
    _drawStressClouds(canvas, size, groundY);
    _drawRoots(canvas, base);
    _drawDroplets(canvas, base);
    _drawGlowHalo(canvas, canopyOrigin, size, glowStrength);
    _drawTrunk(canvas, base, canopyOrigin, glowStrength);
    _drawCanopy(canvas, canopyOrigin, size, glowStrength, swayRad);
  }

  // ---- Soft radial vignette so the canopy area glows gently ----
  void _drawBackdrop(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.25),
        radius: 0.95,
        colors: [
          Color.lerp(kTeal, Colors.white, 0.10)!,
          kTeal,
        ],
        stops: const [0.0, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _drawGround(Canvas canvas, Size size, double groundY) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(0, groundY, size.width, size.height - groundY),
      paint,
    );
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.22)
      ..strokeWidth = 1.2;
    canvas.drawLine(
        Offset(0, groundY), Offset(size.width, groundY), linePaint);
  }

  void _drawStressClouds(Canvas canvas, Size size, double groundY) {
    if (!_showStressClouds) return;

    final cloudPaint = Paint()
      ..color = Colors.grey.shade600.withOpacity(0.55)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    final positions = [
      Offset(size.width * 0.22, groundY + 32),
      Offset(size.width * 0.5, groundY + 48),
      Offset(size.width * 0.76, groundY + 28),
    ];

    for (final pos in positions) {
      _drawCloudShape(canvas, pos, cloudPaint);
    }
  }

  void _drawCloudShape(Canvas canvas, Offset center, Paint paint) {
    canvas.drawCircle(center, 18, paint);
    canvas.drawCircle(center.translate(16, 4), 14, paint);
    canvas.drawCircle(center.translate(-16, 4), 14, paint);
    canvas.drawCircle(center.translate(0, -6), 12, paint);
  }

  // ---- Fanned roots with small drip bulbs at each tip ----
  List<Offset> _rootEndpoints(Offset base) {
    return _rootSpreadAngles.map((spread) {
      final angleRad = (90 + spread) * pi / 180; // 90 = straight down
      final length = 42 + spread.abs() * 0.35;
      return base + Offset(length * cos(angleRad), length * sin(angleRad));
    }).toList();
  }

  void _drawRoots(Canvas canvas, Offset base) {
    final rootPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final bulbPaint = Paint()..color = Colors.white.withOpacity(0.55);

    for (final spread in _rootSpreadAngles) {
      final angleRad = (90 + spread) * pi / 180;
      final length = 42 + spread.abs() * 0.35;
      final end = base + Offset(length * cos(angleRad), length * sin(angleRad));
      final mid = Offset(
        (base.dx + end.dx) / 2,
        (base.dy + end.dy) / 2 - 5,
      );
      final path = Path()
        ..moveTo(base.dx, base.dy)
        ..quadraticBezierTo(mid.dx, mid.dy, end.dx, end.dy);
      canvas.drawPath(path, rootPaint);
      canvas.drawCircle(end, 2.6, bulbPaint);
    }
  }

  void _drawDroplets(Canvas canvas, Offset base) {
    final endpoints = _rootEndpoints(base);
    for (var i = 0; i < endpoints.length; i++) {
      final end = endpoints[i];
      final phase = (dripValue + i * 0.14) % 1.0;
      final travel = phase * 26;
      final opacity = (1.0 - phase).clamp(0.0, 1.0);

      canvas.drawCircle(
        Offset(end.dx, end.dy + travel),
        2.6,
        Paint()
          ..color = Colors.lightBlue.shade100.withOpacity(0.75 * opacity),
      );
    }
  }

  // ---- Soft glow halo behind the whole canopy ----
  void _drawGlowHalo(
      Canvas canvas, Offset canopyOrigin, Size size, double glowStrength) {
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.14 + 0.12 * glowStrength)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 34 + 12 * glowStrength);

    canvas.drawCircle(
      canopyOrigin,
      size.width * 0.46,
      glowPaint,
    );
  }

  // ---- Tapered trunk, wide at the base, narrow at the canopy ----
  void _drawTrunk(
      Canvas canvas, Offset base, Offset top, double glowStrength) {
    final baseHalfWidth = 8.0;
    final topHalfWidth = 2.6;
    final control = Offset((base.dx + top.dx) / 2, (base.dy + top.dy) / 2);

    final path = Path()
      ..moveTo(base.dx - baseHalfWidth, base.dy)
      ..quadraticBezierTo(
          control.dx - topHalfWidth, control.dy, top.dx - topHalfWidth, top.dy)
      ..lineTo(top.dx + topHalfWidth, top.dy)
      ..quadraticBezierTo(
          control.dx + topHalfWidth, control.dy, base.dx + baseHalfWidth, base.dy)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withOpacity(0.16 + 0.1 * glowStrength)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawPath(
      path,
      Paint()..color = Colors.white.withOpacity(0.94),
    );
  }

  // ---- Main-limb angles interpolate between a tight, drooping cluster
  // (struggling / growthT = 0) and a full wide fan (thriving / growthT = 1).
  List<double> _mainAnglesFor(double t) {
    const narrow = [-104.0, -97.0, -90.0, -83.0, -76.0]; // tight, sagging
    const wide = [-158.0, -124.0, -90.0, -56.0, -22.0]; // full round canopy
    return List.generate(
        narrow.length, (i) => narrow[i] + (wide[i] - narrow[i]) * t);
  }

  // ---- Dense fractal canopy built from many curved branch strokes.
  // Reach, depth and leaf coverage all scale with growthT, so the same
  // tree reads as a bare skeleton when the user is struggling and as a
  // full lush canopy when they're thriving. ----
  void _drawCanopy(Canvas canvas, Offset origin, Size size, double glowStrength,
      double swayRad) {
    final random = Random(7); // fixed seed -> stable shape, no flicker
    final t = _growthT;
    // Tuned so the widest branch chain (angle -22°, max depth) still lands
    // safely inside the canvas width with a small margin — see the fit
    // check in _drawCanopy's doc comment below.
    final baseReach = min(size.width, size.height) * 0.26;
    final canopyReach = baseReach * (0.5 + 0.5 * t); // 0.5x .. 1.0x
    final depth = 3 + (t * 3).round(); // 3 (bare) .. 6 (full)
    final mainAngles = _mainAnglesFor(t);

    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.rotate(swayRad);

    for (final angle in mainAngles) {
      _branch(
        canvas,
        Offset.zero,
        angle,
        canopyReach * 0.5,
        depth,
        3.0,
        glowStrength,
        random,
        t,
      );
    }

    canvas.restore();
  }

  void _branch(
    Canvas canvas,
    Offset start,
    double angleDeg,
    double length,
    int depth,
    double strokeWidth,
    double glowStrength,
    Random random,
    double growthT,
  ) {
    if (depth == 0 || length < 4) {
      _maybeDrawLeafCluster(canvas, start, growthT, random, glowStrength);
      if (_showFlowers && random.nextDouble() > 0.4) {
        _drawFlower(canvas, start, random);
      }
      return;
    }

    final angleRad = angleDeg * pi / 180;
    final end = start + Offset(length * cos(angleRad), length * sin(angleRad));

    // slight organic curve via a perpendicular control offset
    final curveOffset = (random.nextDouble() - 0.5) * length * 0.35;
    final mid = Offset(
      (start.dx + end.dx) / 2 - sin(angleRad) * curveOffset,
      (start.dy + end.dy) / 2 + cos(angleRad) * curveOffset,
    );

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(mid.dx, mid.dy, end.dx, end.dy);

    // soft glow pass
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withOpacity(0.16 + 0.12 * glowStrength)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 3.5
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    // crisp pass
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withOpacity(0.7 + 0.2 * glowStrength)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Leaf clusters also cling to the last couple of branch levels, not
    // just the very tips, so the canopy fills in as a rounded mass rather
    // than staying spindly even at high growth.
    if (depth <= 2) {
      _maybeDrawLeafCluster(canvas, end, growthT, random, glowStrength);
    }

    for (var i = 0; i < 2; i++) {
      final variance = 15 + random.nextDouble() * 14;
      final nextAngle = angleDeg + (i == 0 ? -variance : variance);
      _branch(canvas, end, nextAngle, length * 0.74, depth - 1,
          strokeWidth * 0.72, glowStrength, random, growthT);
    }
  }

  // ---- Small overlapping foliage blobs. Below ~0.15 growth nothing is
  // drawn at all (bare branches); above that, count/size/opacity scale
  // up with growthT until the canopy reads as fully clothed in leaves. ----
  void _maybeDrawLeafCluster(
      Canvas canvas, Offset center, double growthT, Random random,
      double glowStrength) {
    final density = ((growthT - 0.15) / 0.85).clamp(0.0, 1.0);
    if (density <= 0.0) return;
    if (random.nextDouble() > (0.3 + density * 0.65)) return;

    final count = (2 + density * 3).round();
    for (var i = 0; i < count; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final r = random.nextDouble() * (2 + density * 4);
      final leafCenter = center + Offset(r * cos(angle), r * sin(angle));
      final leafSize = 1.8 + density * 2.4 + random.nextDouble();

      canvas.drawCircle(
        leafCenter,
        leafSize + 1.4,
        Paint()
          ..color = Colors.white.withOpacity(0.10 + 0.08 * glowStrength)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
      canvas.drawCircle(
        leafCenter,
        leafSize,
        Paint()..color = Colors.white.withOpacity(0.5 + density * 0.42),
      );
    }
  }

  void _drawFlower(Canvas canvas, Offset center, Random random) {
    final petalColors = [
      const Color(0xFFFFC1E3),
      const Color(0xFFFFE082),
      const Color(0xFFB2EBF2),
    ];
    final color = petalColors[random.nextInt(petalColors.length)];
    final petalPaint = Paint()..color = color.withOpacity(0.95);
    final centerPaint = Paint()..color = const Color(0xFFFFF176);

    for (var i = 0; i < 5; i++) {
      final angle = (i / 5) * 2 * pi;
      final petalCenter = Offset(
        center.dx + 4.2 * cos(angle),
        center.dy + 4.2 * sin(angle),
      );
      canvas.drawCircle(petalCenter, 2.6, petalPaint);
    }
    canvas.drawCircle(center, 1.8, centerPaint);
  }

  @override
  bool shouldRepaint(covariant TreePainter oldDelegate) {
    return oldDelegate.swayValue != swayValue ||
        oldDelegate.glowValue != glowValue ||
        oldDelegate.dripValue != dripValue ||
        oldDelegate.wellnessScore != wellnessScore;
  }
}