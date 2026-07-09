import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../data/breathing_exercises.dart';
import '../../theme/mindbloom_theme.dart';
import '../../services/calm_voice.dart';

/// Guided breathing session with a visual breath pacer:
/// a circle that expands as you inhale and contracts as you exhale.
class BreathingSessionScreen extends StatefulWidget {
  final BreathingExercise exercise;
  final int? minutes; // set for time-based sessions
  final int? cycles; // set for cycle-based sessions (4-7-8)

  const BreathingSessionScreen({
    super.key,
    required this.exercise,
    this.minutes,
    this.cycles,
  });

  @override
  State<BreathingSessionScreen> createState() => _BreathingSessionScreenState();
}

class _BreathingSessionScreenState extends State<BreathingSessionScreen> {
  Timer? _timer;

  int _phaseIndex = 0; // which phase of the cycle we're in
  int _phaseSecondsLeft = 0; // countdown within the current phase
  int _elapsed = 0; // total seconds elapsed
  int _cyclesDone = 0;

  bool _running = false;
  bool _finished = false;
  bool _voiceOn = true;

  final FlutterTts _tts = FlutterTts();

  BreathingExercise get ex => widget.exercise;

  int get _totalSeconds => widget.cycles != null
      ? widget.cycles! * ex.secondsPerCycle
      : widget.minutes! * 60;

  int get _totalCycles =>
      widget.cycles ?? (_totalSeconds ~/ ex.secondsPerCycle);

  @override
  void initState() {
    super.initState();
    CalmVoice.configure(_tts);
    _startPhase(0, speak: true);
    _start();
  }

  void _startPhase(int index, {required bool speak}) {
    _phaseIndex = index;
    _phaseSecondsLeft = ex.phases[index].seconds;
    if (speak && _voiceOn) {
      _tts.stop();
      _tts.speak(ex.phases[index].spoken);
    }
    HapticFeedback.lightImpact(); // gentle pulse on phones; no-op on web
    setState(() {});
  }

  void _start() {
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    _elapsed++;
    _phaseSecondsLeft--;

    if (_phaseSecondsLeft <= 0) {
      // Move to the next phase (or next cycle).
      int next = _phaseIndex + 1;
      if (next >= ex.phases.length) {
        next = 0;
        _cyclesDone++;
        final done = widget.cycles != null
            ? _cyclesDone >= widget.cycles!
            : _elapsed >= _totalSeconds;
        if (done) {
          _complete();
          return;
        }
      }
      _startPhase(next, speak: true);
    } else {
      setState(() {});
    }
  }

  void _pauseResume() {
    if (_finished) return;
    if (_running) {
      _timer?.cancel();
      _tts.stop();
      setState(() => _running = false);
    } else {
      _start();
    }
  }

  void _toggleVoice() {
    setState(() => _voiceOn = !_voiceOn);
    if (!_voiceOn) _tts.stop();
  }

  void _complete() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _finished = true;
    });
    if (_voiceOn) _tts.speak('Well done. Notice how much calmer you feel.');
    // TODO(team): log completion / call the rate endpoint here later.
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: MBColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Session complete 🌬️',
          style: TextStyle(
            color: MBColors.darkGreen,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'You completed $_cyclesDone cycles of ${ex.name}. '
          'Take a moment to notice how your body feels.',
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
    final phase = ex.phases[_phaseIndex];

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
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ex.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                Text(
                  widget.cycles != null
                      ? 'Cycle ${(_cyclesDone + 1).clamp(1, _totalCycles)} of $_totalCycles'
                      : '$_timeLeft remaining',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
                const Spacer(),

                // ── The breath pacer ──────────────────────────────
                SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // faint outer ring = full expansion reference
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                            width: 2,
                          ),
                        ),
                      ),
                      // the animated circle: grows on inhale, shrinks on exhale
                      AnimatedScale(
                        scale: phase.endScale,
                        duration: Duration(seconds: phase.seconds),
                        curve: Curves.easeInOut,
                        child: Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.35),
                                Colors.white.withOpacity(0.12),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.8),
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                      // phase label + per-second count
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              phase.label,
                              key: ValueKey('${_phaseIndex}_$_cyclesDone'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$_phaseSecondsLeft',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                Text(
                  ex.tagline,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const Spacer(),

                // Controls: voice · play/pause · end
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
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _running
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: MBColors.darkGreen,
                          size: 42,
                        ),
                      ),
                    ),
                    _roundControl(
                      icon: Icons.stop_rounded,
                      label: 'End',
                      active: false,
                      onTap: _complete,
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
              color: active
                  ? Colors.white.withOpacity(0.22)
                  : Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(active ? 0.9 : 0.3),
                width: 1.5,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}
