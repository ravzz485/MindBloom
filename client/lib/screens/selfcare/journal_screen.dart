import 'package:flutter/material.dart';
import '../../services/selfcare_service.dart';

class JournalScreen extends StatefulWidget {
  final String userId;

  const JournalScreen({super.key, required this.userId});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _entryController = TextEditingController();
  String selectedMood = 'neutral';
  String selectedPrompt = '';
  List<dynamic> prompts = [];
  List<dynamic> journalEntries = [];
  bool isLoading = false;
  bool isSaving = false;
  bool showHistory = false;

  final List<Map<String, dynamic>> moods = [
    {'label': 'Happy', 'value': 'happy', 'emoji': '😊', 'color': Colors.yellow},
    {'label': 'Calm', 'value': 'calm', 'emoji': '😌', 'color': Colors.green},
    {
      'label': 'Neutral',
      'value': 'neutral',
      'emoji': '😐',
      'color': Colors.grey,
    },
    {
      'label': 'Anxious',
      'value': 'anxious',
      'emoji': '😰',
      'color': Colors.orange,
    },
    {'label': 'Sad', 'value': 'sad', 'emoji': '😢', 'color': Colors.blue},
    {
      'label': 'Stressed',
      'value': 'stressed',
      'emoji': '😤',
      'color': Colors.red,
    },
  ];

  @override
  void initState() {
    super.initState();
    loadPrompts();
    loadJournalEntries();
  }

  Future<void> loadPrompts() async {
    try {
      final data = await SelfcareService.getJournalPrompts(selectedMood);
      setState(() {
        prompts = data;
        selectedPrompt = data.isNotEmpty ? data[0] : '';
      });
    } catch (e) {
      // handle error
    }
  }

  Future<void> loadJournalEntries() async {
    try {
      final data = await SelfcareService.getJournalEntries(widget.userId);
      setState(() => journalEntries = data);
    } catch (e) {
      // handle error
    }
  }

  Future<void> saveEntry() async {
    if (_entryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something first')),
      );
      return;
    }

    setState(() => isSaving = true);
    try {
      await SelfcareService.saveJournalEntry(
        widget.userId,
        _entryController.text.trim(),
        selectedMood,
        prompt: selectedPrompt,
      );
      _entryController.clear();
      await loadJournalEntries();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Journal entry saved!'),
            backgroundColor: Color(0xFF4CAF82),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save entry')));
      }
    }
    setState(() => isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FF),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade400,
        foregroundColor: Colors.white,
        title: const Text('Journal'),
        actions: [
          TextButton(
            onPressed: () => setState(() => showHistory = !showHistory),
            child: Text(
              showHistory ? 'Write' : 'History',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: showHistory ? _buildHistory() : _buildWriteView(),
    );
  }

  Widget _buildWriteView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How are you feeling?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: moods.length,
              itemBuilder: (context, index) {
                final mood = moods[index];
                final isSelected = selectedMood == mood['value'];
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedMood = mood['value']);
                    loadPrompts();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (mood['color'] as Color).withOpacity(0.2)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? mood['color'] as Color
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          mood['emoji'],
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mood['label'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? mood['color'] as Color
                                : Colors.grey.shade600,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          if (prompts.isNotEmpty) ...[
            const Text(
              'Choose a prompt',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...prompts.map((prompt) {
              final isSelected = selectedPrompt == prompt;
              return GestureDetector(
                onTap: () {
                  setState(() => selectedPrompt = prompt);
                  _entryController.text = '';
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.purple.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? Colors.purple.shade400
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: Colors.purple.shade400,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          prompt,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.purple.shade700
                                : Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
          const Text(
            'Write your thoughts',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (selectedPrompt.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                selectedPrompt,
                style: TextStyle(
                  color: Colors.purple.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          TextField(
            controller: _entryController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Start writing here...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.purple.shade400, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSaving ? null : saveEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Save Entry',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    if (journalEntries.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No journal entries yet',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: journalEntries.length,
      itemBuilder: (context, index) {
        final entry = journalEntries[index];
        final mood = moods.firstWhere(
          (m) => m['value'] == entry['mood'],
          orElse: () => moods[2],
        );
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(mood['emoji'], style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    mood['label'],
                    style: TextStyle(
                      color: mood['color'] as Color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    entry['createdAt'].toString().substring(0, 10),
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
              if (entry['prompt'] != null &&
                  entry['prompt'].toString().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  entry['prompt'],
                  style: TextStyle(
                    color: Colors.purple.shade400,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                entry['entry'],
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }
}
