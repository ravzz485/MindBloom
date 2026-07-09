import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final List<Map<String, dynamic>> methods = [
    {
      'title': 'Box Breathing',
      'description':
          'Inhale, hold, exhale, and hold for 4 seconds each to instantly lower heart rate.',
      'icon': Icons.air,
      'color': const Color(0xFF1B6B6E),
      'steps5': [
        'Find a comfortable seated position',
        'Inhale slowly for 4 seconds',
        'Hold your breath for 4 seconds',
        'Exhale slowly for 4 seconds',
        'Hold for 4 seconds before next breath',
        'Repeat 4 times',
      ],
      'steps10': [
        'Find a comfortable seated position and close your eyes',
        'Take a natural breath to settle in',
        'Inhale slowly through your nose for 4 seconds',
        'Hold your breath gently for 4 seconds',
        'Exhale slowly through your mouth for 4 seconds',
        'Hold empty for 4 seconds',
        'Feel your body relax with each cycle',
        'Notice your heart rate slowing down',
        'Repeat for 8 full cycles',
        'Slowly open your eyes when ready',
      ],
    },
    {
      'title': 'Progressive Muscle Relaxation',
      'description':
          'Tense and release muscle groups from toe to head to dump physical tension.',
      'icon': Icons.self_improvement,
      'color': const Color(0xFF174143),
      'steps5': [
        'Lie down or sit comfortably',
        'Tense your feet for 5 seconds then release',
        'Tense your legs for 5 seconds then release',
        'Tense your stomach for 5 seconds then release',
        'Tense your hands and arms then release',
        'Take a deep breath and relax completely',
      ],
      'steps10': [
        'Lie down in a comfortable position',
        'Close your eyes and take 3 deep breaths',
        'Curl your toes tightly for 5 seconds then release',
        'Tense your calves for 5 seconds then release',
        'Tense your thighs for 5 seconds then release',
        'Tense your stomach muscles then release',
        'Tense your chest and back then release',
        'Make fists with both hands then release',
        'Tense your shoulders up to your ears then release',
        'Scrunch your face tightly then release completely',
      ],
    },
    {
      'title': '5-4-3-2-1 Grounding',
      'description':
          'Name environmental sights, feelings, sounds, smells, and tastes to break panic loops.',
      'icon': Icons.landscape,
      'color': const Color(0xFF2D8B8E),
      'steps5': [
        'Pause and breathe deeply',
        'Name 5 things you can SEE around you',
        'Name 4 things you can TOUCH or FEEL',
        'Name 3 things you can HEAR right now',
        'Name 2 things you can SMELL',
        'Name 1 thing you can TASTE',
      ],
      'steps10': [
        'Stop what you are doing and breathe slowly',
        'Look around and really notice your environment',
        'Name 5 specific things you can SEE in detail',
        'Reach out and touch 4 surfaces near you',
        'Describe the texture of each thing you touch',
        'Close your eyes and identify 3 sounds you hear',
        'Take a slow breath and identify 2 smells',
        'Notice 1 taste in your mouth',
        'Take 3 slow deep breaths',
        'Notice how much calmer you feel now',
      ],
    },
    {
      'title': 'Body Scan',
      'description':
          'Mentally sweep through the body to locate and breathe into hidden physical tightness.',
      'icon': Icons.accessibility_new,
      'color': const Color(0xFF174143),
      'steps5': [
        'Lie down and close your eyes',
        'Breathe naturally and relax',
        'Scan from head to toe mentally',
        'Notice any areas of tension',
        'Breathe into tense areas and release',
        'Rest in full body awareness',
      ],
      'steps10': [
        'Lie down in a comfortable position',
        'Close your eyes and breathe naturally',
        'Bring attention to the top of your head',
        'Slowly move awareness to your forehead and face',
        'Scan down through your neck and shoulders',
        'Notice your chest rising and falling with breath',
        'Move awareness to your stomach and lower back',
        'Scan through your hips and thighs',
        'Move down through your knees and calves',
        'Rest awareness at your feet and breathe deeply',
      ],
    },
    {
      'title': 'Loving-Kindness (Metta)',
      'description':
          'Repeat phrases of safety and peace to quiet emotional distress and self-judgment.',
      'icon': Icons.favorite,
      'color': const Color(0xFF1B6B6E),
      'steps5': [
        'Sit comfortably and close your eyes',
        'Say: May I be safe and protected',
        'Say: May I be healthy and strong',
        'Say: May I be happy and peaceful',
        'Extend these wishes to someone you love',
        'Extend these wishes to all beings',
      ],
      'steps10': [
        'Sit comfortably with your hands on your heart',
        'Close your eyes and breathe gently',
        'Picture yourself and smile inwardly',
        'Repeat: May I be safe and protected',
        'Repeat: May I be healthy and strong',
        'Repeat: May I be happy and at peace',
        'Picture someone you love and send them the same wishes',
        'Picture a neutral person and send them kindness',
        'Expand to include all people everywhere',
        'Rest in the warmth of loving kindness',
      ],
    },
    {
      'title': 'Open Monitoring',
      'description':
          'Sit quietly and observe thoughts pass like clouds without reacting to them.',
      'icon': Icons.cloud,
      'color': const Color(0xFF2D8B8E),
      'steps5': [
        'Sit comfortably and close your eyes',
        'Breathe naturally without controlling it',
        'Notice thoughts as they arise',
        'Let them pass like clouds in the sky',
        'Return to open awareness each time',
        'End with 3 deep breaths',
      ],
      'steps10': [
        'Find a quiet place and sit comfortably',
        'Close your eyes and relax your body',
        'Begin breathing naturally',
        'Imagine your mind is a clear open sky',
        'Notice each thought that arises',
        'Label it gently: thinking, feeling, remembering',
        'Let it drift away like a cloud',
        'Do not follow or resist any thought',
        'Return to open sky awareness each time',
        'Slowly open your eyes and carry this awareness with you',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF174143),
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.self_improvement, color: Colors.white),
            SizedBox(width: 8),
            Text('Meditation',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: methods.length,
        itemBuilder: (context, index) {
          final method = methods[index];
          return _MeditationCard(method: method);
        },
      ),
    );
  }
}

class _MeditationCard extends StatelessWidget {
  final Map<String, dynamic> method;

  const _MeditationCard({required this.method});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: method['color'] as Color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    method['icon'] as IconData,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        method['description'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _DurationButton(
                    duration: '5 min',
                    steps: method['steps5'] as List<String>,
                    color: method['color'] as Color,
                    title: method['title'],
                    secondsPerStep: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DurationButton(
                    duration: '10 min',
                    steps: method['steps10'] as List<String>,
                    color: method['color'] as Color,
                    title: method['title'],
                    secondsPerStep: 60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationButton extends StatelessWidget {
  final String duration;
  final List<String> steps;
  final Color color;
  final String title;
  final int secondsPerStep;

  const _DurationButton({
    required this.duration,
    required this.steps,
    required this.color,
    required this.title,
    required this.secondsPerStep,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _MeditationSessionScreen(
            title: title,
            duration: duration,
            steps: steps,
            color: color,
            secondsPerStep: secondsPerStep,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(Icons.timer, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              duration,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              'Session',
              style: TextStyle(
                color: color.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeditationSessionScreen extends StatefulWidget {
  final String title;
  final String duration;
  final List<String> steps;
  final Color color;
  final int secondsPerStep;

  const _MeditationSessionScreen({
    required this.title,
    required this.duration,
    required this.steps,
    required this.color,
    required this.secondsPerStep,
  });

  @override
  State<_MeditationSessionScreen> createState() =>
      _MeditationSessionScreenState();
}

class _MeditationSessionScreenState extends State<_MeditationSessionScreen> {
  final FlutterTts _tts = FlutterTts();
  int _currentStep = 0;
  int _secondsLeft = 0;
  bool _isRunning = false;
  bool _isCompleted = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.secondsPerStep;
    _setupTts();
  }

  Future<void> _setupTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(0.9);
  }

  void _startSession() {
    setState(() => _isRunning = true);
    _speakAndStartTimer(_currentStep);
  }

  void _speakAndStartTimer(int stepIndex) async {
    if (stepIndex >= widget.steps.length) {
      _completeSession();
      return;
    }
    setState(() {
      _currentStep = stepIndex;
      _secondsLeft = widget.secondsPerStep;
    });
    await _tts.speak(widget.steps[stepIndex]);
    _startStepTimer();
  }

  void _startStepTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          timer.cancel();
          if (_currentStep < widget.steps.length - 1) {
            _speakAndStartTimer(_currentStep + 1);
          } else {
            _completeSession();
          }
        }
      });
    });
  }

  void _completeSession() async {
    _timer?.cancel();
    await _tts.speak(
        'Session complete. Well done. Take a moment to appreciate yourself.');
    setState(() {
      _isCompleted = true;
      _isRunning = false;
    });
  }

  void _pauseResume() {
    if (_isRunning) {
      _timer?.cancel();
      _tts.stop();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _speakAndStartTimer(_currentStep);
    }
  }

  void _nextStep() {
    _timer?.cancel();
    _tts.stop();
    if (_currentStep < widget.steps.length - 1) {
      _speakAndStartTimer(_currentStep + 1);
    } else {
      _completeSession();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _isCompleted
        ? 1.0
        : (_currentStep / widget.steps.length);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F4),
      appBar: AppBar(
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        title: Text(
          '${widget.title} • ${widget.duration}',
          style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _isCompleted
            ? _buildCompletedView()
            : _isRunning || _currentStep > 0
                ? _buildSessionView(progress)
                : _buildStartView(),
      ),
    );
  }

  Widget _buildStartView() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              const Icon(Icons.self_improvement,
                  color: Colors.white, size: 80),
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.duration} • ${widget.steps.length} Steps',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Voice guidance + Timer included',
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Steps Preview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF174143),
          ),
        ),
        const SizedBox(height: 12),
        ...widget.steps.asMap().entries.map((e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${e.key + 1}',
                        style: TextStyle(
                          color: widget.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      e.value,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _startSession,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionView(double progress) {
    return Column(
      children: [
        const SizedBox(height: 20),

        // Progress bar
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step ${_currentStep + 1} of ${widget.steps.length}',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13),
                  ),
                  Text(
                    widget.duration,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white30,
                  valueColor:
                      const AlwaysStoppedAnimation(Colors.white),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Current step card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.record_voice_over,
                  color: widget.color, size: 40),
              const SizedBox(height: 16),
              Text(
                widget.steps[_currentStep],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  color: Color(0xFF174143),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Countdown timer
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: _secondsLeft / widget.secondsPerStep,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(widget.color),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '$_secondsLeft',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                        ),
                      ),
                      const Text(
                        'seconds',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Controls
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _pauseResume,
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                label: Text(_isRunning ? 'Pause' : 'Resume'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: const Color(0xFF174143),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _nextStep,
                icon: const Icon(Icons.skip_next),
                label: const Text('Next Step'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // All steps list
        const Text(
          'All Steps',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF174143),
          ),
        ),
        const SizedBox(height: 12),
        ...widget.steps.asMap().entries.map((e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: e.key == _currentStep
                    ? widget.color.withOpacity(0.1)
                    : e.key < _currentStep
                        ? Colors.green.shade50
                        : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: e.key == _currentStep
                      ? widget.color
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: e.key < _currentStep
                          ? Colors.green
                          : e.key == _currentStep
                              ? widget.color
                              : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      e.key < _currentStep
                          ? Icons.check
                          : Icons.circle,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      e.value,
                      style: TextStyle(
                        fontSize: 13,
                        color: e.key <= _currentStep
                            ? const Color(0xFF174143)
                            : Colors.grey,
                        fontWeight: e.key == _currentStep
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildCompletedView() {
    return Column(
      children: [
        const SizedBox(height: 60),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 80),
              SizedBox(height: 16),
              Text(
                'Session Complete!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Well done! Take a moment\nto appreciate yourself.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.home),
            label: const Text('Back to Meditation'),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}