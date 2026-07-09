import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/mindbloom_theme.dart';
import 'journal_entries_screen.dart';

/// PIN gate for journal entries.
/// First visit → create a 4-digit PIN (entered twice).
/// After that → enter the PIN to unlock "My entries".
class PinLockScreen extends StatefulWidget {
  final String userId;
  const PinLockScreen({super.key, required this.userId});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  static const _prefsKey = 'journal_pin';

  String? _savedPin; // null until loaded; '' means no PIN set yet
  String _input = '';
  String? _firstEntry; // during setup: the first of the two entries
  String _message = '';
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPin = prefs.getString(_prefsKey) ?? '';
      _message = _savedPin!.isEmpty
          ? 'Create a 4-digit PIN to protect your journal'
          : 'Enter your PIN to unlock your journal';
    });
  }

  bool get _settingUp => _savedPin != null && _savedPin!.isEmpty;

  void _tapDigit(String d) {
    if (_input.length >= 4) return;
    setState(() {
      _input += d;
      _error = false;
    });
    if (_input.length == 4) _submit();
  }

  void _backspace() {
    if (_input.isEmpty) return;
    setState(() => _input = _input.substring(0, _input.length - 1));
  }

  Future<void> _submit() async {
    // Small pause so the 4th dot is visible before we react.
    await Future.delayed(const Duration(milliseconds: 200));

    if (_settingUp) {
      if (_firstEntry == null) {
        setState(() {
          _firstEntry = _input;
          _input = '';
          _message = 'Enter the same PIN again to confirm';
        });
      } else if (_firstEntry == _input) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_prefsKey, _input);
        _unlock();
      } else {
        setState(() {
          _firstEntry = null;
          _input = '';
          _error = true;
          _message = 'PINs didn\'t match — let\'s start over';
        });
      }
    } else {
      if (_input == _savedPin) {
        _unlock();
      } else {
        setState(() {
          _input = '';
          _error = true;
          _message = 'Wrong PIN — try again';
        });
      }
    }
  }

  void _unlock() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => JournalEntriesScreen(userId: widget.userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_savedPin == null) {
      return const Scaffold(
        backgroundColor: MBColors.background,
        body: Center(
          child: CircularProgressIndicator(color: MBColors.darkGreen),
        ),
      );
    }

    return Scaffold(
      backgroundColor: MBColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: MBColors.darkGreen,
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: MBColors.meditationTile,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _settingUp
                    ? Icons.lock_open_rounded
                    : Icons.lock_outline_rounded,
                size: 34,
                color: MBColors.meditationIcon,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              _settingUp ? 'Set your PIN' : 'Journal locked',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: MBColors.darkGreen,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: _error ? Colors.redAccent : MBColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // PIN dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final filled = i < _input.length;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: filled ? 18 : 14,
                  height: filled ? 18 : 14,
                  decoration: BoxDecoration(
                    color: filled ? MBColors.darkGreen : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _error ? Colors.redAccent : MBColors.darkGreen,
                      width: 2,
                    ),
                  ),
                );
              }),
            ),
            const Spacer(),

            // Keypad
            for (final row in const [
              ['1', '2', '3'],
              ['4', '5', '6'],
              ['7', '8', '9'],
              ['', '0', '<'],
            ])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((key) {
                    if (key.isEmpty) {
                      return const SizedBox(width: 76, height: 76);
                    }
                    final isBack = key == '<';
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Material(
                        color: isBack ? Colors.transparent : Colors.white,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: isBack ? _backspace : () => _tapDigit(key),
                          child: SizedBox(
                            width: 76,
                            height: 76,
                            child: Center(
                              child: isBack
                                  ? const Icon(
                                      Icons.backspace_outlined,
                                      color: MBColors.darkGreen,
                                    )
                                  : Text(
                                      key,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600,
                                        color: MBColors.darkGreen,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
