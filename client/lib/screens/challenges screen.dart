// ============================================================
//  Screen 4 — Challenges Screen
//  Mental Health Risk Screening & Self-Care App
//
//  
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Standalone entry point (remove when integrating) ─────────────────────────
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
        home: const ChallengesScreen(),
      );
}

// ── Colour tokens ─────────────────────────────────────────────────────────────
class _C {
  static const brand        = Color(0xFF174143);
  static const brandSoft    = Color(0xFFE4F0F0);
  static const brandFaint   = Color(0xFFF0F6F6);
  static const bg           = Color(0xFFF3F6F6);
  static const card         = Color(0xFFFFFFFF);
  static const border       = Color(0xFFDCE8E8);
  static const textDark     = Color(0xFF0D2B2D);
  static const textMid      = Color(0xFF4A7274);
  static const textLight    = Color(0xFF8BADB0);
  static const red          = Color(0xFFC53030);
  static const redBg        = Color(0xFFFFF0F0);
  static const amber        = Color(0xFFB45309);
  static const amberBg      = Color(0xFFFEF9EC);
  static const amberBorder  = Color(0xFFFDE68A);
  static const blue         = Color(0xFF1D4ED8);
  static const blueBg       = Color(0xFFEFF6FF);
  static const purple       = Color(0xFF6D28D9);
  static const purpleBg     = Color(0xFFF3F0FF);
  static const purpleBorder = Color(0xFFDDD6FE);
  static const olive        = Color(0xFF3F6212);
  static const oliveBg      = Color(0xFFF0FDF0);
  static const rose         = Color(0xFFBE185D);
  static const roseBg       = Color(0xFFFDF2F8);
}

// ── Challenge status enum ─────────────────────────────────────────────────────
enum ChallengeStatus { active, completed, locked }

// ── Challenge model ───────────────────────────────────────────────────────────
class Challenge {
  final String          id;
  final String          title;
  final String          description;
  final int             totalDays;
  final int             completedDays;
  final int             points;
  final bool            doneToday;
  final ChallengeStatus status;
  final IconData        icon;
  final Color           iconColor;
  final Color           iconBg;
  final Color           accentColor;

  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.totalDays,
    required this.completedDays,
    required this.points,
    required this.doneToday,
    required this.status,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.accentColor,
  });

  double get progress => completedDays / totalDays;
  int    get daysLeft => totalDays - completedDays;
  int    get pct      => (progress * 100).round();

  Challenge copyWith({bool? doneToday, int? completedDays}) => Challenge(
        id:            id,
        title:         title,
        description:   description,
        totalDays:     totalDays,
        completedDays: completedDays ?? this.completedDays,
        points:        points,
        doneToday:     doneToday    ?? this.doneToday,
        status:        status,
        icon:          icon,
        iconColor:     iconColor,
        iconBg:        iconBg,
        accentColor:   accentColor,
      );
}

// ── Screen ────────────────────────────────────────────────────────────────────
class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});
  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _fadeCtrl;
  late Animation<double>   _fadeAnim;

  // Tracks which challenge IDs are waiting for API response
  final Set<String> _loadingIds = {};

  // ── Sample data — swap with real API fetch ────────────────────────────────
  List<Challenge> _challenges = const [
    Challenge(
      id:            'c1',
      title:         '7-Day Mindfulness',
      description:   'Practice mindfulness meditation daily for 7 days',
      totalDays:     7,
      completedDays: 5,
      points:        150,
      doneToday:     true,
      status:        ChallengeStatus.active,
      icon:          Icons.self_improvement_rounded,
      iconColor:     _C.brand,
      iconBg:        _C.brandSoft,
      accentColor:   _C.brand,
    ),
    Challenge(
      id:            'c2',
      title:         'Better Sleep Week',
      description:   'Sleep before 11 PM and log your sleep quality',
      totalDays:     7,
      completedDays: 3,
      points:        200,
      doneToday:     false,
      status:        ChallengeStatus.active,
      icon:          Icons.bedtime_rounded,
      iconColor:     _C.blue,
      iconBg:        _C.blueBg,
      accentColor:   _C.blue,
    ),
    Challenge(
      id:            'c3',
      title:         'Daily Journaling',
      description:   'Write a journal entry every day for 7 days',
      totalDays:     7,
      completedDays: 2,
      points:        120,
      doneToday:     false,
      status:        ChallengeStatus.active,
      icon:          Icons.menu_book_rounded,
      iconColor:     _C.purple,
      iconBg:        _C.purpleBg,
      accentColor:   _C.purple,
    ),
    Challenge(
      id:            'c4',
      title:         'Breathing Exercise',
      description:   'Complete a 5-minute breathing session each day',
      totalDays:     7,
      completedDays: 7,
      points:        100,
      doneToday:     true,
      status:        ChallengeStatus.completed,
      icon:          Icons.air_rounded,
      iconColor:     _C.olive,
      iconBg:        _C.oliveBg,
      accentColor:   _C.olive,
    ),
    Challenge(
      id:            'c5',
      title:         'Stress Detox Week',
      description:   'Complete daily stress management activities',
      totalDays:     7,
      completedDays: 0,
      points:        180,
      doneToday:     false,
      status:        ChallengeStatus.locked,
      icon:          Icons.spa_rounded,
      iconColor:     _C.rose,
      iconBg:        _C.roseBg,
      accentColor:   _C.rose,
    ),
  ];

  // ── Filter tab index ──────────────────────────────────────────────────────
  int _selectedTab = 0;
  final List<String> _tabs = ['All', 'Active', 'Completed'];

  List<Challenge> get _filtered {
    switch (_selectedTab) {
      case 1:  return _challenges.where((c) => c.status == ChallengeStatus.active).toList();
      case 2:  return _challenges.where((c) => c.status == ChallengeStatus.completed).toList();
      default: return _challenges;
    }
  }

  int get _activeCount    => _challenges.where((c) => c.status == ChallengeStatus.active).length;
  int get _completedCount => _challenges.where((c) => c.status == ChallengeStatus.completed).length;
  int get _totalPoints    => _challenges
      .where((c) => c.status == ChallengeStatus.completed)
      .fold(0, (sum, c) => sum + c.points);

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fadeCtrl.forward());
  }

  @override
  void dispose() { _fadeCtrl.dispose(); super.dispose(); }

  // ── Mark Done Today — calls backend API ───────────────────────────────────
  Future<void> _markDoneToday(Challenge challenge) async {
    if (_loadingIds.contains(challenge.id)) return;
    setState(() => _loadingIds.add(challenge.id));

    try {
      // ── Replace this block with your real Node.js API call ─────────────
      //
      // import 'dart:convert';
      // import 'package:http/http.dart' as http;
      //
      // final response = await http.post(
      //   Uri.parse('https://your-api.com/api/challenges/${challenge.id}/complete'),
      //   headers: {
      //     'Content-Type':  'application/json',
      //     'Authorization': 'Bearer $userToken',
      //   },
      //   body: jsonEncode({
      //     'userId':      'user123',
      //     'challengeId': challenge.id,
      //     'date':        DateTime.now().toIso8601String(),
      //   }),
      // );
      //
      // if (response.statusCode != 200) throw Exception('API error');
      // ───────────────────────────────────────────────────────────────────

      // Simulated network delay — remove when using real API
      await Future.delayed(const Duration(milliseconds: 1200));

      // Update local state on success
      setState(() {
        _challenges = _challenges.map((c) {
          if (c.id == challenge.id) {
            return c.copyWith(
              doneToday:     true,
              completedDays: c.completedDays + 1,
            );
          }
          return c;
        }).toList();
      });

      if (mounted) _showSnack('Day marked complete! Keep it up.', ok: true);

    } catch (_) {
      if (mounted) _showSnack('Could not connect. Try again.', ok: false);
    } finally {
      if (mounted) setState(() => _loadingIds.remove(challenge.id));
    }
  }

  void _showSnack(String msg, {required bool ok}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(ok ? Icons.check_circle_rounded : Icons.error_outline_rounded,
            color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(msg,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600))),
      ]),
      backgroundColor: ok ? _C.brand : _C.red,
      behavior:        SnackBarBehavior.floating,
      margin:          const EdgeInsets.all(14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      duration: const Duration(seconds: 2),
    ));
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _C.bg,
        body: FadeTransition(
          opacity: _fadeAnim,
          child: Column(children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryRow(),
                    const SizedBox(height: 16),
                    _buildFilterTabs(),
                    const SizedBox(height: 14),
                    _buildList(),
                  ],
                ),
              ),
            ),
          ]),
        ),
      );

  // ── Teal header (≈25%) ────────────────────────────────────────────────────
  Widget _buildHeader() => Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: _C.brand,
          borderRadius: BorderRadius.only(
            bottomLeft:  Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 44),
            child: Column(children: [
              // Nav row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _hdrBtn(Icons.arrow_back_ios_new_rounded, 15,
                      () => Navigator.maybePop(context)),
                  Column(children: [
                    Text('CHALLENGES',
                        style: TextStyle(
                          fontSize:     10,
                          fontWeight:   FontWeight.w800,
                          color:        Colors.white.withOpacity(.6),
                          letterSpacing: 2.5,
                        )),
                    const SizedBox(height: 3),
                    const Text('Active Missions',
                        style: TextStyle(
                          fontSize:   20,
                          fontWeight: FontWeight.w800,
                          color:      Colors.white,
                          letterSpacing: -.3,
                        )),
                  ]),
                  _hdrBtn(Icons.notifications_outlined, 18, () {}),
                ],
              ),

              const SizedBox(height: 18),

              // Summary pills
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _pill(Icons.flag_rounded,          '$_activeCount Active'),
                  const SizedBox(width: 10),
                  _pill(Icons.check_circle_outline_rounded, '$_completedCount Done'),
                  const SizedBox(width: 10),
                  _pill(Icons.star_border_rounded,   '$_totalPoints pts'),
                ],
              ),
            ]),
          ),
        ),
      );

  Widget _hdrBtn(IconData icon, double sz, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.14),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: Colors.white.withOpacity(.22)),
          ),
          child: Icon(icon, color: Colors.white, size: sz),
        ),
      );

  Widget _pill(IconData icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.14),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(.22)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                fontSize:   11,
                fontWeight: FontWeight.w700,
                color:      Colors.white,
              )),
        ]),
      );

  // ── Summary cards row (floats over boundary) ──────────────────────────────
  Widget _buildSummaryRow() => Transform.translate(
        offset: const Offset(0, -28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Expanded(child: _summaryCard(
              icon:      Icons.local_fire_department_rounded,
              iconColor: _C.red,
              iconBg:    _C.redBg,
              value:     '$_activeCount',
              label:     'In Progress',
            )),
            const SizedBox(width: 10),
            Expanded(child: _summaryCard(
              icon:      Icons.workspace_premium_rounded,
              iconColor: _C.amber,
              iconBg:    _C.amberBg,
              value:     '$_completedCount',
              label:     'Completed',
            )),
            const SizedBox(width: 10),
            Expanded(child: _summaryCard(
              icon:      Icons.bolt_rounded,
              iconColor: _C.purple,
              iconBg:    _C.purpleBg,
              value:     '$_totalPoints',
              label:     'Points Won',
            )),
          ]),
        ),
      );

  Widget _summaryCard({
    required IconData icon,
    required Color    iconColor,
    required Color    iconBg,
    required String   value,
    required String   label,
  }) => Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color:        _C.card,
          borderRadius: BorderRadius.circular(18),
          border:       Border.all(color: _C.border),
          boxShadow: [BoxShadow(
            color: _C.brand.withOpacity(.08),
            blurRadius: 14, offset: const Offset(0, 5),
          )],
        ),
        child: Column(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
                color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(
            fontSize:   20,
            fontWeight: FontWeight.w800,
            color:      _C.textDark,
            height:     1,
          )),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(fontSize: 10, color: _C.textMid),
              textAlign: TextAlign.center),
        ]),
      );

  // ── Filter tabs ───────────────────────────────────────────────────────────
  Widget _buildFilterTabs() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color:        _C.bg,
            borderRadius: BorderRadius.circular(14),
            border:       Border.all(color: _C.border),
          ),
          child: Row(
            children: _tabs.asMap().entries.map((e) {
              final sel = e.key == _selectedTab;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTab = e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: sel ? _C.brand : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(e.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:   12,
                          fontWeight: FontWeight.w700,
                          color: sel ? Colors.white : _C.textMid,
                        )),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );

  // ── Challenge list ────────────────────────────────────────────────────────
  Widget _buildList() {
    final list = _filtered;
    if (list.isEmpty) return _buildEmpty();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
          children: list.map((c) => _buildCard(c)).toList()),
    );
  }

  Widget _buildEmpty() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(child: Column(children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
                color: _C.brandSoft, shape: BoxShape.circle),
            child: const Icon(Icons.flag_outlined,
                color: _C.brand, size: 30),
          ),
          const SizedBox(height: 14),
          const Text('No challenges here yet',
              style: TextStyle(
                fontSize:   15,
                fontWeight: FontWeight.w700,
                color:      _C.textDark,
              )),
          const SizedBox(height: 6),
          const Text('Start a new challenge to see it here',
              style: TextStyle(fontSize: 12, color: _C.textMid)),
        ])),
      );

  // ── Single challenge card ─────────────────────────────────────────────────
  Widget _buildCard(Challenge c) {
    final loading     = _loadingIds.contains(c.id);
    final isCompleted = c.status == ChallengeStatus.completed;
    final isLocked    = c.status == ChallengeStatus.locked;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCompleted
            ? _C.brandFaint
            : isLocked ? _C.bg : _C.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompleted
              ? _C.brand.withOpacity(.22)
              : _C.border,
        ),
        boxShadow: isLocked
            ? []
            : [BoxShadow(
                color: _C.brand.withOpacity(.06),
                blurRadius: 12, offset: const Offset(0, 4),
              )],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Row 1 — icon + title + points badge
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color:        isLocked ? _C.border : c.iconBg,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  isLocked ? Icons.lock_outline_rounded : c.icon,
                  color: isLocked ? _C.textLight : c.iconColor,
                  size:  22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(c.title,
                          style: TextStyle(
                            fontSize:   14,
                            fontWeight: FontWeight.w800,
                            color: isLocked ? _C.textLight : _C.textDark,
                            letterSpacing: -.2,
                          ))),
                      const SizedBox(width: 8),
                      // Points badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? _C.brandSoft
                              : isLocked ? _C.bg : _C.amberBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isCompleted
                                ? _C.brand.withOpacity(.2)
                                : isLocked
                                    ? _C.border
                                    : _C.amberBorder,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded,
                                size: 11,
                                color: isCompleted
                                    ? _C.brand
                                    : isLocked ? _C.textLight : _C.amber),
                            const SizedBox(width: 3),
                            Text('${c.points} pts',
                                style: TextStyle(
                                  fontSize:   10,
                                  fontWeight: FontWeight.w800,
                                  color: isCompleted
                                      ? _C.brand
                                      : isLocked ? _C.textLight : _C.amber,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(c.description,
                      style: const TextStyle(
                          fontSize: 11, color: _C.textMid, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              )),
            ]),

            // Progress section (active/completed only)
            if (!isLocked) ...[
              const SizedBox(height: 14),

              // Progress labels
              Row(children: [
                Text('${c.completedDays}/${c.totalDays} days',
                    style: const TextStyle(
                      fontSize:   11,
                      fontWeight: FontWeight.w700,
                      color:      _C.textMid,
                    )),
                const Spacer(),
                Text('${c.pct}%',
                    style: const TextStyle(
                      fontSize:   11,
                      fontWeight: FontWeight.w800,
                      color:      _C.brand,
                    )),
              ]),
              const SizedBox(height: 7),

              // Animated progress bar
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: c.progress),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                builder: (context, val, child) => ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value:           val,
                    minHeight:       7,
                    backgroundColor: _C.brand.withOpacity(.08),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? _C.brand : c.accentColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Bottom row — days left chip + button
              Row(children: [
                if (!isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color:        _C.brandFaint,
                      borderRadius: BorderRadius.circular(20),
                      border:       Border.all(color: _C.border),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.schedule_rounded,
                          size: 12, color: _C.brand),
                      const SizedBox(width: 4),
                      Text('${c.daysLeft} days left',
                          style: const TextStyle(
                            fontSize:   10,
                            fontWeight: FontWeight.w700,
                            color:      _C.brand,
                          )),
                    ]),
                  ),

                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color:        _C.brandSoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.check_circle_rounded,
                          size: 12, color: _C.brand),
                      const SizedBox(width: 4),
                      const Text('Completed!',
                          style: TextStyle(
                            fontSize:   10,
                            fontWeight: FontWeight.w700,
                            color:      _C.brand,
                          )),
                    ]),
                  ),

                const Spacer(),

                if (!isCompleted) _markDoneBtn(c, loading),
              ]),
            ],

            // Locked footer
            if (isLocked)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(children: const [
                  Icon(Icons.lock_outline_rounded,
                      size: 13, color: _C.textLight),
                  SizedBox(width: 6),
                  Text('Complete previous challenges to unlock',
                      style: TextStyle(
                          fontSize: 11, color: _C.textLight)),
                ]),
              ),
          ],
        ),
      ),
    );
  }

  // ── Mark Done Today button ────────────────────────────────────────────────
  Widget _markDoneBtn(Challenge c, bool loading) {
    final done = c.doneToday;
    return GestureDetector(
      onTap: done || loading ? null : () => _markDoneToday(c),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: done ? _C.brandSoft : _C.brand,
          borderRadius: BorderRadius.circular(12),
          boxShadow: done
              ? []
              : [BoxShadow(
                  color: _C.brand.withOpacity(.30),
                  blurRadius: 10, offset: const Offset(0, 4),
                )],
        ),
        child: loading
            ? const SizedBox(
                width: 16, height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(
                  done
                      ? Icons.check_rounded
                      : Icons.add_circle_outline_rounded,
                  size:  14,
                  color: done ? _C.brand : Colors.white,
                ),
                const SizedBox(width: 5),
                Text(
                  done ? 'Done Today' : 'Mark Done',
                  style: TextStyle(
                    fontSize:   11,
                    fontWeight: FontWeight.w800,
                    color: done ? _C.brand : Colors.white,
                  ),
                ),
              ]),
      ),
    );
  }
}