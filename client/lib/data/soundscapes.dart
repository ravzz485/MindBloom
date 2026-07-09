import 'package:flutter/material.dart';
import '../theme/mindbloom_theme.dart';

class AudioCategory {
  final String id, name;
  final IconData icon;
  final Color tileColor, iconColor;
  const AudioCategory(
    this.id,
    this.name,
    this.icon,
    this.tileColor,
    this.iconColor,
  );
}

class AudioTrack {
  final String id, title, categoryId, assetFile;
  const AudioTrack(this.id, this.title, this.categoryId, this.assetFile);
}

const List<AudioCategory> audioCategories = [
  AudioCategory(
    'nature',
    'Nature',
    Icons.forest_rounded,
    MBColors.meditationTile,
    MBColors.meditationIcon,
  ),
  AudioCategory(
    'sleep',
    'Sleep',
    Icons.nightlight_round,
    MBColors.audioTile,
    MBColors.audioIcon,
  ),
  AudioCategory(
    'focus',
    'Focus',
    Icons.center_focus_strong_rounded,
    MBColors.breathingTile,
    MBColors.breathingIcon,
  ),
  AudioCategory(
    'meditation',
    'Meditation',
    Icons.self_improvement_rounded,
    MBColors.mindfeedTile,
    MBColors.mindfeedIcon,
  ),
  AudioCategory(
    'wellness',
    'Wellness',
    Icons.spa_rounded,
    MBColors.journalTile,
    MBColors.journalIcon,
  ),
  AudioCategory(
    'ambient',
    'Ambient',
    Icons.cloud_outlined,
    MBColors.breathingTile,
    MBColors.breathingIcon,
  ),
];

// EDIT THE TITLES to match your real tracks. File names must match Step 1.
const List<AudioTrack> audioTracks = [
  AudioTrack('nature_1', 'Morning Forest Birds', 'nature', 'nature_1.mp3'),
  AudioTrack('nature_2', 'Gentle Brook Stream', 'nature', 'nature_2.mp3'),
  AudioTrack('sleep_1', 'Deep Sleep Waves', 'sleep', 'sleep_1.mp3'),
  AudioTrack('sleep_2', 'Night White Noise', 'sleep', 'sleep_2.mp3'),
  AudioTrack('focus_1', 'Study Lofi Calm', 'focus', 'focus_1.mp3'),
  AudioTrack('focus_2', 'Soft Focus Beats', 'focus', 'focus_2.mp3'),
  AudioTrack('meditation_1', 'Still Mind', 'meditation', 'meditation_1.mp3'),
  AudioTrack('meditation_2', 'Inner Peace', 'meditation', 'meditation_2.mp3'),
  AudioTrack('wellness_1', 'Healing Tones', 'wellness', 'wellness_1.mp3'),
  AudioTrack('wellness_2', 'Morning Renewal', 'wellness', 'wellness_2.mp3'),
  AudioTrack('ambient_1', 'Soft Clouds', 'ambient', 'ambient_1.mp3'),
  AudioTrack('ambient_2', 'Evening Air', 'ambient', 'ambient_2.mp3'),
];
