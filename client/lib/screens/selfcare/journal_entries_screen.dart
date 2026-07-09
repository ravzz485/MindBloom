import 'package:flutter/material.dart';
import '../../theme/mindbloom_theme.dart';
import '../../services/journal_service.dart';

/// Past journal entries, newest first. (PIN lock arrives in Phase 4.)
class JournalEntriesScreen extends StatefulWidget {
  final String userId;
  const JournalEntriesScreen({super.key, required this.userId});

  @override
  State<JournalEntriesScreen> createState() => _JournalEntriesScreenState();
}

class _JournalEntriesScreenState extends State<JournalEntriesScreen> {
  List<Map<String, dynamic>> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = await JournalService.fetchEntries(widget.userId);
    if (!mounted) return;
    setState(() {
      _entries = entries;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MBColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: MBColors.darkGreen,
                    ),
                  ),
                  const Text(
                    'My entries',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: MBColors.darkGreen,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: MBColors.darkGreen,
                      ),
                    )
                  : _entries.isEmpty
                  ? const Center(
                      child: Text(
                        'No entries yet.\nYour journal history will appear here.\n\n(If you saved entries but see nothing,\ncheck that your server is running.)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MBColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: _entries.length,
                      itemBuilder: (_, i) => _entryCard(_entries[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entryCard(Map<String, dynamic> e) {
    final mood = (e['mood'] ?? '').toString();
    final emoji = kMoods
        .firstWhere((m) => m.$2 == mood, orElse: () => ('📝', ''))
        .$1;
    final date = (e['createdAt'] ?? '').toString().split('T').first;
    final mode = (e['prompt'] ?? '').toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$emoji $mood',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: MBColors.darkGreen,
                ),
              ),
              if (mode == 'guided') ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: MBColors.journalTile,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'guided',
                    style: TextStyle(fontSize: 11, color: MBColors.journalIcon),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: MBColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            (e['entry'] ?? e['text'] ?? '').toString(),
            style: const TextStyle(color: MBColors.textPrimary, height: 1.5),
          ),
        ],
      ),
    );
  }
}
