import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/soundscapes.dart';
import '../../theme/mindbloom_theme.dart';

/// Shared audio state so the mini-bar and full player stay in sync.
class AudioService {
  static final AudioPlayer player = AudioPlayer();
  static final ValueNotifier<AudioTrack?> current = ValueNotifier(null);
  static final ValueNotifier<bool> playing = ValueNotifier(false);

  static Future<void> play(AudioTrack t) async {
    current.value = t;
    await player.stop();
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource('audio/${t.assetFile}'));
    playing.value = true;
    _saveRecent(t.id);
  }

  static Future<void> toggle() async {
    if (playing.value) {
      await player.pause();
      playing.value = false;
    } else {
      await player.resume();
      playing.value = true;
    }
  }

  static Future<void> _saveRecent(String id) async {
    final p = await SharedPreferences.getInstance();
    final list = p.getStringList('recent_tracks') ?? [];
    list.remove(id);
    list.insert(0, id);
    await p.setStringList('recent_tracks', list.take(6).toList());
  }

  static Future<List<AudioTrack>> recent() async {
    final p = await SharedPreferences.getInstance();
    final ids = p.getStringList('recent_tracks') ?? [];
    return ids
        .map((id) => audioTracks.where((t) => t.id == id).firstOrNull)
        .whereType<AudioTrack>()
        .toList();
  }
}

class RelaxingAudioScreen extends StatefulWidget {
  const RelaxingAudioScreen({super.key});
  @override
  State<RelaxingAudioScreen> createState() => _RelaxingAudioScreenState();
}

class _RelaxingAudioScreenState extends State<RelaxingAudioScreen> {
  List<AudioTrack> _recent = [];

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final r = await AudioService.recent();
    if (mounted) setState(() => _recent = r);
  }

  void _openPlayer(AudioTrack t, {bool startPlaying = true}) async {
    if (startPlaying) await AudioService.play(t);
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AudioPlayerScreen()),
    );
    _loadRecent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MBColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: MBColors.darkGreen,
                          ),
                        ),
                        const Icon(
                          Icons.local_florist_rounded,
                          color: MBColors.darkGreen,
                          size: 22,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Mind Bloom',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: MBColors.darkGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Relaxing Audio',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: MBColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Find your soundscape and drift into tranquility.',
                      style: TextStyle(
                        fontSize: 15,
                        color: MBColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Category grid 2×3
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.35,
                      children: audioCategories.map((c) {
                        return Material(
                          color: MBColors.card,
                          borderRadius: BorderRadius.circular(22),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(22),
                            onTap: () => _showCategory(c),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: c.tileColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      c.icon,
                                      color: c.iconColor,
                                      size: 24,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    c.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: MBColors.textPrimary,
                                    ),
                                  ),
                                  const Text(
                                    '2 Tracks',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: MBColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    if (_recent.isNotEmpty) ...[
                      const Text(
                        'Recently Played',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: MBColors.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._recent.map((t) => _trackTile(t)),
                    ],
                  ],
                ),
              ),
            ),
            _miniPlayer(),
          ],
        ),
      ),
    );
  }

  void _showCategory(AudioCategory c) {
    final tracks = audioTracks.where((t) => t.categoryId == c.id).toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: MBColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              c.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: MBColors.darkGreen,
              ),
            ),
            const SizedBox(height: 12),
            ...tracks.map((t) => _trackTile(t, popSheetFirst: true)),
          ],
        ),
      ),
    );
  }

  Widget _trackTile(AudioTrack t, {bool popSheetFirst = false}) {
    final cat = audioCategories.firstWhere((c) => c.id == t.categoryId);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: popSheetFirst ? MBColors.background : MBColors.card,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            if (popSheetFirst) Navigator.pop(context);
            _openPlayer(t);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: cat.tileColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(cat.icon, color: cat.iconColor, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: MBColors.textPrimary,
                        ),
                      ),
                      Text(
                        cat.name,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: MBColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: const BoxDecoration(
                    color: MBColors.darkGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Now Playing bar — docked at the bottom, ABOVE any nav.
  Widget _miniPlayer() {
    return ValueListenableBuilder<AudioTrack?>(
      valueListenable: AudioService.current,
      builder: (_, track, __) {
        if (track == null) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () => _openPlayer(track, startPlaying: false),
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: MBColors.darkGreen,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.music_note_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'NOW PLAYING',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 10,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: AudioService.playing,
                  builder: (_, playing, __) => IconButton(
                    onPressed: AudioService.toggle,
                    icon: Icon(
                      playing
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_filled_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Spotify-style full player.
class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});
  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  Duration _pos = Duration.zero, _dur = Duration.zero;
  StreamSubscription? _p, _d;

  @override
  void initState() {
    super.initState();
    _p = AudioService.player.onPositionChanged.listen(
      (d) => setState(() => _pos = d),
    );
    _d = AudioService.player.onDurationChanged.listen(
      (d) => setState(() => _dur = d),
    );
  }

  @override
  void dispose() {
    _p?.cancel();
    _d?.cancel();
    super.dispose();
  }

  void _skip(int dir) {
    final t = AudioService.current.value;
    if (t == null) return;
    final list = audioTracks
        .where((x) => x.categoryId == t.categoryId)
        .toList();
    final i = list.indexWhere((x) => x.id == t.id);
    AudioService.play(list[(i + dir + list.length) % list.length]);
  }

  String _fmt(Duration d) =>
      '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AudioTrack?>(
      valueListenable: AudioService.current,
      builder: (_, track, __) {
        if (track == null) return const SizedBox.shrink();
        final cat = audioCategories.firstWhere((c) => c.id == track.categoryId);
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [MBColors.darkGreen, MBColors.deepGreen],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            cat.name.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 3,
                        ),
                      ),
                      child: Icon(cat.icon, color: Colors.white, size: 90),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      track.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      cat.name,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Slider(
                      value: _pos.inSeconds
                          .clamp(0, _dur.inSeconds == 0 ? 1 : _dur.inSeconds)
                          .toDouble(),
                      max: (_dur.inSeconds == 0 ? 1 : _dur.inSeconds)
                          .toDouble(),
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withOpacity(0.25),
                      onChanged: (v) => AudioService.player.seek(
                        Duration(seconds: v.toInt()),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _fmt(_pos),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _fmt(_dur),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () => _skip(-1),
                          icon: const Icon(
                            Icons.skip_previous_rounded,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: AudioService.playing,
                          builder: (_, playing, __) => GestureDetector(
                            onTap: AudioService.toggle,
                            child: Container(
                              width: 76,
                              height: 76,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                playing
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: MBColors.darkGreen,
                                size: 42,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _skip(1),
                          icon: const Icon(
                            Icons.skip_next_rounded,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
