// ============================================================
//  
//  Mental Health Risk Screening & Self-Care App
// ============================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'streak_screen.dart';       // ← Screen 2
import 'xp_level_screen.dart';     // ← Screen 3
import 'challenges screen.dart';   // ← Screen 4  ✅ ADDED

// ── Standalone entry point (delete when integrating) ─────────────────────────
void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:          Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App();
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const GamificationHomeScreen(),
      );
}

// ── Colour tokens ─────────────────────────────────────────────────────────────
class _C {
  static const brand        = Color(0xFF174143);
  static const brandSoft    = Color(0xFFE4F0F0);
  static const bg           = Color(0xFFF3F6F6);
  static const card         = Color(0xFFFFFFFF);
  static const border       = Color(0xFFDCE8E8);
  static const textDark     = Color(0xFF0D2B2D);
  static const textMid      = Color(0xFF4A7274);
  static const textLight    = Color(0xFF8BADB0);
  static const red          = Color(0xFFC53030);
  static const redBg        = Color(0xFFFFF0F0);
  static const redBorder    = Color(0xFFFECACA);
  static const purple       = Color(0xFF6D28D9);
  static const purpleBg     = Color(0xFFF3F0FF);
  static const purpleBorder = Color(0xFFDDD6FE);
  static const amber        = Color(0xFFB45309);
  static const amberBg      = Color(0xFFFEF9EC);
  static const amberBorder  = Color(0xFFFDE68A);
  static const blue         = Color(0xFF1D4ED8);
  static const blueBg       = Color(0xFFEFF6FF);
  static const blueBorder   = Color(0xFFBFDBFE);
  static const olive        = Color(0xFF3F6212);
  static const oliveBg      = Color(0xFFF0FDF0);
  static const oliveBorder  = Color(0xFFBBF7D0);
  static const rose         = Color(0xFFBE185D);
  static const roseBg       = Color(0xFFFDF2F8);
  static const roseBorder   = Color(0xFFF9A8D4);
}

// ── Data model ────────────────────────────────────────────────────────────────
class _GData {
  final String name, rankTitle, treeState;
  final int    points, streak, xpLevel, currentXP, xpGoal,
               challenges, badges;
  final double wellness;
  const _GData({
    required this.name,       required this.rankTitle,
    required this.treeState,  required this.points,
    required this.streak,     required this.xpLevel,
    required this.currentXP,  required this.xpGoal,
    required this.challenges, required this.badges,
    required this.wellness,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────────
class GamificationHomeScreen extends StatefulWidget {
  const GamificationHomeScreen({super.key});
  @override
  State<GamificationHomeScreen> createState() => _ScreenState();
}

class _ScreenState extends State<GamificationHomeScreen>
    with TickerProviderStateMixin {

  late final AnimationController _fadeCtrl, _ringCtrl, _barCtrl;
  late final Animation<double>   _fade, _ring, _bar;

  bool _loaded = false;

  final _d = const _GData(
    name:       'Kavya',
    rankTitle:  'Mindful Explorer',
    treeState:  'Thriving',
    points:     1250,
    streak:     7,
    xpLevel:    5,
    currentXP:  340,
    xpGoal:     500,
    challenges: 2,
    badges:     3,
    wellness:   0.74,
  );

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 450));
    _ringCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 1200));
    _barCtrl  = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 1000));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _ring = CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOutCubic);
    _bar  = CurvedAnimation(parent: _barCtrl,  curve: Curves.easeOutCubic);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => _loaded = true);
      _fadeCtrl.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) { _ringCtrl.forward(); _barCtrl.forward(); }
      });
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose(); _ringCtrl.dispose(); _barCtrl.dispose();
    super.dispose();
  }

  // ── Navigation ────────────────────────────────────────────────────────────
  void _go(String route) {
    switch (route) {

      // ── Streak → StreakScreen ─────────────────────────────────────────────
      case 'streak':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const StreakScreen()));
        break;

      // ── XP Level → XpLevelScreen ─────────────────────────────────────────
      case 'xp_level':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const XpLevelScreen()));
        break;

      // ── Challenges → ChallengesScreen ✅ ADDED ────────────────────────────
      case 'challenges':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ChallengesScreen()));
        break;

      // ── Other screens — add Navigator.push as you build them ──────────────
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:         Text('Opening $route'),
          backgroundColor: _C.brand,
          behavior:        SnackBarBehavior.floating,
          duration:        const Duration(milliseconds: 900),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ));
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _C.bg,
        body: _loaded
            ? FadeTransition(opacity: _fade, child: _body())
            : const Center(
                child: CircularProgressIndicator(color: _C.brand)),
      );

  Widget _body() => CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _appBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 90),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 14),
                _statsRow(),
                const SizedBox(height: 12),
                _xpCard(),
                const SizedBox(height: 12),
                _treeCard(),
                const SizedBox(height: 18),
                _sectionLabel('QUICK ACCESS'),
                const SizedBox(height: 10),
                _quickGrid(),
                const SizedBox(height: 10),
                _tipCard(),
              ]),
            ),
          ),
        ],
      );

  // ── App bar ───────────────────────────────────────────────────────────────
  SliverAppBar _appBar() => SliverAppBar(
        expandedHeight:  130,
        pinned:          true,
        elevation:       0,
        backgroundColor: _C.brand,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: const BoxDecoration(
              color: _C.brand,
              borderRadius: BorderRadius.only(
                bottomLeft:  Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(18, 52, 18, 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, ${_d.name}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(.6),
                            letterSpacing: .2,
                          )),
                      const SizedBox(height: 4),
                      const Text('Your Progress',
                          style: TextStyle(
                            fontSize:   22,
                            fontWeight: FontWeight.w800,
                            color:      Colors.white,
                            letterSpacing: -.3,
                          )),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color:        Colors.white.withOpacity(.14),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withOpacity(.22)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.shield_outlined,
                        color: Colors.white, size: 14),
                    const SizedBox(width: 5),
                    Text(_d.rankTitle,
                        style: const TextStyle(
                          color:      Colors.white,
                          fontSize:   11,
                          fontWeight: FontWeight.w700,
                        )),
                  ]),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color:        Colors.white.withOpacity(.14),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.white.withOpacity(.22)),
                  ),
                  child: const Icon(Icons.notifications_outlined,
                      color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
        ),
      );

  // ── Stats row ─────────────────────────────────────────────────────────────
  Widget _statsRow() => Row(children: [
        Expanded(child: _statCard(
          icon:      Icons.star_border_rounded,
          iconColor: _C.amber,
          iconBg:    _C.amberBg,
          value:     '1,250',
          sub:       'Points Total',
          chipText:  '+50 today',
          chipColor: _C.amber,
          chipBg:    _C.amberBg,
          onTap:     () => _go('rewards'),
        )),
        const SizedBox(width: 10),
        Expanded(child: _statCard(
          icon:      Icons.local_fire_department_outlined,
          iconColor: _C.red,
          iconBg:    _C.redBg,
          value:     '${_d.streak}',
          sub:       'Days Streak',
          chipText:  'Keep it up!',
          chipColor: _C.olive,
          chipBg:    _C.oliveBg,
          onTap:     () => _go('streak'),
        )),
      ]);

  Widget _statCard({
    required IconData     icon,
    required Color        iconColor,
    required Color        iconBg,
    required String       value,
    required String       sub,
    required String       chipText,
    required Color        chipColor,
    required Color        chipBg,
    required VoidCallback onTap,
  }) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color:        _C.card,
            borderRadius: BorderRadius.circular(18),
            border:       Border.all(color: _C.border),
            boxShadow: [BoxShadow(
              color: _C.brand.withOpacity(.05),
              blurRadius: 10, offset: const Offset(0, 3),
            )],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: iconBg, shape: BoxShape.circle),
                  child: Icon(icon, color: iconColor, size: 19),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded,
                    size: 17, color: _C.textLight),
              ]),
              const SizedBox(height: 10),
              Text(value, style: const TextStyle(
                fontSize:   26,
                fontWeight: FontWeight.w800,
                color:      _C.textDark,
                letterSpacing: -.5,
              )),
              const SizedBox(height: 2),
              Text(sub, style: const TextStyle(
                  fontSize: 11, color: _C.textMid)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color:        chipBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(chipText, style: TextStyle(
                  fontSize:   10,
                  fontWeight: FontWeight.w700,
                  color:      chipColor,
                )),
              ),
            ],
          ),
        ),
      );

  // ── XP card ───────────────────────────────────────────────────────────────
  Widget _xpCard() => GestureDetector(
        onTap: () => _go('xp_level'),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color:        _C.brand,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(
              color: _C.brand.withOpacity(.25),
              blurRadius: 16, offset: const Offset(0, 5),
            )],
          ),
          child: Row(children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withOpacity(.24)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text('Level ${_d.xpLevel}',
                          style: const TextStyle(
                            color: Colors.white, fontSize: 11,
                            fontWeight: FontWeight.w700,
                          )),
                    ]),
                ),
                const SizedBox(height: 12),
                const Text('XP Progress',
                    style: TextStyle(
                      color: Colors.white, fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.2,
                    )),
                const SizedBox(height: 3),
                Text(
                  '${_d.xpGoal - _d.currentXP} XP needed '
                  'for Level ${_d.xpLevel + 1}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(.52),
                  ),
                ),
                const SizedBox(height: 14),
                AnimatedBuilder(
                  animation: _ring,
                  builder: (context, child) {
                    final pct =
                        (_ring.value * _d.currentXP / _d.xpGoal * 100)
                            .round();
                    return Row(children: [
                      Text('$pct% complete',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(.5),
                          )),
                      const Spacer(),
                      Icon(Icons.star_rounded,
                          color: Colors.white.withOpacity(.75),
                          size: 12),
                      const SizedBox(width: 4),
                      Text(_d.rankTitle,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withOpacity(.85),
                          )),
                    ]);
                  },
                ),
              ],
            )),
            const SizedBox(width: 16),
            AnimatedBuilder(
              animation: _ring,
              builder: (context, child) => SizedBox(
                width: 86, height: 86,
                child: CustomPaint(
                  painter: _RingPainter(
                      _ring.value * _d.currentXP / _d.xpGoal),
                  child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${_d.currentXP}',
                          style: const TextStyle(
                            color: Colors.white, fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -.4,
                          )),
                      Text('/${_d.xpGoal} XP',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.52),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  )),
                ),
              ),
            ),
          ]),
        ),
      );

  // ── Tree card ─────────────────────────────────────────────────────────────
  Widget _treeCard() => GestureDetector(
        onTap: () => _go('tree'),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color:        _C.card,
            borderRadius: BorderRadius.circular(18),
            border:       Border.all(color: _C.border),
            boxShadow: [BoxShadow(
              color: _C.brand.withOpacity(.05),
              blurRadius: 10, offset: const Offset(0, 3),
            )],
          ),
          child: Row(children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color:        _C.brand,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.park_rounded,
                  color: Colors.white, size: 34),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text('Mental Twin',
                      style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800,
                        color: _C.textDark, letterSpacing: -.2,
                      )),
                  const SizedBox(width: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color:        _C.roseBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _C.roseBorder),
                    ),
                    child: Text(_d.treeState,
                        style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w700,
                          color: _C.rose,
                        )),
                  ),
                ]),
                const SizedBox(height: 4),
                const Text(
                  'Your tree reflects your wellbeing today',
                  style: TextStyle(fontSize: 11, color: _C.textMid),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Text('${(_d.wellness * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w800,
                        color: _C.brand,
                      )),
                  const SizedBox(width: 9),
                  Expanded(child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: AnimatedBuilder(
                      animation: _bar,
                      builder: (context, child) =>
                          LinearProgressIndicator(
                        value:           _bar.value * _d.wellness,
                        minHeight:       6,
                        backgroundColor: _C.brand.withOpacity(.1),
                        valueColor: const AlwaysStoppedAnimation(
                            _C.brand),
                      ),
                    ),
                  )),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded,
                      size: 17, color: _C.textLight),
                ]),
              ],
            )),
          ]),
        ),
      );

  // ── Section label ─────────────────────────────────────────────────────────
  Widget _sectionLabel(String text) => Row(children: [
        Container(
          width: 3, height: 17,
          decoration: BoxDecoration(
            color:        _C.brand,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(text, style: const TextStyle(
          fontSize:   10,
          fontWeight: FontWeight.w800,
          color:      _C.brand,
          letterSpacing: 1.1,
        )),
      ]);

  // ── Quick access grid ─────────────────────────────────────────────────────
  Widget _quickGrid() {
    final items = [
      _QI(Icons.local_fire_department_outlined,
          'Streak',     '${_d.streak} Days Streak',
          _C.red,    _C.redBg,    _C.redBorder,    'streak'),
      _QI(Icons.bolt_outlined,
          'XP Level',  'Level ${_d.xpLevel}',
          _C.purple, _C.purpleBg, _C.purpleBorder, 'xp_level'),
      _QI(Icons.flag_outlined,
          'Challenges', '${_d.challenges} active',
          _C.amber,  _C.amberBg,  _C.amberBorder,  'challenges'),
      _QI(Icons.card_giftcard_outlined,
          'Rewards',   '${_d.points} pts',
          _C.blue,   _C.blueBg,   _C.blueBorder,   'rewards'),
      _QI(Icons.military_tech_outlined,
          'Badges',    '${_d.badges} earned',
          _C.amber,  _C.amberBg,  _C.amberBorder,  'badges'),
      _QI(Icons.park_outlined,
          'My Tree',   _d.treeState,
          _C.olive,  _C.oliveBg,  _C.oliveBorder,  'tree'),
    ];

    return Column(children: [
      _qRow(items[0], items[1], items[2]),
      const SizedBox(height: 9),
      _qRow(items[3], items[4], items[5]),
    ]);
  }

  Widget _qRow(_QI a, _QI b, _QI c) => IntrinsicHeight(
        child: Row(children: [
          Expanded(child: _qCard(a)),
          const SizedBox(width: 9),
          Expanded(child: _qCard(b)),
          const SizedBox(width: 9),
          Expanded(child: _qCard(c)),
        ]),
      );

  Widget _qCard(_QI q) => GestureDetector(
        onTap: () => _go(q.route),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color:        q.bg,
            borderRadius: BorderRadius.circular(18),
            border:       Border.all(color: q.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38, height: 38,
                decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
                child: Icon(q.icon, color: q.color, size: 20),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Flexible(
                  child: Text(q.label, style: const TextStyle(
                    fontSize:   11,
                    fontWeight: FontWeight.w800,
                    color:      _C.textDark,
                  ), overflow: TextOverflow.ellipsis),
                ),
                const Text(' |', style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w300,
                  color: _C.textLight,
                )),
              ]),
              const SizedBox(height: 2),
              Text(q.sub, style: const TextStyle(
                  fontSize: 10, color: _C.textMid),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      );

  // ── Daily tip card ────────────────────────────────────────────────────────
  Widget _tipCard() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:        _C.brandSoft,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _C.brand.withOpacity(.15)),
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color:        _C.brand.withOpacity(.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.lightbulb_outline_rounded,
                color: _C.brand, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: const [
                Text('Daily Tip ', style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w800,
                  color: _C.textDark,
                )),
                Text('|', style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w300,
                  color: _C.textLight,
                )),
              ]),
              const SizedBox(height: 4),
              const Text(
                'Complete today\'s breathing exercise to grow '
                'your tree and earn 20 XP!',
                style: TextStyle(
                  fontSize: 12, color: _C.textMid, height: 1.5),
              ),
            ],
          )),
        ]),
      );
}

// ── Circular ring CustomPainter ───────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  const _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final cx     = size.width  / 2;
    final cy     = size.height / 2;
    final radius = size.width  / 2 - 5;

    canvas.drawCircle(
      Offset(cx, cy), radius,
      Paint()
        ..color       = Colors.white.withOpacity(.15)
        ..style       = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color       = Colors.white
        ..style       = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap   = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// ── Quick item model ──────────────────────────────────────────────────────────
class _QI {
  final IconData icon;
  final String   label, sub, route;
  final Color    color, bg, border;
  const _QI(this.icon, this.label, this.sub,
            this.color, this.bg, this.border, this.route);
}