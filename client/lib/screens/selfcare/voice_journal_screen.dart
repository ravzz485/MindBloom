import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../theme/mindbloom_theme.dart';
import '../../services/journal_service.dart';
import '../../services/emotion_engine.dart';
import 'journal_result_screen.dart';

/// Voice journal — speak your thoughts, we write them down.
/// Uses the device's on-board speech recognition. The transcript is
/// editable before saving, then flows into the same emotion analysis
/// and recommendations as the other journaling modes.
class VoiceJournalScreen extends StatefulWidget {
  final String userId;
  const VoiceJournalScreen({super.key, required this.userId});

  @override
  State<VoiceJournalScreen> createState() => _VoiceJournalScreenState();
}

class _VoiceJournalScreenState extends State<VoiceJournalScreen> {
  final SpeechToText _speech = SpeechToText();
  final TextEditingController _controller = TextEditingController();

  bool _available = false; // does the device support speech recognition?
  bool _listening = false;
  bool _saving = false;
  String _mood = 'neutral';
  String _sessionText = ''; // text confirmed in previous listen sessions

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // This also triggers the microphone permission popup the first time.
    final ok = await _speech.initialize(
      onStatus: (status) {
        // The engine auto-stops after a pause; reflect that in the UI.
        if (status == 'notListening' && mounted) {
          setState(() => _listening = false);
        }
      },
      onError: (_) {
        if (mounted) setState(() => _listening = false);
      },
    );
    if (mounted) setState(() => _available = ok);
  }

  Future<void> _toggleListening() async {
    if (!_available) return;
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }
    // Keep whatever is in the box (spoken earlier or typed edits).
    _sessionText = _controller.text.trim();
    setState(() => _listening = true);
    await _speech.listen(
      listenOptions: SpeechListenOptions(partialResults: true),
      pauseFor: const Duration(seconds: 4),
      listenFor: const Duration(minutes: 2),
      onResult: (result) {
        final spoken = result.recognizedWords;
        setState(() {
          _controller.text = _sessionText.isEmpty
              ? spoken
              : '$_sessionText $spoken';
          _controller.selection = TextSelection.collapsed(
            offset: _controller.text.length,
          );
        });
      },
    );
  }

  Future<void> _save() async {
    await _speech.stop();
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speak or type something first 🌱')),
      );
      return;
    }
    setState(() => _saving = true);
    final ok = await JournalService.saveEntry(
      userId: widget.userId,
      entry: text,
      mood: _mood,
      prompt: 'voice',
    );
    setState(() => _saving = false);
    if (!mounted) return;
    if (ok) {
      final result = EmotionEngine.analyze(text, _mood);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => JournalResultScreen(result: result)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not reach the server — is it running? Not saved.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MBColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
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
                  const Text(
                    'Voice journal',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: MBColors.darkGreen,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 48),
                child: Text(
                  'Tap the mic and speak freely. You can edit before saving.',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: MBColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Mood chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kMoods.map((m) {
                  final selected = _mood == m.$2;
                  return GestureDetector(
                    onTap: () => setState(() => _mood = m.$2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? MBColors.meditationTile
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? MBColors.meditationIcon
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        '${m.$1} ${m.$2}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: MBColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Big mic button
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _toggleListening,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _listening ? 110 : 96,
                        height: _listening ? 110 : 96,
                        decoration: BoxDecoration(
                          color: _listening
                              ? Colors.redAccent
                              : MBColors.darkGreen,
                          shape: BoxShape.circle,
                          boxShadow: _listening
                              ? [
                                  BoxShadow(
                                    color: Colors.redAccent.withOpacity(0.35),
                                    blurRadius: 30,
                                    spreadRadius: 8,
                                  ),
                                ]
                              : [],
                        ),
                        child: Icon(
                          _listening ? Icons.stop_rounded : Icons.mic_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      !_available
                          ? 'Speech recognition unavailable on this device'
                          : _listening
                          ? 'Listening... tap to stop'
                          : 'Tap to speak',
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: MBColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Transcript (editable)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: 8,
                  style: const TextStyle(
                    color: MBColors.textPrimary,
                    height: 1.6,
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Your words appear here — edit freely...',
                    hintStyle: TextStyle(color: MBColors.textSecondary),
                    contentPadding: EdgeInsets.all(18),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MBColors.darkGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.check_rounded),
                  label: Text(
                    _saving ? 'Saving...' : 'Save entry',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
