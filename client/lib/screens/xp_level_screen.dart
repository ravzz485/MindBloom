// ============================================================
//  screen 3
//  XP Level Screen
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
        home: const XpLevelScreen(),
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
  static const olive        = Color(0xFF3F6212);
  static const oliveBg      = Color(0xFFF0FDF0);
  static const blue         = Color(0xFF1D4ED8);
  static const blueBg       = Color(0xFFEFF6FF);
  static const amber        = Color(0xFFB45309);
  static const amberBg      = Color(0xFFFEF9EC);
  static const rose         = Color(0xFFBE185D);
  static const roseBg       = Color(0xFFFDF2F8);
}

// ── Data models ───────────────────────────────────────────────────────────────
class _XPData {
  final int    level, currentXP, xpGoal;
  final String levelTitle;
  const _XPData({
    required this.level,
    required this.currentXP,
    required this.xpGoal,
    required this.levelTitle,
  });
  double get progress => currentXP / xpGoal;
  int    get xpNeeded => xpGoal - currentXP;
  int    get pct      => (progress * 100).round();
}

class _EarnItem {
  final IconData icon;
  final Color    iconColor, iconBg;
  final String   label, sub, xp;
  const _EarnItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.sub,
    required this.xp,
  });
}

enum _TLState { done, current, locked }

class _LevelItem {
  final int       level;
  final String    title, desc;
  final _TLState  state;
  const _LevelItem({
    required this.level,
    required this.title,
    required this.desc,
    required this.state,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────────
class XpLevelScreen extends StatefulWidget {
  const XpLevelScreen({super.key});
  @override
  State<XpLevelScreen> createState() => _XpLevelScreenState();
}

class _XpLevelScreenState extends State<XpLevelScreen>
    with SingleTickerProviderStateMixin {

  late final AnimationController _ctrl;
  late final Animation<double>   _barAnim;

  // ── Sample data — replace with real API response ──────────────────────────
  final _data = const _XPData(
    level:      5,
    currentXP:  340,
    xpGoal:     500,
    levelTitle: 'Mindful Explorer',
  );

  final _earnItems = const [
    _EarnItem(
      icon:      Icons.sentiment_satisfied_alt_rounded,
      iconColor: _C.red,
      iconBg:    _C.redBg,
      label:     'Daily mood check-in',
      sub:       'Log your mood every day',
      xp:        '+20 XP',
    ),
    _EarnItem(
      icon:      Icons.air_rounded,
      iconColor: _C.olive,
      iconBg:    _C.oliveBg,
      label:     'Breathing exercise',
      sub:       'Complete a full session',
      xp:        '+30 XP',
    ),
    _EarnItem(
      icon:      Icons.menu_book_rounded,
      iconColor: _C.blue,
      iconBg:    _C.blueBg,
      label:     'Journaling',
      sub:       'Write a journal entry',
      xp:        '+25 XP',
    ),
    _EarnItem(
      icon:      Icons.flag_rounded,
      iconColor: _C.amber,
      iconBg:    _C.amberBg,
      label:     'Complete challenge',
      sub:       'Finish a 7-day challenge',
      xp:        '+50 XP',
    ),
    _EarnItem(
      icon:      Icons.local_fire_department_rounded,
      iconColor: _C.rose,
      iconBg:    _C.roseBg,
      label:     'Maintain streak',
      sub:       'Keep your daily streak alive',
      xp:        '+15 XP',
    ),
  ];

  final _levels = const [
    _LevelItem(level: 1, title: 'Newcomer',        desc: 'Started the wellness journey',          state: _TLState.done),
    _LevelItem(level: 2, title: 'Beginner',         desc: 'First week of daily check-ins',         state: _TLState.done),
    _LevelItem(level: 3, title: 'Practitioner',     desc: 'Completed first breathing challenge',   state: _TLState.done),
    _LevelItem(level: 4, title: 'Wellness Seeker',  desc: 'Logged mood for 30 days',              state: _TLState.done),
    _LevelItem(level: 5, title: 'Mindful Explorer', desc: 'Currently at 340 / 500 XP',            state: _TLState.current),
    _LevelItem(level: 6, title: 'Habit Builder',    desc: 'Reach 500 XP to unlock',               state: _TLState.locked),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _barAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Future.delayed(const Duration(milliseconds: 350), _ctrl.forward));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _C.bg,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 80),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildStatGrid(),
                  const SizedBox(height: 14),
                  _buildSectionLabel('HOW TO EARN XP'),
                  const SizedBox(height: 10),
                  _buildEarnCard(),
                  const SizedBox(height: 14),
                  _buildSectionLabel('LEVEL HISTORY'),
                  const SizedBox(height: 10),
                  _buildTimelineCard(),
                ]),
              ),
            ),
          ],
        ),
      );

  // ── App bar with hero ─────────────────────────────────────────────────────
  SliverAppBar _buildAppBar() => SliverAppBar(
        expandedHeight:  190,
        pinned:          true,
        elevation:       0,
        backgroundColor: _C.brand,
        automaticallyImplyLeading: false,
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
            child: Column(
              children: [
                // Title row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.14),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.white.withOpacity(.22)),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 15),
                      ),
                    ),
                    // Title + sub
                    Column(children: [
                      const Text('XP Level',
                          style: TextStyle(
                            fontSize:   20,
                            fontWeight: FontWeight.w800,
                            color:      Colors.white,
                            letterSpacing: -.3,
                          )),
                      Text('Your experience progress',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(.55),
                          )),
                    ]),
                    // Bell
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.14),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.white.withOpacity(.22)),
                      ),
                      child: const Icon(Icons.notifications_outlined,
                          color: Colors.white, size: 18),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Level hero card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:        Colors.white.withOpacity(.12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        color: Colors.white.withOpacity(.18)),
                  ),
                  child: Row(children: [
                    // Level badge
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        color:        Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${_data.level}',
                              style: const TextStyle(
                                fontSize:   24,
                                fontWeight: FontWeight.w900,
                                color:      _C.brand,
                                height:     1,
                              )),
                          const Text('LEVEL',
                              style: TextStyle(
                                fontSize:   9,
                                fontWeight: FontWeight.w700,
                                color:      _C.textMid,
                                letterSpacing: .5,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Info + bar
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_data.levelTitle,
                            style: const TextStyle(
                              fontSize:   16,
                              fontWeight: FontWeight.w800,
                              color:      Colors.white,
                            )),
                        const SizedBox(height: 3),
                        Text(
                          '${_data.currentXP} / ${_data.xpGoal} XP'
                          ' — ${_data.xpNeeded} XP to Level ${_data.level + 1}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(.55),
                          ),
                        ),
                        const SizedBox(height: 9),
                        // Animated bar
                        AnimatedBuilder(
                          animation: _barAnim,
                          builder: (_, __) => ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value:           _barAnim.value * _data.progress,
                              minHeight:       8,
                              backgroundColor: Colors.white.withOpacity(.15),
                              valueColor: const AlwaysStoppedAnimation(
                                  Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Bar labels
                        AnimatedBuilder(
                          animation: _barAnim,
                          builder: (_, __) => Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${(_barAnim.value * _data.pct).round()}% complete',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(.5),
                                ),
                              ),
                              Text(
                                'Level ${_data.level + 1} unlocks at ${_data.xpGoal} XP',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                  ]),
                ),
              ],
            ),
          ),
        ),
      );

  // ── Stat mini grid ────────────────────────────────────────────────────────
  Widget _buildStatGrid() => Row(children: [
        Expanded(child: _statMini('${_data.currentXP}', 'Current XP')),
        const SizedBox(width: 8),
        Expanded(child: _statMini('${_data.xpNeeded}',  'XP Needed')),
        const SizedBox(width: 8),
        Expanded(child: _statMini('${_data.pct}%',      'Progress')),
      ]);

  Widget _statMini(String val, String lbl) => Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color:        _C.bg,
          borderRadius: BorderRadius.circular(14),
          border:       Border.all(color: _C.border),
        ),
        child: Column(children: [
          Text(val, style: const TextStyle(
            fontSize:   20,
            fontWeight: FontWeight.w800,
            color:      _C.brand,
            height:     1,
          )),
          const SizedBox(height: 4),
          Text(lbl, style: const TextStyle(
            fontSize: 10, color: _C.textMid),
            textAlign: TextAlign.center,
          ),
        ]),
      );

  // ── Section label ─────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String text) => Row(children: [
        Container(
          width: 3, height: 16,
          decoration: BoxDecoration(
            color: _C.brand, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 7),
        Text(text, style: const TextStyle(
          fontSize:   10,
          fontWeight: FontWeight.w800,
          color:      _C.brand,
          letterSpacing: 1.1,
        )),
      ]);

  // ── How to earn XP card ───────────────────────────────────────────────────
  Widget _buildEarnCard() => Container(
        decoration: BoxDecoration(
          color:        _C.card,
          borderRadius: BorderRadius.circular(18),
          border:       Border.all(color: _C.border, width: .5),
          boxShadow: [BoxShadow(
            color: _C.brand.withOpacity(.05),
            blurRadius: 10, offset: const Offset(0, 3),
          )],
        ),
        child: Column(
          children: _earnItems.asMap().entries.map((e) {
            final isLast = e.key == _earnItems.length - 1;
            return _earnRow(e.value, isLast);
          }).toList(),
        ),
      );

  Widget _earnRow(_EarnItem item, bool isLast) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: _C.border, width: .5)),
        ),
        child: Row(children: [
          // Icon
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color:        item.iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          // Label
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.label, style: const TextStyle(
                fontSize:   12,
                fontWeight: FontWeight.w700,
                color:      _C.textDark,
              )),
              const SizedBox(height: 2),
              Text(item.sub, style: const TextStyle(
                fontSize: 11, color: _C.textMid)),
            ],
          )),
          // XP badge
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:        _C.brandSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(item.xp, style: const TextStyle(
              fontSize:   11,
              fontWeight: FontWeight.w800,
              color:      _C.brand,
            )),
          ),
        ]),
      );

  // ── Level history timeline ────────────────────────────────────────────────
  Widget _buildTimelineCard() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:        _C.card,
          borderRadius: BorderRadius.circular(18),
          border:       Border.all(color: _C.border, width: .5),
          boxShadow: [BoxShadow(
            color: _C.brand.withOpacity(.05),
            blurRadius: 10, offset: const Offset(0, 3),
          )],
        ),
        child: Column(
          children: _levels.asMap().entries.map((e) {
            final isLast = e.key == _levels.length - 1;
            return _timelineRow(e.value, isLast);
          }).toList(),
        ),
      );

  Widget _timelineRow(_LevelItem item, bool isLast) {
    // Dot style
    Color dotBg, dotFg;
    Widget dotChild;
    String chipText;
    Color chipBg, chipFg;

    switch (item.state) {
      case _TLState.done:
        dotBg    = _C.brand;
        dotFg    = Colors.white;
        dotChild = const Icon(Icons.check_rounded,
            color: Colors.white, size: 15);
        chipText = 'Completed';
        chipBg   = _C.brandSoft;
        chipFg   = _C.brand;
        break;
      case _TLState.current:
        dotBg    = Colors.white;
        dotFg    = _C.brand;
        dotChild = Text('${item.level}',
            style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w800,
              color: _C.brand));
        chipText = 'Current level';
        chipBg   = _C.brand;
        chipFg   = Colors.white;
        break;
      case _TLState.locked:
        dotBg    = _C.border;
        dotFg    = _C.textLight;
        dotChild = const Icon(Icons.lock_outline_rounded,
            color: _C.textLight, size: 14);
        chipText = '${_data.xpNeeded} XP away';
        chipBg   = _C.bg;
        chipFg   = _C.textLight;
        break;
    }

    // Border for current dot
    final dotDecoration = item.state == _TLState.current
        ? BoxDecoration(
            shape: BoxShape.circle,
            color: dotBg,
            border: Border.all(color: _C.brand, width: 2),
          )
        : BoxDecoration(shape: BoxShape.circle, color: dotBg);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left — dot + line
        SizedBox(
          width: 36,
          child: Column(
            children: [
              Container(
                width: 32, height: 32,
                decoration: dotDecoration,
                child: Center(child: dotChild),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: item.state == _TLState.done
                        ? _C.brand
                        : _C.border,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Right — content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: isLast ? 0 : 16, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level ${item.level} — ${item.title}',
                  style: TextStyle(
                    fontSize:   12,
                    fontWeight: FontWeight.w800,
                    color: item.state == _TLState.locked
                        ? _C.textLight
                        : _C.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(item.desc,
                    style: const TextStyle(
                      fontSize: 11, color: _C.textMid)),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color:        chipBg,
                    borderRadius: BorderRadius.circular(10),
                    border: item.state == _TLState.current
                        ? null
                        : Border.all(
                            color: _C.border, width: .5),
                  ),
                  child: Text(chipText,
                      style: TextStyle(
                        fontSize:   10,
                        fontWeight: FontWeight.w700,
                        color:      chipFg,
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}