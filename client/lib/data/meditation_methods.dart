import 'package:flutter/material.dart';
import '../theme/mindbloom_theme.dart';

/// One spoken/displayed instruction inside a session.
///
/// Two timing modes:
///  - Looping methods: every step has [fixedSeconds] and the sequence
///    repeats until the session time runs out.
///  - Phased methods (all current ones): each step has a [weight] and the
///    session time (5 or 10 min) is divided proportionally, so the same
///    script works for both durations.
class MeditationStep {
  final String instruction;
  final double weight; // used when the method is phase-based
  final int fixedSeconds; // used when the method loops

  const MeditationStep(
    this.instruction, {
    this.weight = 1,
    this.fixedSeconds = 0,
  });
}

class MeditationMethod {
  final String id;
  final String name;
  final String tagline; // short line shown on the card
  final String description; // longer text on the detail sheet
  final IconData icon;
  final Color tileColor;
  final Color iconColor;
  final bool loopSteps; // true → steps cycle with fixedSeconds each
  final List<MeditationStep> steps;
  final String image; // session illustration shown inside the breathing ring

  const MeditationMethod({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.icon,
    required this.tileColor,
    required this.iconColor,
    this.loopSteps = false,
    required this.steps,
    this.image = 'assets/images/meditation_hero.png',
  });
}

const List<MeditationMethod> meditationMethods = [
  // 1 ─ PROGRESSIVE MUSCLE RELAXATION ────────────────────────────────
  MeditationMethod(
    id: 'pmr',
    name: 'Progressive Muscle Relaxation',
    tagline: 'Tense and release from toe to head.',
    description:
        'Work upward through the body, tensing each muscle group for a few '
        'seconds and then letting go completely, to release hidden physical tension.',
    icon: Icons.accessibility_new_rounded,
    tileColor: MBColors.meditationTile,
    iconColor: MBColors.meditationIcon,
    image: 'assets/images/pmr.jpg',
    steps: [
      MeditationStep(
        'Sit or lie down comfortably. Take three slow, deep breaths.',
        weight: 1,
      ),
      MeditationStep(
        'Curl your toes tightly... hold... and release. Feel your feet soften.',
        weight: 1.2,
      ),
      MeditationStep(
        'Tense your calves... hold the tension... now let it all go.',
        weight: 1.2,
      ),
      MeditationStep(
        'Squeeze your thigh muscles... hold... and release completely.',
        weight: 1.2,
      ),
      MeditationStep(
        'Tighten your stomach... hold... and let it relax.',
        weight: 1.2,
      ),
      MeditationStep(
        'Make fists with your hands... squeeze... and release your fingers.',
        weight: 1.2,
      ),
      MeditationStep(
        'Tense your arms and shoulders up to your ears... hold... and drop them.',
        weight: 1.2,
      ),
      MeditationStep(
        'Scrunch your face gently... hold... and let your face go soft.',
        weight: 1.2,
      ),
      MeditationStep(
        'Notice your whole body now, heavy and relaxed. Breathe slowly.',
        weight: 1.4,
      ),
      MeditationStep(
        'Take one last deep breath in... and out. Gently open your eyes.',
        weight: 0.8,
      ),
    ],
  ),

  // 2 ─ 5-4-3-2-1 GROUNDING ──────────────────────────────────────────
  MeditationMethod(
    id: 'grounding_54321',
    name: '5-4-3-2-1 Grounding',
    tagline: 'Use your five senses to break panic loops.',
    description:
        'Anchor yourself in the present moment by naming things you can see, '
        'feel, hear, smell and taste. A fast way to interrupt anxious spirals.',
    icon: Icons.spa_rounded,
    tileColor: MBColors.mindfeedTile,
    iconColor: MBColors.mindfeedIcon,
    image: 'assets/images/grounding.jpg',
    steps: [
      MeditationStep(
        'Take a slow breath. Let your shoulders drop.',
        weight: 0.8,
      ),
      MeditationStep(
        'Look around and silently name five things you can see.',
        weight: 1.4,
      ),
      MeditationStep(
        'Notice four things you can feel — your clothes, the chair, the air.',
        weight: 1.3,
      ),
      MeditationStep(
        'Listen carefully. Name three sounds you can hear.',
        weight: 1.2,
      ),
      MeditationStep(
        'Notice two things you can smell, or two smells you like.',
        weight: 1,
      ),
      MeditationStep('Notice one thing you can taste.', weight: 0.8),
      MeditationStep(
        'Take a deep breath. You are here, and you are safe.',
        weight: 1,
      ),
    ],
  ),

  // 3 ─ BODY SCAN ────────────────────────────────────────────────────
  MeditationMethod(
    id: 'body_scan',
    name: 'Body Scan',
    tagline: 'Sweep through the body and breathe into tightness.',
    description:
        'Move your attention slowly through the body, finding areas of hidden '
        'tightness and breathing space into them.',
    icon: Icons.self_improvement_rounded,
    tileColor: MBColors.meditationTile,
    iconColor: MBColors.meditationIcon,
    image: 'assets/images/body_scan.jpg',
    steps: [
      MeditationStep(
        'Close your eyes. Take three slow breaths and settle in.',
        weight: 1,
      ),
      MeditationStep(
        'Bring your attention to the top of your head and your face. Soften your jaw.',
        weight: 1.2,
      ),
      MeditationStep(
        'Move down to your neck and shoulders. Breathe into any tightness.',
        weight: 1.2,
      ),
      MeditationStep(
        'Notice your chest rising and falling. Let each breath slow down.',
        weight: 1.2,
      ),
      MeditationStep(
        'Bring awareness to your stomach and lower back. Let them soften.',
        weight: 1.2,
      ),
      MeditationStep(
        'Feel your hips and legs, heavy and supported.',
        weight: 1.2,
      ),
      MeditationStep(
        'Move down to your feet. Feel them grounded and warm.',
        weight: 1,
      ),
      MeditationStep(
        'Now feel your whole body at once, breathing as one.',
        weight: 1.2,
      ),
      MeditationStep(
        'Slowly wiggle your fingers and toes, and open your eyes.',
        weight: 0.8,
      ),
    ],
  ),

  // 4 ─ LOVING-KINDNESS (METTA) ──────────────────────────────────────
  MeditationMethod(
    id: 'metta',
    name: 'Loving-Kindness (Metta)',
    tagline: 'Repeat phrases of safety and peace.',
    description:
        'Quiet emotional distress and self-judgment by silently repeating '
        'phrases of kindness — first for yourself, then for others.',
    icon: Icons.favorite_rounded,
    tileColor: MBColors.journalTile,
    iconColor: MBColors.journalIcon,
    image: 'assets/images/loving_kindness2.jpg',
    steps: [
      MeditationStep(
        'Sit comfortably, place a hand on your heart, and breathe slowly.',
        weight: 1,
      ),
      MeditationStep(
        'Silently repeat: May I be safe. May I be peaceful. May I be kind to myself.',
        weight: 1.6,
      ),
      MeditationStep(
        'Picture someone you love. Repeat: May you be safe. May you be peaceful.',
        weight: 1.4,
      ),
      MeditationStep(
        'Picture someone neutral — a stranger. Wish them the same peace.',
        weight: 1.2,
      ),
      MeditationStep(
        'If you can, picture someone difficult. Gently wish them peace too.',
        weight: 1.2,
      ),
      MeditationStep(
        'Extend the feeling to all beings: May everyone be safe and at ease.',
        weight: 1.2,
      ),
      MeditationStep(
        'Return to your own breath. Notice the warmth you created.',
        weight: 0.8,
      ),
    ],
  ),

  // 5 ─ OPEN MONITORING ──────────────────────────────────────────────
  MeditationMethod(
    id: 'open_monitoring',
    name: 'Open Monitoring',
    tagline: 'Watch thoughts pass like clouds.',
    description:
        'Sit quietly and simply observe whatever arises — thoughts, sounds, '
        'feelings — without judging or reacting to any of it.',
    icon: Icons.cloud_outlined,
    tileColor: MBColors.audioTile,
    iconColor: MBColors.audioIcon,
    image: 'assets/images/open_monitoring.png',
    steps: [
      MeditationStep(
        'Sit tall but relaxed. Let your breathing settle into its own rhythm.',
        weight: 1,
      ),
      MeditationStep(
        'Let your attention rest open. Notice whatever appears — a thought, a sound.',
        weight: 1.4,
      ),
      MeditationStep(
        'When a thought arrives, simply watch it drift past like a cloud.',
        weight: 1.4,
      ),
      MeditationStep(
        'No thought needs fixing. Nothing needs your reaction. Just observe.',
        weight: 1.4,
      ),
      MeditationStep(
        'If you get carried away, gently return to watching. That is the practice.',
        weight: 1.4,
      ),
      MeditationStep(
        'Rest in this open awareness a little longer.',
        weight: 1.2,
      ),
      MeditationStep(
        'Slowly bring your attention back to the room, and open your eyes.',
        weight: 0.8,
      ),
    ],
  ),
];
