import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../data/meditation_methods.dart';
import '../../theme/mindbloom_theme.dart';
import '../../services/calm_voice.dart';

/// Meditation session — light, airy design distinct from breathing:
///  - soft sage gradient background, dark green text
///  - centered meditation illustration with a BREATHING RING around it
///    (grows 4s in, holds 2s, shrinks 6s — loops all session long)
///  - thin progress line + time remaining at the top
///  - calm voice guidance + ducked background music
class MeditationSessionScreen extends StatefulWidget {
  final MeditationMethod method;
  final int durationMinutes;

  const MeditationSessionScreen({
    super.key,
    required this.method,
    required this.durationMinutes,
  });

  @override
  State<MeditationSessionScreen> createState() =>
      _MeditationSessionScreenState();
}

class _TimedStep {
  final String instruction;
  final int startSecond;
  _TimedStep(this.instruction, this.startSecond);
}

/// One phase of the ambient breathing ring.
class _BreathPhase {
  final String label;
  final int seconds;
  final double scale;
  const _BreathPhase(this.label, this.seconds, this.scale);
}

class _MeditationSessionScreenState extends State<MeditationSessionScreen> {
  static const double _musicNormal = 0.30;
  static const double _musicDucked = 0.08;

  // Gentle 4-2-6 rhythm for the ring, looping through the session.
  static const List<_BreathPhase> _breathCycle = [
    _BreathPhase('Breathe in', 4, 1.0),
    _BreathPhase('Hold', 2, 1.0),
    _BreathPhase('Breathe out', 6, 0.72),
  ];

  late final int _totalSeconds;
  late final List<_TimedStep> _timeline;

  Timer? _timer;
  int _elapsed = 0;
  int _currentStepIndex = -1;
  bool _running = false;
  bool _finished = false;

  // Breathing ring state
  int _breathIndex = 0;
  int _breathSecondsLeft = _breathCycle[0].seconds;

  bool _voiceOn = true;
  bool _musicOn = true;

  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _music = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.durationMinutes * 60;
    _timeline = _buildTimeline();
    _initAudio();
    _start();
  }

  List<_TimedStep> _buildTimeline() {
    final steps = widget.method.steps;
    final timeline = <_TimedStep>[];

    if (widget.method.loopSteps) {
      int t = 0, i = 0;
      while (t < _totalSeconds) {
        final step = steps[i % steps.length];
        timeline.add(_TimedStep(step.instruction, t));
        t += step.fixedSeconds;
        i++;
      }
    } else {
      final totalWeight = steps.fold<double>(0, (sum, s) => sum + s.weight);
      double t = 0;
      for (final s in steps) {
        timeline.add(_TimedStep(s.instruction, t.round()));
        t += _totalSeconds * (s.weight / totalWeight);
      }
    }
    return timeline;
  }

  Future<void> _initAudio() async {
    await CalmVoice.configure(_tts);
    _tts.setCompletionHandler(() {
      if (_musicOn && !widget.method.loopSteps) {
        _music.setVolume(_musicNormal);
      }
    });
    await _music.setReleaseMode(ReleaseMode.loop);
    await _music.setVolume(widget.method.loopSteps ? 0.15 : _musicNormal);
    if (_musicOn) {
      try {
        await _music.play(AssetSource('audio/meditation_music.mp3'));
      } catch (_) {}
    }
  }

  Future<void> _speak(String text) async {
    if (_musicOn && !widget.method.loopSteps) {
      await _music.setVolume(_musicDucked);
    }
    await _tts.stop();
    await _tts.speak(text);
  }

  void _start() {
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    _tick();
  }

  void _tick() {
    if (_elapsed >= _totalSeconds) {
      _complete();
      return;
    }

    // Advance the guidance timeline.
    int idx = _currentStepIndex;
    for (int i = _timeline.length - 1; i >= 0; i--) {
      if (_elapsed >= _timeline[i].startSecond) {
        idx = i;
        break;
      }
    }
    if (idx != _currentStepIndex) {
      _currentStepIndex = idx;
      if (_voiceOn) _speak(_timeline[idx].instruction);
    }

    // Advance the breathing ring.
    _breathSecondsLeft--;
    if (_breathSecondsLeft <= 0) {
      _breathIndex = (_breathIndex + 1) % _breathCycle.length;
      _breathSecondsLeft = _breathCycle[_breathIndex].seconds;
    }

    setState(() => _elapsed++);
  }

  void _pauseResume() {
    if (_finished) return;
    if (_running) {
      _timer?.cancel();
      _tts.stop();
      _music.pause();
      setState(() => _running = false);
    } else {
      if (_musicOn) {
        _music.setVolume(widget.method.loopSteps ? 0.15 : _musicNormal);
        _music.resume();
      }
      _start();
    }
  }

  void _toggleVoice() {
    setState(() => _voiceOn = !_voiceOn);
    if (!_voiceOn) {
      _tts.stop();
      if (_musicOn) _music.setVolume(_musicNormal);
    }
  }

  Future<void> _toggleMusic() async {
    setState(() => _musicOn = !_musicOn);
    if (_musicOn) {
      try {
        await _music.setVolume(_musicNormal);
        await _music.play(AssetSource('audio/meditation_music.mp3'));
      } catch (_) {}
    } else {
      await _music.stop();
    }
  }

  void _complete() {
    _timer?.cancel();
    _tts.stop();
    setState(() {
      _running = false;
      _finished = true;
    });
    if (_voiceOn) _speak('Well done. Your session is complete.');
    Future.delayed(const Duration(seconds: 6), () => _music.stop());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: MBColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Session complete 🌿',
          style: TextStyle(
            color: MBColors.darkGreen,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'You finished ${widget.durationMinutes} minutes of ${widget.method.name}. '
          'Take a moment to notice how you feel.',
          style: const TextStyle(color: MBColors.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text(
              'Done',
              style: TextStyle(color: MBColors.darkGreen),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tts.stop();
    _music.dispose();
    super.dispose();
  }

  String get _timeLeft {
    final remaining = (_totalSeconds - _elapsed).clamp(0, _totalSeconds);
    final m = remaining ~/ 60;
    final s = remaining % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_elapsed / _totalSeconds).clamp(0.0, 1.0);
    final instruction = _currentStepIndex >= 0
        ? _timeline[_currentStepIndex].instruction
        : 'Get comfortable...';
    final breath = _breathCycle[_breathIndex];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3F8F4), Color(0xFFDDEEDF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                // Top bar
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: MBColors.darkGreen,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.method.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: MBColors.darkGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 4),

                // Thin progress line + time
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    color: MBColors.darkGreen,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_timeLeft remaining · ${widget.durationMinutes} min session',
                  style: const TextStyle(
                    color: MBColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),

                // ── Illustration with breathing ring ─────────────
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // faint outer reference ring
                      Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: MBColors.darkGreen.withOpacity(0.10),
                            width: 2,
                          ),
                        ),
                      ),
                      // the breathing ring
                      AnimatedScale(
                        scale: breath.scale,
                        duration: Duration(seconds: breath.seconds),
                        curve: Curves.easeInOut,
                        child: Container(
                          width: 270,
                          height: 270,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: MBColors.meditationIcon.withOpacity(0.7),
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: MBColors.meditationIcon.withOpacity(
                                  0.18,
                                ),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // the illustration (falls back to an icon if missing)
                      ClipOval(
                        child: Container(
                          width: 190,
                          height: 190,
                          color: Colors.white,
                          child: Image.asset(
                            widget.method.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.self_improvement_rounded,
                              size: 96,
                              color: MBColors.meditationIcon,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Breath hint
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    breath.label,
                    key: ValueKey(_breathIndex),
                    style: TextStyle(
                      color: MBColors.darkGreen.withOpacity(0.55),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Current instruction
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  child: Text(
                    instruction,
                    key: ValueKey(instruction),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: MBColors.darkGreen,
                      fontSize: 18,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),

                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _roundControl(
                      icon: _voiceOn
                          ? Icons.record_voice_over_rounded
                          : Icons.voice_over_off_rounded,
                      label: 'Voice',
                      active: _voiceOn,
                      onTap: _toggleVoice,
                    ),
                    GestureDetector(
                      onTap: _pauseResume,
                      child: Container(
                        width: 78,
                        height: 78,
                        decoration: const BoxDecoration(
                          color: MBColors.darkGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _running
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                    ),
                    _roundControl(
                      icon: _musicOn
                          ? Icons.music_note_rounded
                          : Icons.music_off_rounded,
                      label: 'Music',
                      active: _musicOn,
                      onTap: _toggleMusic,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roundControl({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: active ? Colors.white : Colors.white.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: MBColors.darkGreen.withOpacity(active ? 0.8 : 0.25),
                width: 1.5,
              ),
            ),
            child: Icon(icon, color: MBColors.darkGreen, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: MBColors.textSecondary,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}
