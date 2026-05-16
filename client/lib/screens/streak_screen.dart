import 'package:flutter/material.dart';
import 'dart:math' as math;

// ─────────────────────────────────────────────
//  ENTRY POINT  (remove if inside existing app)
// ─────────────────────────────────────────────
void main() {
  runApp(const MentalHealthApp());
}

class MentalHealthApp extends StatelessWidget {
  const MentalHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindBloom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        useMaterial3: true,
      ),
      home: const StreakScreen(),
    );
  }
}

// ─────────────────────────────────────────────
//  COLORS
// ─────────────────────────────────────────────
class AppColors {
  static const white        = Color(0xFFFFFFFF);
  static const whiteSurface = Color(0xFFF3F7F7);
  static const whiteBorder  = Color(0xFFDCEAEA);

  static const teal         = Color(0xFF174143);
  static const tealLight    = Color(0xFF1F5557);
  static const tealLighter  = Color(0xFF256869);
  static const tealFaint    = Color(0xFFE8F2F2);
  static const tealMid      = Color(0xFF2A7A7D);

  static const textDark     = Color(0xFF0D2829);
  static const textMid      = Color(0xFF2E5456);
  static const textMuted    = Color(0xFF7A9EA0);
  static const textWhite    = Color(0xFFFFFFFF);
  static const textWhite70  = Color(0xB3FFFFFF);

  static const gold         = Color(0xFFD4A017);
  static const goldLight    = Color(0xFFFDF3D7);
  static const orange       = Color(0xFFE8622A);
  static const orangeLight  = Color(0xFFFEEEE6);
  static const green        = Color(0xFF1E8A5E);
  static const greenLight   = Color(0xFFE6F5EF);
  static const purple       = Color(0xFF5B4B9A);
  static const purpleLight  = Color(0xFFEFECF8);
}

// ─────────────────────────────────────────────
//  DATA MODEL
// ─────────────────────────────────────────────
class StreakData {
  final int currentStreak;
  final int longestStreak;
  final int totalCheckIns;
  final List<bool> last28Days;   // true = checked in
  final List<bool> thisWeek;     // 7 days, Mon–Sun

  const StreakData({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCheckIns,
    required this.last28Days,
    required this.thisWeek,
  });
}

// ─────────────────────────────────────────────
//  STREAK SCREEN
// ─────────────────────────────────────────────
class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen>
    with TickerProviderStateMixin {

  // ── sample data ──────────────────────────────
  StreakData data = const StreakData(
    currentStreak: 9,
    longestStreak: 21,
    totalCheckIns: 47,
    last28Days: [
      true,  true,  false, true,  true,  true,  false,
      true,  true,  true,  false, true,  true,  true,
      true,  false, true,  true,  true,  true,  false,
      true,  true,  true,  true,  true,  true,  false,
    ],
    thisWeek: [true, true, true, true, true, true, false],
  );

  bool _checkedInToday = false;

  // ── animation controllers ─────────────────────
  late AnimationController _fadeController;
  late AnimationController _counterController;
  late AnimationController _ringController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnim;
  late Animation<int>    _counterAnim;
  late Animation<double> _ringAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _counterController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _ringController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600));
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(
        parent: _fadeController, curve: Curves.easeIn);
    _counterAnim = IntTween(begin: 0, end: data.currentStreak).animate(
        CurvedAnimation(parent: _counterController, curve: Curves.easeOut));
    _ringAnim = CurvedAnimation(
        parent: _ringController, curve: Curves.easeOut);
    _pulseAnim = Tween<double>(begin: 0.97, end: 1.03).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      _counterController.forward();
      _ringController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _counterController.dispose();
    _ringController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleCheckIn() {
    if (_checkedInToday) return;
    setState(() {
      _checkedInToday = true;
      data = StreakData(
        currentStreak: data.currentStreak + 1,
        longestStreak: data.longestStreak,
        totalCheckIns: data.totalCheckIns + 1,
        last28Days: data.last28Days,
        thisWeek: [...data.thisWeek.sublist(0, 6), true],
      );
    });
    _counterController.reset();
    _counterAnim = IntTween(begin: 0, end: data.currentStreak).animate(
        CurvedAnimation(parent: _counterController, curve: Curves.easeOut));
    _counterController.forward();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.teal,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: const Text(
          'Day checked in — keep the momentum going!',
          style: TextStyle(
              color: AppColors.textWhite, fontWeight: FontWeight.w600),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            _buildTealHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStreakRingCard(),
                    const SizedBox(height: 4),
                    _buildStatTriple(),
                    const SizedBox(height: 20),
                    _buildWeekHeatmap(),
                    const SizedBox(height: 20),
                    _buildMonthGrid(),
                    const SizedBox(height: 20),
                    _buildMilestones(),
                    const SizedBox(height: 24),
                    _buildCheckInButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  TEAL HEADER
  // ─────────────────────────────────────────────
  Widget _buildTealHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.teal,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 52),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.tealLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.tealLighter),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textWhite, size: 16),
                ),
              ),

              // Title
              Column(
                children: [
                  const Text(
                    'STREAK',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite70,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Daily Progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textWhite,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),

              // Calendar icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.tealLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.tealLighter),
                ),
                child: const Icon(Icons.calendar_month_rounded,
                    color: AppColors.textWhite, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  STREAK RING CARD  (overlaps header)
  // ─────────────────────────────────────────────
  Widget _buildStreakRingCard() {
    return Transform.translate(
      offset: const Offset(0, -36),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.whiteBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.teal.withOpacity(0.13),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Ring + counter
            SizedBox(
              width: 170,
              height: 170,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer decorative ring
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (context, child) => Transform.scale(
                      scale: _pulseAnim.value,
                      child: child,
                    ),
                    child: Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.teal.withOpacity(0.08),
                            width: 12),
                      ),
                    ),
                  ),

                  // Progress arc
                  AnimatedBuilder(
                    animation: _ringAnim,
                    builder: (context, _) => CustomPaint(
                      size: const Size(150, 150),
                      painter: _RingPainter(
                        progress: _ringAnim.value *
                            (data.currentStreak / 30.0).clamp(0.0, 1.0),
                        color: AppColors.teal,
                        trackColor: AppColors.tealFaint,
                        strokeWidth: 10,
                      ),
                    ),
                  ),

                  // Center content
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _counterAnim,
                        builder: (context, _) => Text(
                          '${_counterAnim.value}',
                          style: const TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.w900,
                            color: AppColors.teal,
                            height: 1,
                            letterSpacing: -2,
                          ),
                        ),
                      ),
                      const Text(
                        'DAYS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                          letterSpacing: 2.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Label
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.tealFaint,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _checkedInToday
                    ? 'Checked in today — amazing!'
                    : 'Current Streak — keep going!',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.teal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  STAT TRIPLE
  // ─────────────────────────────────────────────
  Widget _buildStatTriple() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          _buildStatBox(
            label: 'Current',
            value: '${data.currentStreak}',
            sub: 'days',
            color: AppColors.orange,
            bgColor: AppColors.orangeLight,
          ),
          const SizedBox(width: 10),
          _buildStatBox(
            label: 'Longest',
            value: '${data.longestStreak}',
            sub: 'days',
            color: AppColors.teal,
            bgColor: AppColors.tealFaint,
          ),
          const SizedBox(width: 10),
          _buildStatBox(
            label: 'Total',
            value: '${data.totalCheckIns}',
            sub: 'check-ins',
            color: AppColors.purple,
            bgColor: AppColors.purpleLight,
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox({
    required String label,
    required String value,
    required String sub,
    required Color color,
    required Color bgColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color.withOpacity(0.7),
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: color,
                letterSpacing: -1,
                height: 1,
              ),
            ),
            Text(
              sub,
              style: TextStyle(
                fontSize: 10,
                color: color.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  WEEK HEATMAP  (7-day row)
  // ─────────────────────────────────────────────
  Widget _buildWeekHeatmap() {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final today = DateTime.now().weekday - 1; // 0=Mon

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('This Week', 'View all'),
          const SizedBox(height: 14),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.whiteBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (i) {
                final isChecked = data.thisWeek[i];
                final isToday   = i == today;
                final isFuture  = i > today;

                return Column(
                  children: [
                    Text(
                      days[i],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isToday
                            ? AppColors.teal
                            : AppColors.textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isFuture
                            ? AppColors.whiteSurface
                            : isChecked
                                ? AppColors.teal
                                : AppColors.whiteBorder,
                        border: isToday
                            ? Border.all(
                                color: AppColors.teal, width: 2)
                            : null,
                        boxShadow: isChecked && !isFuture
                            ? [
                                BoxShadow(
                                  color: AppColors.teal.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: isFuture
                          ? null
                          : Icon(
                              isChecked
                                  ? Icons.check_rounded
                                  : Icons.close_rounded,
                              size: 16,
                              color: isChecked
                                  ? AppColors.white
                                  : AppColors.textMuted,
                            ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isToday
                            ? AppColors.teal
                            : Colors.transparent,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  28-DAY MONTH GRID
  // ─────────────────────────────────────────────
  Widget _buildMonthGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Last 28 Days', null),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.whiteBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Day labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                      .map((d) => SizedBox(
                            width: 32,
                            child: Text(
                              d,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textMuted,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 10),
                // Grid
                ...List.generate(4, (row) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(7, (col) {
                        final idx = row * 7 + col;
                        final checked = idx < data.last28Days.length
                            ? data.last28Days[idx]
                            : false;
                        final opacity = checked
                            ? 1.0
                            : 0.0;

                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300 + idx * 20),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: checked
                                ? AppColors.teal
                                    .withOpacity(0.15 + opacity * 0.7)
                                : AppColors.whiteSurface,
                          ),
                          child: checked
                              ? Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.teal,
                                    ),
                                  ),
                                )
                              : null,
                        );
                      }),
                    ),
                  );
                }),

                const SizedBox(height: 8),
                // Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.whiteSurface,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: AppColors.whiteBorder),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('Missed',
                        style: TextStyle(
                            fontSize: 10, color: AppColors.textMuted)),
                    const SizedBox(width: 12),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.teal,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('Checked in',
                        style: TextStyle(
                            fontSize: 10, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  MILESTONE BADGES
  // ─────────────────────────────────────────────
  Widget _buildMilestones() {
    final milestones = [
      _Milestone(label: '3 Days',   days: 3,  icon: Icons.local_fire_department_rounded, color: AppColors.orange,  bg: AppColors.orangeLight),
      _Milestone(label: '7 Days',   days: 7,  icon: Icons.bolt_rounded,                  color: AppColors.gold,    bg: AppColors.goldLight),
      _Milestone(label: '14 Days',  days: 14, icon: Icons.star_rounded,                  color: AppColors.teal,    bg: AppColors.tealFaint),
      _Milestone(label: '21 Days',  days: 21, icon: Icons.workspace_premium_rounded,      color: AppColors.purple,  bg: AppColors.purpleLight),
      _Milestone(label: '30 Days',  days: 30, icon: Icons.emoji_events_rounded,           color: AppColors.gold,    bg: AppColors.goldLight),
      _Milestone(label: '60 Days',  days: 60, icon: Icons.military_tech_rounded,          color: AppColors.green,   bg: AppColors.greenLight),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Milestones', null),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.9,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: milestones.map((m) {
              final achieved = data.currentStreak >= m.days;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: achieved ? m.bg : AppColors.whiteSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: achieved
                        ? m.color.withOpacity(0.3)
                        : AppColors.whiteBorder,
                    width: 1.2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon container
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: achieved
                            ? m.color.withOpacity(0.15)
                            : AppColors.whiteBorder,
                      ),
                      child: Icon(
                        m.icon,
                        size: 22,
                        color: achieved ? m.color : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      m.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: achieved
                            ? AppColors.textDark
                            : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      achieved ? 'Achieved' : 'Locked',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: achieved ? m.color : AppColors.textMuted,
                      ),
                    ),
                    if (achieved)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Icon(Icons.check_circle_rounded,
                            size: 14, color: m.color),
                      ),
                    if (!achieved)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Icon(Icons.lock_outline_rounded,
                            size: 12, color: AppColors.textMuted),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  CHECK-IN BUTTON
  // ─────────────────────────────────────────────
  Widget _buildCheckInButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: _checkedInToday ? null : _handleCheckIn,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: _checkedInToday
                ? AppColors.tealFaint
                : AppColors.teal,
            borderRadius: BorderRadius.circular(20),
            boxShadow: _checkedInToday
                ? []
                : [
                    BoxShadow(
                      color: AppColors.teal.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _checkedInToday
                    ? Icons.check_circle_rounded
                    : Icons.add_circle_outline_rounded,
                color: _checkedInToday
                    ? AppColors.teal
                    : AppColors.white,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                _checkedInToday
                    ? 'Checked in for today'
                    : 'Check In for Today',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _checkedInToday
                      ? AppColors.teal
                      : AppColors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  SECTION HEADER
  // ─────────────────────────────────────────────
  Widget _buildSectionHeader(String title, String? action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            letterSpacing: -0.2,
          ),
        ),
        if (action != null)
          Text(
            action,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.teal,
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  RING PAINTER
// ─────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  const _RingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;

    // Track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}

// ─────────────────────────────────────────────
//  HELPER MODEL
// ─────────────────────────────────────────────
class _Milestone {
  final String label;
  final int days;
  final IconData icon;
  final Color color;
  final Color bg;

  const _Milestone({
    required this.label,
    required this.days,
    required this.icon,
    required this.color,
    required this.bg,
  });
}