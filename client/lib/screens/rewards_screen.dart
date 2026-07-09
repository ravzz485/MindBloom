// ============================================================
//  Screen 5 — Rewards Screen
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
        home: const RewardsScreen(),
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
  static const blueBorder   = Color(0xFFBFDBFE);
  static const purple       = Color(0xFF6D28D9);
  static const purpleBg     = Color(0xFFF3F0FF);
  static const purpleBorder = Color(0xFFDDD6FE);
  static const olive        = Color(0xFF3F6212);
  static const oliveBg      = Color(0xFFF0FDF0);
  static const oliveBorder  = Color(0xFFBBF7D0);
  static const rose         = Color(0xFFBE185D);
  static const roseBg       = Color(0xFFFDF2F8);
  static const roseBorder   = Color(0xFFF9A8D4);
  static const cyan         = Color(0xFF0E7490);
  static const cyanBg       = Color(0xFFECFEFF);
  static const cyanBorder   = Color(0xFFA5F3FC);
}

// ── Reward status ─────────────────────────────────────────────────────────────
enum RewardStatus { locked, available, claimed }

// ── Reward model ──────────────────────────────────────────────────────────────
class Reward {
  final String       id;
  final String       title;
  final String       description;
  final int          pointsRequired;
  final RewardStatus status;
  final IconData     icon;
  final Color        iconColor;
  final Color        iconBg;
  final Color        borderColor;
  final String       category;

  const Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsRequired,
    required this.status,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.borderColor,
    required this.category,
  });

  Reward copyWith({RewardStatus? status}) => Reward(
        id:             id,
        title:          title,
        description:    description,
        pointsRequired: pointsRequired,
        status:         status ?? this.status,
        icon:           icon,
        iconColor:      iconColor,
        iconBg:         iconBg,
        borderColor:    borderColor,
        category:       category,
      );
}

// ── Screen ────────────────────────────────────────────────────────────────────
class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});
  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _fadeCtrl;
  late Animation<double>   _fadeAnim;

  final Set<String> _claimingIds = {};

  // ── User points — replace with real API data ──────────────────────────────
  int _userPoints = 1250;

  // ── Reward catalogue — replace with real API fetch ────────────────────────
  List<Reward> _rewards = const [
    Reward(
      id: 'r1', title: 'Meditation',
      description: '10-min guided meditation session',
      pointsRequired: 200,
      status:  RewardStatus.claimed,
      icon:    Icons.self_improvement_rounded,
      iconColor: _C.blue,    iconBg: _C.blueBg,
      borderColor: _C.blue, category: 'Wellness',
    ),
    Reward(
      id: 'r2', title: 'Journal Theme',
      description: 'Exclusive dark theme for your journal',
      pointsRequired: 300,
      status:  RewardStatus.claimed,
      icon:    Icons.palette_rounded,
      iconColor: _C.purple,  iconBg: _C.purpleBg,
      borderColor: _C.purple,  category: 'Customise',
    ),
    Reward(
      id: 'r3', title: 'Breathing Pack',
      description: 'Unlock 5 advanced breathing exercises',
      pointsRequired: 500,
      status:  RewardStatus.available,
      icon:    Icons.air_rounded,
      iconColor:  _C.olive,   iconBg: _C.oliveBg,
      borderColor: _C.olive, category: 'Wellness',
    ),
    Reward(
      id: 'r4', title: 'Streak Shield',
      description: 'Protect your streak for 1 missed day',
      pointsRequired: 750,
      status:  RewardStatus.available,
      icon:    Icons.shield_rounded,
      iconColor:_C.amber,   iconBg: _C.amberBg,
      borderColor: _C.amber, category: 'Special',
    ),
    Reward(
      id: 'r5', title: 'Nature Sounds',
      description: '20-min curated nature soundscape pack',
      pointsRequired: 900,
      status:  RewardStatus.locked,
      icon:    Icons.forest_rounded,
      iconColor: _C.cyan,    iconBg: _C.cyanBg,
      borderColor: _C.cyan, category: 'Wellness',
    ),
    Reward(
      id: 'r6', title: 'XP Booster',
      description: 'Double XP for 24 hours',
      pointsRequired: 1000,
      status:  RewardStatus.locked,
      icon:    Icons.bolt_rounded,
      iconColor: _C.rose,    iconBg: _C.roseBg,
      borderColor: _C.rose,  category: 'Special',
    ),
    Reward(
      id: 'r7', title: 'Premium Badge',
      description: 'Show off your Elite Wellness badge',
      pointsRequired: 1500,
      status:  RewardStatus.locked,
      icon:    Icons.workspace_premium_rounded,
      iconColor: _C.amber,   iconBg: _C.amberBg,
      borderColor: _C.amber,  category: 'Badge',
    ),
    Reward(
      id: 'r8', title: 'Tree Skin',
      description: 'Cherry blossom skin for your mental tree',
      pointsRequired: 2000,
      status:  RewardStatus.locked,
      icon:    Icons.park_rounded,
      iconColor:  _C.rose,    iconBg: _C.roseBg,
      borderColor: _C.rose, category: 'Customise',
    ),
    // Reward(
    //   id: 'r9', title: '',
    //   description: '',
    //   pointsRequired: ,
    //   status:  RewardStatus.locked,
    //   icon:    Icons.park_rounded,
    //   iconColor: _C.rose,    iconBg: _C.roseBg,
    //   borderColor: _C.rose,  category: 'Customise',
    // ),
  ];

  // ── Filter ────────────────────────────────────────────────────────────────
  int _tab = 0;
  final List<String> _tabs = ['All', 'Available', 'Claimed'];

  List<Reward> get _filtered {
    switch (_tab) {
      case 1:  return _rewards.where((r) => r.status == RewardStatus.available).toList();
      case 2:  return _rewards.where((r) => r.status == RewardStatus.claimed).toList();
      default: return _rewards;
    }
  }

  int get _claimedCount   => _rewards.where((r) => r.status == RewardStatus.claimed).length;
  int get _availableCount => _rewards.where((r) => r.status == RewardStatus.available).length;

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

  // ── Claim reward — calls backend API ─────────────────────────────────────
  Future<void> _claimReward(Reward reward) async {
    if (_claimingIds.contains(reward.id)) return;
    setState(() => _claimingIds.add(reward.id));

    try {
      // ── Replace with your real Node.js backend call ─────────────────────
      //
      // import 'dart:convert';
      // import 'package:http/http.dart' as http;
      //
      // final response = await http.post(
      //   Uri.parse('https://your-api.com/api/rewards/${reward.id}/claim'),
      //   headers: {
      //     'Content-Type':  'application/json',
      //     'Authorization': 'Bearer $userToken',
      //   },
      //   body: jsonEncode({
      //     'userId':   'user123',
      //     'rewardId': reward.id,
      //   }),
      // );
      // if (response.statusCode != 200) throw Exception('API error');
      // ────────────────────────────────────────────────────────────────────

      // Simulated delay — remove when using real API
      await Future.delayed(const Duration(milliseconds: 1200));

      setState(() {
        _userPoints -= reward.pointsRequired;
        _rewards = _rewards.map((r) {
          if (r.id == reward.id) return r.copyWith(status: RewardStatus.claimed);
          return r;
        }).toList();
      });

      if (mounted) _snack('Reward claimed! Enjoy your ${reward.title}.', ok: true);

    } catch (_) {
      if (mounted) _snack('Could not claim. Please try again.', ok: false);
    } finally {
      if (mounted) setState(() => _claimingIds.remove(reward.id));
    }
  }

  void _snack(String msg, {required bool ok}) {
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
      behavior:  SnackBarBehavior.floating,
      margin:    const EdgeInsets.all(14),
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
                child: Column(children: [
                  _buildBalanceCard(),
                  const SizedBox(height: 16),
                  _buildFilterTabs(),
                  const SizedBox(height: 16),
                  _buildGrid(),
                ]),
              ),
            ),
          ]),
        ),
      );

  // ── Teal Header (≈25%) ────────────────────────────────────────────────────
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
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 52),
            child: Column(children: [
              // Nav row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _hdrBtn(Icons.arrow_back_ios_new_rounded, 15,
                      () => Navigator.maybePop(context)),
                  Column(children: [
                    Text('REWARDS',
                        style: TextStyle(
                          fontSize:     10,
                          fontWeight:   FontWeight.w800,
                          color:        Colors.white.withOpacity(.6),
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

              const SizedBox(height: 18),

              // Summary pills
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _pill(Icons.star_rounded,
                      '$_userPoints pts balance'),
                  const SizedBox(width: 10),
                  _pill(Icons.check_circle_outline_rounded,
                      '$_claimedCount claimed'),
                  const SizedBox(width: 10),
                  _pill(Icons.lock_open_rounded,
                      '$_availableCount available'),
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

  // ── Points balance card (floats over header boundary) ─────────────────────
  Widget _buildBalanceCard() => Transform.translate(
        offset: const Offset(0, -32),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color:        _C.brand,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [BoxShadow(
                color: _C.brand.withOpacity(.30),
                blurRadius: 20, offset: const Offset(0, 8),
              )],
            ),
            child: Row(children: [
              // Left — balance
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(.24)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.account_balance_wallet_rounded,
                            color: Colors.white, size: 13),
                        const SizedBox(width: 5),
                        const Text('Points Balance',
                            style: TextStyle(
                              color:      Colors.white,
                              fontSize:   11,
                              fontWeight: FontWeight.w700,
                            )),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: _userPoints),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, val, child) => Text(
                      '$val',
                      style: const TextStyle(
                        fontSize:   42,
                        fontWeight: FontWeight.w900,
                        color:      Colors.white,
                        height:     1,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('total points',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(.55),
                      )),
                ],
              )),

              // Divider
              Container(
                width: 1, height: 80,
                color: Colors.white.withOpacity(.18),
                margin: const EdgeInsets.symmetric(horizontal: 18),
              ),

              // Right — quick stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _balanceStat(Icons.check_circle_rounded,
                      '$_claimedCount', 'Claimed'),
                  const SizedBox(height: 14),
                  _balanceStat(Icons.lock_open_rounded,
                      '$_availableCount', 'Available'),
                  const SizedBox(height: 14),
                  _balanceStat(Icons.lock_outline_rounded,
                      '${_rewards.where((r) => r.status == RewardStatus.locked).length}',
                      'Locked'),
                ],
              ),
            ]),
          ),
        ),
      );

  Widget _balanceStat(IconData icon, String val, String lbl) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.14),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 13),
        ),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(val,
              style: const TextStyle(
                fontSize:   14,
                fontWeight: FontWeight.w800,
                color:      Colors.white,
                height:     1,
              )),
          Text(lbl,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(.55),
              )),
        ]),
      ]);

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
              final sel = e.key == _tab;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _tab = e.key),
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

  // ── Rewards grid ──────────────────────────────────────────────────────────
  Widget _buildGrid() {
    final list = _filtered;
    if (list.isEmpty) return _buildEmpty();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap:  true,
        physics:     const NeverScrollableScrollPhysics(),
        itemCount:   list.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:   2,
          crossAxisSpacing: 12,
          mainAxisSpacing:  12,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, i) => _buildRewardCard(list[i]),
      ),
    );
  }

  Widget _buildEmpty() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(child: Column(children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
                color: _C.brandSoft, shape: BoxShape.circle),
            child: const Icon(Icons.card_giftcard_rounded,
                color: _C.brand, size: 30),
          ),
          const SizedBox(height: 14),
          const Text('Nothing here yet',
              style: TextStyle(
                fontSize:   15,
                fontWeight: FontWeight.w700,
                color:      _C.textDark,
              )),
          const SizedBox(height: 6),
          const Text('Earn more points to unlock rewards',
              style: TextStyle(fontSize: 12, color: _C.textMid)),
        ])),
      );

  // ── Single reward card ────────────────────────────────────────────────────
  Widget _buildRewardCard(Reward r) {
    final isClaimed   = r.status == RewardStatus.claimed;
    final isAvailable = r.status == RewardStatus.available;
    final isLocked    = r.status == RewardStatus.locked;
    final isClaiming  = _claimingIds.contains(r.id);
    final canAfford   = _userPoints >= r.pointsRequired;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isClaimed
            ? _C.brandFaint
            : isLocked
                ? _C.bg
                : _C.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isClaimed
              ? _C.brand.withOpacity(.25)
              : isAvailable
                  ? r.borderColor.withOpacity(.35)
                  : _C.border,
          width: isClaimed || isAvailable ? 1.5 : 1,
        ),
        boxShadow: isLocked
            ? []
            : [BoxShadow(
                color: _C.brand.withOpacity(.07),
                blurRadius: 14, offset: const Offset(0, 5),
              )],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Top — icon + category chip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon container
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: isLocked
                        ? _C.border
                        : isClaimed
                            ? _C.brand.withOpacity(.12)
                            : r.iconBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isLocked ? Icons.lock_outline_rounded : r.icon,
                    color: isLocked
                        ? _C.textLight
                        : isClaimed
                            ? _C.brand
                            : r.iconColor,
                    size: 24,
                  ),
                ),

                // Status chip
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isClaimed
                        ? _C.brandSoft
                        : isAvailable
                            ? r.iconBg
                            : _C.bg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isClaimed
                          ? _C.brand.withOpacity(.2)
                          : isAvailable
                              ? r.borderColor.withOpacity(.4)
                              : _C.border,
                    ),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      isClaimed
                          ? Icons.check_rounded
                          : isAvailable
                              ? Icons.lock_open_rounded
                              : Icons.lock_outline_rounded,
                      size: 10,
                      color: isClaimed
                          ? _C.brand
                          : isAvailable
                              ? r.iconColor
                              : _C.textLight,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      isClaimed
                          ? 'Claimed'
                          : isAvailable
                              ? 'Unlock'
                              : 'Locked',
                      style: TextStyle(
                        fontSize:   9,
                        fontWeight: FontWeight.w800,
                        color: isClaimed
                            ? _C.brand
                            : isAvailable
                                ? r.iconColor
                                : _C.textLight,
                      ),
                    ),
                  ]),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Category tag
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color:        _C.bg,
                borderRadius: BorderRadius.circular(6),
                border:       Border.all(color: _C.border),
              ),
              child: Text(r.category,
                  style: const TextStyle(
                    fontSize:   9,
                    fontWeight: FontWeight.w700,
                    color:      _C.textMid,
                    letterSpacing: .4,
                  )),
            ),

            const SizedBox(height: 8),

            // Title
            Text(r.title,
                style: TextStyle(
                  fontSize:   14,
                  fontWeight: FontWeight.w800,
                  color: isLocked ? _C.textLight : _C.textDark,
                  letterSpacing: -.2,
                )),
            const SizedBox(height: 4),

            // Description
            Expanded(
              child: Text(r.description,
                  style: const TextStyle(
                    fontSize: 11, color: _C.textMid, height: 1.4),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis),
            ),

            const SizedBox(height: 10),

            // Points cost
            Row(children: [
              const Icon(Icons.star_rounded,
                  size: 13, color: _C.amber),
              const SizedBox(width: 4),
              Text('${r.pointsRequired} pts',
                  style: TextStyle(
                    fontSize:   11,
                    fontWeight: FontWeight.w800,
                    color: isLocked ? _C.textLight : _C.amber,
                  )),
            ]),

            const SizedBox(height: 10),

            // Claim / claimed / locked button
            _buildActionButton(r, isAvailable, isClaimed,
                isLocked, isClaiming, canAfford),
          ],
        ),
      ),
    );
  }

  // ── Action button ─────────────────────────────────────────────────────────
  Widget _buildActionButton(
    Reward r,
    bool isAvailable,
    bool isClaimed,
    bool isLocked,
    bool isClaiming,
    bool canAfford,
  ) {
    if (isClaimed) {
      return Container(
        width:   double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color:        _C.brandSoft,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle_rounded, size: 13, color: _C.brand),
            SizedBox(width: 5),
            Text('Claimed',
                style: TextStyle(
                  fontSize:   11,
                  fontWeight: FontWeight.w800,
                  color:      _C.brand,
                )),
          ],
        ),
      );
    }

    if (isLocked) {
      return Container(
        width:   double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color:        _C.bg,
          borderRadius: BorderRadius.circular(11),
          border:       Border.all(color: _C.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.lock_outline_rounded, size: 13, color: _C.textLight),
            SizedBox(width: 5),
            Text('Locked',
                style: TextStyle(
                  fontSize:   11,
                  fontWeight: FontWeight.w700,
                  color:      _C.textLight,
                )),
          ],
        ),
      );
    }

    // Available — claim button
    return GestureDetector(
      onTap: isClaiming ? null : () => _claimReward(r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width:   double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: _C.brand,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [BoxShadow(
            color: _C.brand.withOpacity(.28),
            blurRadius: 10, offset: const Offset(0, 4),
          )],
        ),
        child: isClaiming
            ? const Center(
                child: SizedBox(
                  width: 14, height: 14,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.redeem_rounded,
                      size: 13, color: Colors.white),
                  SizedBox(width: 5),
                  Text('Claim Now',
                      style: TextStyle(
                        fontSize:   11,
                        fontWeight: FontWeight.w800,
                        color:      Colors.white,
                      )),
                ],
              ),
      ),
    );
  }
}