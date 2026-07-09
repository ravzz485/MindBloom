import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/mindfeed_content.dart';
import '../../theme/mindbloom_theme.dart';

/// MindFeed — a positive social-style wall with 4 tabs:
/// 🫙 Memory Jar · 💚 Self Love · 🎥 TED Talks · 🌿 Wellness Tips
class MindFeedScreen extends StatefulWidget {
  final int initialTab; // 0 = Memory Jar (used by "Positive Memories")
  const MindFeedScreen({super.key, this.initialTab = 0});

  @override
  State<MindFeedScreen> createState() => _MindFeedScreenState();
}

class _MindFeedScreenState extends State<MindFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: widget.initialTab,
      child: Scaffold(
        backgroundColor: MBColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: MBColors.darkGreen,
                      ),
                    ),
                    const Text(
                      'MindFeed',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: MBColors.darkGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const TabBar(
                isScrollable: true,
                labelColor: MBColors.darkGreen,
                unselectedLabelColor: MBColors.textSecondary,
                indicatorColor: MBColors.darkGreen,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: '🫙 Memory Jar'),
                  Tab(text: '💚 Self Love'),
                  Tab(text: '🎥 TED Talks'),
                  Tab(text: '🌿 Wellness'),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    _MemoryJarTab(),
                    _SelfLoveTab(),
                    _TedTalksTab(),
                    _WellnessTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 🫙 MEMORY JAR ────────────────────────────────────────────────────
class _MemoryJarTab extends StatefulWidget {
  const _MemoryJarTab();
  @override
  State<_MemoryJarTab> createState() => _MemoryJarTabState();
}

class _MemoryJarTabState extends State<_MemoryJarTab> {
  final TextEditingController _controller = TextEditingController();
  List<String> _memories = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() => _memories = p.getStringList('memory_jar') ?? []);
  }

  Future<void> _add() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final now = DateTime.now();
    final dated = '$text|${now.day}/${now.month}/${now.year}';
    final p = await SharedPreferences.getInstance();
    _memories.insert(0, dated);
    await p.setStringList('memory_jar', _memories);
    _controller.clear();
    FocusScope.of(context).unfocus();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Memory dropped into the jar 🫙✨')),
    );
  }

  void _openJar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: MBColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your memories 🫙',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: MBColors.darkGreen,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _memories.isEmpty
                    ? const Center(
                        child: Text(
                          'The jar is empty — add your first memory!',
                          style: TextStyle(color: MBColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        controller: controller,
                        itemCount: _memories.length,
                        itemBuilder: (_, i) {
                          final parts = _memories[i].split('|');
                          final text = parts[0];
                          final date = parts.length > 1 ? parts[1] : '';
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: MBColors.journalTile,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  text,
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    height: 1.4,
                                    color: MBColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  date,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: MBColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Drop a happy memory into your jar.\nOpen it whenever you need a smile.',
            textAlign: TextAlign.center,
            style: TextStyle(color: MBColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 20),

          // The jar (tap to open)
          GestureDetector(
            onTap: _openJar,
            child: Column(
              children: [
                // lid
                Container(
                  width: 90,
                  height: 18,
                  decoration: BoxDecoration(
                    color: MBColors.darkGreen,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 3),
                // body
                Container(
                  width: 150,
                  height: 170,
                  decoration: BoxDecoration(
                    color: MBColors.breathingTile.withOpacity(0.6),
                    border: Border.all(
                      color: MBColors.darkGreen.withOpacity(0.4),
                      width: 2.5,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(44),
                      bottomRight: Radius.circular(44),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('✨', style: TextStyle(fontSize: 30)),
                      const SizedBox(height: 6),
                      Text(
                        '${_memories.length}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: MBColors.darkGreen,
                        ),
                      ),
                      const Text(
                        'memories',
                        style: TextStyle(
                          fontSize: 13,
                          color: MBColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap the jar to read them',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: MBColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: TextField(
              controller: _controller,
              maxLines: 3,
              minLines: 1,
              style: const TextStyle(color: MBColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Write a happy memory...',
                hintStyle: TextStyle(color: MBColors.textSecondary),
                contentPadding: EdgeInsets.all(14),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _add,
              style: ElevatedButton.styleFrom(
                backgroundColor: MBColors.darkGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Drop into the jar',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 💚 SELF LOVE ─────────────────────────────────────────────────────
class _SelfLoveTab extends StatelessWidget {
  const _SelfLoveTab();

  static const List<Color> _cardColors = [
    MBColors.meditationTile,
    MBColors.journalTile,
    MBColors.breathingTile,
    MBColors.audioTile,
    MBColors.mindfeedTile,
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: selfLoveAffirmations.length,
      itemBuilder: (_, i) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: _cardColors[i % _cardColors.length],
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Text(
            selfLoveAffirmations[i],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Caveat',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: MBColors.darkGreen,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}

// ── 🎥 TED TALKS ─────────────────────────────────────────────────────
class _TedTalksTab extends StatelessWidget {
  const _TedTalksTab();

  Future<void> _openTalk(BuildContext context, TedTalk talk) async {
    if (talk.url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Link coming soon — search "${talk.title}" on YouTube'),
        ),
      );
      return;
    }
    final uri = Uri.parse(talk.url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open the link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        for (final cat in tedCategories) ...[
          Text(
            '${cat.emoji} ${cat.name}',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: MBColors.darkGreen,
            ),
          ),
          const SizedBox(height: 10),
          ...cat.talks.map(
            (talk) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => _openTalk(context, talk),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.redAccent,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                talk.title,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: MBColors.textPrimary,
                                  height: 1.3,
                                ),
                              ),
                              Text(
                                talk.speaker,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: MBColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.open_in_new_rounded,
                          size: 18,
                          color: MBColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}

// ── 🌿 WELLNESS TIPS ─────────────────────────────────────────────────
class _WellnessTab extends StatelessWidget {
  const _WellnessTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: wellnessTips.length,
      itemBuilder: (_, i) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          wellnessTips[i],
          style: const TextStyle(
            fontSize: 14.5,
            height: 1.4,
            color: MBColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
