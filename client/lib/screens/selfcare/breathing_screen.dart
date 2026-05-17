import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/selfcare_service.dart';

class BreathingScreen extends StatefulWidget {
  final String riskLevel;

  const BreathingScreen({super.key, required this.riskLevel});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? pattern;
  bool isLoading = true;
  bool isRunning = false;
  int currentStep = 0;
  int currentCycle = 0;
  int timeLeft = 0;
  Timer? timer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    loadPattern();
  }

  Future<void> loadPattern() async {
    try {
      final data = await SelfcareService.getBreathingPattern(widget.riskLevel);
      setState(() {
        pattern = data;
        isLoading = false;
        if (pattern != null && pattern!['steps'].isNotEmpty) {
          timeLeft = pattern!['steps'][0]['duration'];
        }
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void startExercise() {
    setState(() {
      isRunning = true;
      currentStep = 0;
      currentCycle = 0;
      timeLeft = pattern!['steps'][0]['duration'];
    });
    runStep();
  }

  void runStep() {
    final steps = pattern!['steps'] as List;
    final step = steps[currentStep];
    final duration = step['duration'] as int;

    setState(() => timeLeft = duration);

    if (step['action'] == 'Inhale') {
      _animationController.duration = Duration(seconds: duration);
      _animationController.forward();
    } else if (step['action'] == 'Exhale') {
      _animationController.duration = Duration(seconds: duration);
      _animationController.reverse();
    }

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => timeLeft--);
      if (timeLeft <= 0) {
        t.cancel();
        nextStep();
      }
    });
  }

  void nextStep() {
    final steps = pattern!['steps'] as List;
    final totalCycles = pattern!['cycles'] as int;

    if (currentStep < steps.length - 1) {
      setState(() => currentStep++);
      runStep();
    } else {
      if (currentCycle < totalCycles - 1) {
        setState(() {
          currentCycle++;
          currentStep = 0;
        });
        runStep();
      } else {
        setState(() => isRunning = false);
        _animationController.reset();
        showCompletionDialog();
      }
    }
  }

  void stopExercise() {
    timer?.cancel();
    _animationController.reset();
    setState(() {
      isRunning = false;
      currentStep = 0;
      currentCycle = 0;
    });
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Well done!'),
        content: const Text(
            'You completed the breathing exercise. How do you feel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Better'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              startExercise();
            },
            child: const Text('Do it again'),
          ),
        ],
      ),
    );
  }

  Color getStepColor(String action) {
    switch (action) {
      case 'Inhale':
        return Colors.blue.shade400;
      case 'Exhale':
        return Colors.green.shade400;
      case 'Hold':
        return Colors.orange.shade400;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        foregroundColor: Colors.white,
        title: const Text('Breathing Exercise'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pattern == null
              ? const Center(child: Text('Could not load pattern'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Pattern name
                      Text(
                        pattern!['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pattern!['description'],
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14),
                      ),
                      const SizedBox(height: 40),

                      // Animated circle
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            width: 200 * _animation.value,
                            height: 200 * _animation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isRunning
                                  ? getStepColor(
                                          pattern!['steps'][currentStep]
                                              ['action'])
                                      .withOpacity(0.3)
                                  : Colors.blue.shade100,
                              border: Border.all(
                                color: isRunning
                                    ? getStepColor(
                                        pattern!['steps'][currentStep]
                                            ['action'])
                                    : Colors.blue.shade300,
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isRunning
                                        ? pattern!['steps'][currentStep]
                                            ['action']
                                        : 'Ready',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: isRunning
                                          ? getStepColor(
                                              pattern!['steps'][currentStep]
                                                  ['action'])
                                          : Colors.blue.shade400,
                                    ),
                                  ),
                                  if (isRunning)
                                    Text(
                                      '$timeLeft',
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: getStepColor(
                                            pattern!['steps'][currentStep]
                                                ['action']),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Instruction
                      if (isRunning)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            pattern!['steps'][currentStep]['instruction'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Cycle info
                      if (isRunning)
                        Text(
                          'Cycle ${currentCycle + 1} of ${pattern!['cycles']}',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 14),
                        ),
                      const SizedBox(height: 32),

                      // Steps overview
                      const Text(
                        'Steps',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        (pattern!['steps'] as List).length,
                        (i) {
                          final step = pattern!['steps'][i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isRunning && currentStep == i
                                  ? getStepColor(step['action'])
                                      .withOpacity(0.15)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isRunning && currentStep == i
                                    ? getStepColor(step['action'])
                                    : Colors.grey.shade200,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color:
                                        getStepColor(step['action']),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${i + 1}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        step['action'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        step['instruction'],
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${step['duration']}s',
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Start/Stop button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              isRunning ? stopExercise : startExercise,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isRunning
                                ? Colors.red.shade400
                                : Colors.blue.shade400,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            isRunning ? 'Stop Exercise' : 'Start Exercise',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}