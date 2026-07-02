// ============================================================
//  Screen 6 — Badge Collection Screen
//  Mental Health Risk Screening & Self-Care App
//
//  Design:
//   • #174143 header (≈25 % of screen)
//   • White / off-white body (≈75 % of screen)
//   • Earned badges shown in full colour
//   • Locked badges shown greyscale with a lock icon
//   • Tap any badge → bottom sheet shows the earn condition
//
//  Setup:
//   1. Copy to lib/screens/gamification/badges_screen.dart
//   2. No extra packages required
//   3. In gamification_home_screen.dart add:
//        import 'badges_screen.dart';
//      and inside _go():
//        case 'badges':
//          Navigator.push(context,
//              MaterialPageRoute(builder: (_) => const BadgesScreen()));
//          break;
//   4. Replace the mock _badges list with your real API data
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
        home: const BadgesScreen(),
      );
}

// ── Colour tokens ─────────────────────────────────────────────────────────────
class _C {
  static const brand       = Color(0xFF174143);
  static const brandSoft   = Color(0xFFE4F0F0);
  static const brandFaint  = Color(0xFFF0F6F6);
  static const bg          = Color(0xFFF3F6F6);
  static const card        = Color(0xFFFFFFFF);
  static const border      = Color(0xFFDCE8E8);
  static const textDark    = Color(0xFF0D2B2D);
  static const textMid     = Color(0xFF4A7274);
  static const textLight   = Color(0xFF8BADB0);
  static const lockedBg    = Color(0xFFEDF2F2);
  static const lockedIcon  = Color(0xFFB9CBCB);

  // Badge accent colours (used only when earned)
  static const amber   = Color(0xFFB45309);
  static const amberBg = Color(0xFFFEF9EC);
  static const red     = Color(0xFFC53030);
  static const redBg   = Color(0xFFFFF0F0);
  static const purple  = Color(0xFF6D28D9);
  static const purpleBg= Color(0xFFF3F0FF);
  static const blue    = Color(0xFF1D4ED8);
  static const blueBg  = Color(0xFFEFF6FF);
  static const olive   = Color(0xFF3F6212);
  static const oliveBg = Color(0xFFF0FDF0);
  static const rose    = Color(0xFFBE185D);
  static const roseBg  = Color(0xFFFDF2F8);
}

// ── Badge model ────────────────────────────────────────────────────────────────
class BadgeItem {
  final String   id;
  final String   title;
  final String   condition;     // shown on tap
  final IconData icon;
  final Color    color;         // accent colour when earned
  final Color    bg;            // soft background when earned
  final bool     earned;
  final String?  earnedDate;    // null if locked

  const BadgeItem({
    required this.id,
    required this.title,
    required this.condition,
    required this.icon,
    required this.color,
    required this.bg,
    required this.earned,
    this.earnedDate,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────────
class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});
  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen>
    with SingleTickerProviderStateMixin {

  late final AnimationController _fadeCtrl;
  late final Animation<double>   _fade;

  // ── Replace with your real API call ──────────────────────────────────────
  // Example: final badges = await ApiService.getBadges(userId);
  final List<BadgeItem> _badges = const [
    BadgeItem(
      id: 'b1', title: 'First Step',
      condition: 'Complete your very first daily check-in',
      icon: Icons.flag_rounded,
      color: _C.olive, bg: _C.oliveBg,
      earned: true, earnedDate: 'Earned on 12 May 2026',
    ),
    BadgeItem(
      id: 'b2', title: 'Week Warrior',
      condition: 'Maintain a 7-day streak without missing a day',
      icon: Icons.local_fire_department_rounded,
      color: _C.red, bg: _C.redBg,
      earned: true, earnedDate: 'Earned on 18 May 2026',
    ),
    BadgeItem(
      id: 'b3', title: 'Mindful Mind',
      condition: 'Complete 10 meditation or breathing sessions',
      icon: Icons.self_improvement_rounded,
      color: _C.purple, bg: _C.purpleBg,
      earned: true, earnedDate: 'Earned on 22 May 2026',
    ),
    BadgeItem(
      id: 'b4', title: 'Journal Keeper',
      condition: 'Write 15 journal entries',
      icon: Icons.menu_book_rounded,
      color: _C.blue, bg: _C.blueBg,
      earned: false,
    ),
    BadgeItem(
      id: 'b5', title: 'Tree Grower',
      condition: 'Reach a wellness score of 80% or higher for 5 days',
      icon: Icons.park_rounded,
      color: _C.olive, bg: _C.oliveBg,
      earned: false,
    ),
    BadgeItem(
      id: 'b6', title: 'Sleep Champion',
      condition: 'Log 7+ hours of sleep for 7 consecutive nights',
      icon: Icons.bedtime_rounded,
      color: _C.blue, bg: _C.blueBg,
      earned: false,
    ),
    BadgeItem(
      id: 'b7', title: 'Challenge Master',
      condition: 'Complete 3 full 7-day challenges',
      icon: Icons.workspace_premium_rounded,
      color: _C.amber, bg: _C.amberBg,
      earned: false,
    ),
    BadgeItem(
      id: 'b8', title: 'Calm Streak',
      condition: 'Keep your stress level low for 14 days straight',
      icon: Icons.spa_rounded,
      color: _C.rose, bg: _C.roseBg,
      earned: false,
    ),
    BadgeItem(
      id: 'b9', title: 'Level 10 Hero',
      condition: 'Reach XP Level 10',
      icon: Icons.bolt_rounded,
      color: _C.purple, bg: _C.purpleBg,
      earned: false,
    ),
  ];

  int get _earnedCount => _badges.where((b) => b.earned).length;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fadeCtrl.forward());
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Show earn condition in a bottom sheet ──────────────────────────────────
  void _showBadgeDetail(BadgeItem b) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _BadgeDetailSheet(badge: b),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _C.bg,
        body: FadeTransition(
          opacity: _fade,
          child: Column(children: [
            _header(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _progressCard(),
                    const SizedBox(height: 18),
                    _sectionLabel('YOUR BADGES'),
                    const SizedBox(height: 12),
                    _badgeGrid(),
                  ],
                ),
              ),
            ),
          ]),
        ),
      );

  // ── Header — #174143 (≈25 %) ─────────────────────────────────────────────
  Widget _header() => Container(
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
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _hdrBtn(Icons.arrow_back_ios_new_rounded, 15,
                    () => Navigator.maybePop(context)),
                Column(children: [
                  Text('BADGES',
                      style: TextStyle(
                        fontSize:   10,
                        fontWeight: FontWeight.w800,
                        color:      Colors.white.withOpacity(.6),
                        letterSpacing: 2.5,
                      )),
                  const SizedBox(height: 3),
                  const Text('Your Collection',
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
          ),
        ),
      );

  Widget _hdrBtn(IconData icon, double sz, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color:        Colors.white.withOpacity(.14),
            borderRadius: BorderRadius.circular(11),
            border:       Border.all(color: Colors.white.withOpacity(.22)),
          ),
          child: Icon(icon, color: Colors.white, size: sz),
        ),
      );

  // ── Progress summary card (white, ≈75 %) ──────────────────────────────────
  Widget _progressCard() => Transform.translate(
        offset: const Offset(0, -16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color:        _C.card,
              borderRadius: BorderRadius.circular(20),
              border:       Border.all(color: _C.border),
              boxShadow: [BoxShadow(
                color: _C.brand.withOpacity(.08),
                blurRadius: 14, offset: const Offset(0, 5),
              )],
            ),
            child: Row(children: [
              // Trophy icon block — #174143
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color:        _C.brand,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.military_tech_rounded,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$_earnedCount of ${_badges.length} earned',
                      style: const TextStyle(
                        fontSize:   16,
                        fontWeight: FontWeight.w800,
                        color:      _C.textDark,
                        letterSpacing: -.2,
                      )),
                  const SizedBox(height: 4),
                  Text('Keep completing activities to unlock more',
                      style: const TextStyle(
                          fontSize: 11, color: _C.textMid)),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                          begin: 0, end: _earnedCount / _badges.length),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (context, val, child) =>
                          LinearProgressIndicator(
                        value:           val,
                        minHeight:       7,
                        backgroundColor: _C.brand.withOpacity(.1),
                        valueColor:
                            const AlwaysStoppedAnimation(_C.brand),
                      ),
                    ),
                  ),
                ],
              )),
            ]),
          ),
        ),
      );

  // ── Section label ─────────────────────────────────────────────────────────
  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
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
        ]),
      );

  // ── Badge grid — 3 columns ─────────────────────────────────────────────────
  Widget _badgeGrid() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _badges.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:   3,
            crossAxisSpacing: 10,
            mainAxisSpacing:  10,
            childAspectRatio: 0.80,
          ),
          itemBuilder: (context, i) => _badgeTile(_badges[i]),
        ),
      );

  Widget _badgeTile(BadgeItem b) {
    return GestureDetector(
      onTap: () => _showBadgeDetail(b),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color:        b.earned ? _C.card : _C.lockedBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: b.earned ? b.color.withOpacity(.25) : _C.border,
          ),
          boxShadow: b.earned
              ? [BoxShadow(
                  color: _C.brand.withOpacity(.06),
                  blurRadius: 10, offset: const Offset(0, 3),
                )]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge icon circle
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color:  b.earned ? b.bg : _C.lockedBg,
                    shape:  BoxShape.circle,
                    border: Border.all(
                      color: b.earned
                          ? b.color.withOpacity(.3)
                          : _C.border,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    b.icon,
                    color: b.earned ? b.color : _C.lockedIcon,
                    size:  24,
                  ),
                ),
                if (!b.earned)
                  Positioned(
                    bottom: -2, right: -2,
                    child: Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        color:  _C.textLight,
                        shape:  BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.lock_rounded,
                          color: Colors.white, size: 11),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 9),
            Text(
              b.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize:   11,
                fontWeight: FontWeight.w700,
                color: b.earned ? _C.textDark : _C.textLight,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom sheet showing earn condition ───────────────────────────────────────
class _BadgeDetailSheet extends StatelessWidget {
  final BadgeItem badge;
  const _BadgeDetailSheet({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 30),
      decoration: const BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.only(
          topLeft:  Radius.circular(26),
          topRight: Radius.circular(26),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              color: _C.border,
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Badge icon — large
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 84, height: 84,
                decoration: BoxDecoration(
                  color:  badge.earned ? badge.bg : _C.lockedBg,
                  shape:  BoxShape.circle,
                  border: Border.all(
                    color: badge.earned
                        ? badge.color.withOpacity(.3)
                        : _C.border,
                    width: 3,
                  ),
                ),
                child: Icon(
                  badge.icon,
                  color: badge.earned ? badge.color : _C.lockedIcon,
                  size:  40,
                ),
              ),
              if (!badge.earned)
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color:  _C.textLight,
                      shape:  BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(Icons.lock_rounded,
                        color: Colors.white, size: 14),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          Text(badge.title,
              style: const TextStyle(
                fontSize:   18,
                fontWeight: FontWeight.w800,
                color:      _C.textDark,
                letterSpacing: -.2,
              )),

          const SizedBox(height: 8),

          // Status chip
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: badge.earned ? _C.brandSoft : _C.lockedBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: badge.earned
                    ? _C.brand.withOpacity(.25)
                    : _C.border,
              ),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                badge.earned
                    ? Icons.check_circle_rounded
                    : Icons.lock_outline_rounded,
                size:  13,
                color: badge.earned ? _C.brand : _C.textLight,
              ),
              const SizedBox(width: 5),
              Text(
                badge.earned ? 'Earned' : 'Locked',
                style: TextStyle(
                  fontSize:   11,
                  fontWeight: FontWeight.w700,
                  color: badge.earned ? _C.brand : _C.textLight,
                ),
              ),
            ]),
          ),

          const SizedBox(height: 18),

          // Condition card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:        _C.brandFaint,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _C.brand.withOpacity(.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 15, color: _C.brand),
                  const SizedBox(width: 6),
                  const Text('HOW TO EARN',
                      style: TextStyle(
                        fontSize:   10,
                        fontWeight: FontWeight.w800,
                        color:      _C.brand,
                        letterSpacing: 1,
                      )),
                ]),
                const SizedBox(height: 8),
                Text(badge.condition,
                    style: const TextStyle(
                      fontSize: 13,
                      color:    _C.textMid,
                      height:   1.5,
                    )),
              ],
            ),
          ),

          if (badge.earned && badge.earnedDate != null) ...[
            const SizedBox(height: 12),
            Row(children: [
              const Icon(Icons.event_available_rounded,
                  size: 14, color: _C.textMid),
              const SizedBox(width: 6),
              Text(badge.earnedDate!,
                  style: const TextStyle(
                      fontSize: 12, color: _C.textMid)),
            ]),
          ],

          const SizedBox(height: 20),

          // Close button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.brand,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Got it',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}