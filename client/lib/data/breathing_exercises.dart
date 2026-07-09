import 'package:flutter/material.dart';
import '../theme/mindbloom_theme.dart';

/// One phase of a breath cycle.
/// [endScale] is where the pacer circle animates TO during this phase:
/// 1.0 = fully expanded (lungs full), 0.55 = contracted (lungs empty).
class BreathPhase {
  final String label; // big text on screen: "Inhale"
  final String spoken; // what TTS says (can be longer than the label)
  final int seconds;
  final double endScale;

  const BreathPhase({
    required this.label,
    required this.spoken,
    required this.seconds,
    required this.endScale,
  });
}

class BreathingExercise {
  final String id;
  final String name;
  final String category; // section header on the hub screen
  final String tagline; // short line on the card
  final String description; // detail sheet text
  final String benefit; // "why it's great" line
  final String? safetyNote; // optional caution shown on the detail sheet
  final IconData icon;
  final Color tileColor;
  final Color iconColor;
  final List<BreathPhase> phases;

  /// If [cycleOptions] is set, the session runs N full cycles (e.g. 4-7-8).
  /// Otherwise [minuteOptions] gives the selectable session lengths.
  final List<int> minuteOptions;
  final List<int> cycleOptions;

  const BreathingExercise({
    required this.id,
    required this.name,
    required this.category,
    required this.tagline,
    required this.description,
    required this.benefit,
    this.safetyNote,
    required this.icon,
    required this.tileColor,
    required this.iconColor,
    required this.phases,
    this.minuteOptions = const [],
    this.cycleOptions = const [],
  });

  bool get isCycleBased => cycleOptions.isNotEmpty;

  int get secondsPerCycle => phases.fold<int>(0, (sum, p) => sum + p.seconds);
}

const String catCalmers = 'The Immediate Calmers';
const String catHealers = 'The Nervous System Healers';
const String catResetters = 'The Mental Resetters';

const List<BreathingExercise> breathingExercises = [
  // ── 1. PHYSIOLOGICAL SIGH ──────────────────────────────────────────
  BreathingExercise(
    id: 'physiological_sigh',
    name: 'The Physiological Sigh',
    category: catCalmers,
    tagline: 'Two quick inhales, one long sigh out.',
    description:
        'Take two quick inhales through the nose — the second one tops up the '
        'lungs — then release everything with one long sigh through the mouth.',
    benefit:
        'The fastest biological way to reduce stress arousal in real time.',
    icon: Icons.waves_rounded,
    tileColor: MBColors.breathingTile,
    iconColor: MBColors.breathingIcon,
    minuteOptions: [1, 2],
    phases: [
      BreathPhase(
        label: 'Inhale',
        spoken: 'Breathe in',
        seconds: 2,
        endScale: 0.85,
      ),
      BreathPhase(
        label: 'Inhale again',
        spoken: 'Again',
        seconds: 1,
        endScale: 1.0,
      ),
      BreathPhase(
        label: 'Sigh out',
        spoken: 'Sigh it all out',
        seconds: 6,
        endScale: 0.55,
      ),
    ],
  ),

  // ── 2. BOX BREATHING ───────────────────────────────────────────────
  BreathingExercise(
    id: 'box_breathing',
    name: 'Box Breathing',
    category: catCalmers,
    tagline: 'Inhale, hold, exhale, hold — 4 seconds each.',
    description:
        'A perfectly even 4-4-4-4 square of breath. Trace the four sides: '
        'in, hold, out, hold.',
    benefit:
        'Used by Navy SEALs to stay calm and focused under intense pressure.',
    icon: Icons.crop_square_rounded,
    tileColor: MBColors.meditationTile,
    iconColor: MBColors.meditationIcon,
    minuteOptions: [3, 5],
    phases: [
      BreathPhase(
        label: 'Inhale',
        spoken: 'Breathe in',
        seconds: 4,
        endScale: 1.0,
      ),
      BreathPhase(label: 'Hold', spoken: 'Hold', seconds: 4, endScale: 1.0),
      BreathPhase(
        label: 'Exhale',
        spoken: 'Breathe out',
        seconds: 4,
        endScale: 0.55,
      ),
      BreathPhase(label: 'Hold', spoken: 'Hold', seconds: 4, endScale: 0.55),
    ],
  ),

  // ── 3. 4-7-8 BREATHING ─────────────────────────────────────────────
  BreathingExercise(
    id: 'four_seven_eight',
    name: '4-7-8 Breathing',
    category: catHealers,
    tagline: 'In for 4, hold for 7, out for 8.',
    description:
        'Inhale quietly through the nose for 4 seconds, hold for 7, then '
        'exhale fully through the mouth with a whoosh for 8. Ideal at bedtime.',
    benefit: 'Acts as a natural tranquilizer by forcing long, slow exhales.',
    safetyNote:
        'Sit or lie down for this one. If you feel lightheaded, pause and '
        'breathe normally — that is completely okay.',
    icon: Icons.nightlight_round,
    tileColor: MBColors.audioTile,
    iconColor: MBColors.audioIcon,
    cycleOptions: [4, 8],
    phases: [
      BreathPhase(
        label: 'Inhale',
        spoken: 'Breathe in through your nose',
        seconds: 4,
        endScale: 1.0,
      ),
      BreathPhase(
        label: 'Hold',
        spoken: 'Hold your breath',
        seconds: 7,
        endScale: 1.0,
      ),
      BreathPhase(
        label: 'Exhale',
        spoken: 'Exhale slowly through your mouth',
        seconds: 8,
        endScale: 0.55,
      ),
    ],
  ),

  // ── 4. RESONANT (COHERENT) BREATHING ───────────────────────────────
  BreathingExercise(
    id: 'resonant',
    name: 'Resonant Breathing',
    category: catHealers,
    tagline: 'A smooth 5 seconds in, 5 seconds out.',
    description:
        'Breathe in for 5 seconds and out for 5 seconds, continuously and '
        'gently, like slow waves. Also called coherent breathing.',
    benefit:
        'Maximizes heart-rate variability, balancing and toning the vagus nerve.',
    icon: Icons.favorite_border_rounded,
    tileColor: MBColors.journalTile,
    iconColor: MBColors.journalIcon,
    minuteOptions: [5, 10],
    phases: [
      BreathPhase(
        label: 'Inhale',
        spoken: 'Breathe in',
        seconds: 5,
        endScale: 1.0,
      ),
      BreathPhase(
        label: 'Exhale',
        spoken: 'Breathe out',
        seconds: 5,
        endScale: 0.55,
      ),
    ],
  ),

  // ── 5. ALTERNATE NOSTRIL BREATHING ─────────────────────────────────
  BreathingExercise(
    id: 'alternate_nostril',
    name: 'Alternate Nostril Breathing',
    category: catResetters,
    tagline: 'Breathe through one nostril at a time.',
    description:
        'Nadi Shodhana: use your thumb and ring finger to close one nostril '
        'at a time, alternating sides. Follow the voice — your hand will be busy!',
    benefit: 'Restores balance between brain hemispheres and lowers anxiety.',
    icon: Icons.swap_horiz_rounded,
    tileColor: MBColors.mindfeedTile,
    iconColor: MBColors.mindfeedIcon,
    minuteOptions: [3, 5],
    phases: [
      BreathPhase(
        label: 'Inhale left',
        spoken: 'Close your right nostril. Breathe in through the left',
        seconds: 4,
        endScale: 1.0,
      ),
      BreathPhase(
        label: 'Switch · Exhale right',
        spoken: 'Switch. Breathe out through the right',
        seconds: 5,
        endScale: 0.55,
      ),
      BreathPhase(
        label: 'Inhale right',
        spoken: 'Breathe in through the right',
        seconds: 4,
        endScale: 1.0,
      ),
      BreathPhase(
        label: 'Switch · Exhale left',
        spoken: 'Switch. Breathe out through the left',
        seconds: 5,
        endScale: 0.55,
      ),
    ],
  ),

  // ── 6. STRAW BREATH ────────────────────────────────────────────────
  BreathingExercise(
    id: 'straw_breath',
    name: 'The Straw Breath',
    category: catResetters,
    tagline: 'Exhale gently, as if through a straw.',
    description:
        'Breathe in normally through the nose, then exhale slowly through '
        'pursed lips as if blowing softly through a straw.',
    benefit: 'Naturally lengthens the exhale to quickly lower blood pressure.',
    icon: Icons.air_rounded,
    tileColor: MBColors.breathingTile,
    iconColor: MBColors.breathingIcon,
    minuteOptions: [2, 3],
    phases: [
      BreathPhase(
        label: 'Inhale',
        spoken: 'Breathe in gently',
        seconds: 4,
        endScale: 1.0,
      ),
      BreathPhase(
        label: 'Straw exhale',
        spoken: 'Blow out slowly, like through a straw',
        seconds: 8,
        endScale: 0.55,
      ),
    ],
  ),
];
