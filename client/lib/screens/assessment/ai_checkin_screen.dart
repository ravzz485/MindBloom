import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ml_result_screen.dart';

class AICheckInScreen extends StatefulWidget {
  const AICheckInScreen({super.key});

  @override
  State<AICheckInScreen> createState() => _AICheckInScreenState();
}

class _AICheckInScreenState extends State<AICheckInScreen> {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  final List<String> questions = [
    'How have you been feeling emotionally over the past 2 weeks?',
    'Have you found it hard to enjoy things you normally like?',
    'How has your sleep been lately?',
    'How would you describe your energy levels recently?',
    'Have you noticed any changes in your appetite?',
    'How do you feel about yourself these days?',
    'Have you had trouble focusing or concentrating?',
    'Do you ever feel restless or on edge? Tell me about it.',
    'Have you had any thoughts that scare or worry you?',
    'What has been causing you stress lately?',
    'How connected do you feel to people around you?',
    'Do you find yourself worrying a lot? About what?',
    'How do you feel physically when you are anxious or stressed?',
    'What does a typical day feel like for you right now?',
    'Is there anything else you would like to share about how you are doing?'
  ];

  late List<TextEditingController> controllers;
  int currentQuestion = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      questions.length,
      (index) => TextEditingController()
    );
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> submitCheckIn() async {
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      // Combine all answers into one paragraph
      final combinedText = controllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .join('. ');

      final response = await http.post(
        Uri.parse('$baseUrl/assessment/ml-analyze'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'text': combinedText})
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MLResultScreen(
                mlPrediction: data['mlPrediction'] ?? 'unknown',
                mlConfidence: (data['mlConfidence'] ?? 0).toDouble(),
                detectedIssue: data['detectedIssue'] ?? 'general',
                riskLevel: data['riskLevel'] ?? 'low',
                disclaimer: data['disclaimer'] ??
                  'This is not a medical diagnosis.'
              )
            )
          );
        }
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${data['message'] ?? 'Something went wrong'}'))
        );
      }

    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'))
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F4),
      appBar: AppBar(
        title: const Text(
          'AI Mental Health Check-In',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16
          )
        ),
        backgroundColor: const Color(0xFF174143),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${currentQuestion + 1} of ${questions.length}',
                        style: const TextStyle(
                          color: Color(0xFF174143),
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Text(
                        '${((currentQuestion + 1) / questions.length * 100).toInt()}%',
                        style: const TextStyle(
                          color: Color(0xFF174143),
                          fontWeight: FontWeight.bold
                        )
                      )
                    ]
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (currentQuestion + 1) / questions.length,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation(
                      Color(0xFF174143)
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4)
                  )
                ]
              ),

              const SizedBox(height: 32),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5)
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6
                        ),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: const Color(0xFF174143).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: const Text(
                          '🤖 AI Check-In',
                          style: TextStyle(
                            color: Color(0xFF174143),
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ),

                      const SizedBox(height: 20),

                      Text(
                        questions[currentQuestion],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF174143),
                          height: 1.4
                        )
                      ),

                      const SizedBox(height: 24),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F7F4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF174143)
                                // ignore: deprecated_member_use
                                .withOpacity(0.15)
                            )
                          ),
                          child: TextField(
                            controller: controllers[currentQuestion],
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: const TextStyle(
                              color: Color(0xFF174143),
                              fontSize: 15
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Type your answer here...',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16)
                            )
                          )
                        )
                      )
                    ]
                  )
                )
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  if (currentQuestion > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            currentQuestion--;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF174143),
                          side: const BorderSide(
                            color: Color(0xFF174143)
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16)
                        ),
                        child: const Text('Previous')
                      )
                    ),

                  if (currentQuestion > 0)
                    const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () {
                        if (currentQuestion < questions.length - 1) {
                          setState(() {
                            currentQuestion++;
                          });
                        } else {
                          submitCheckIn();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF174143),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16)
                      ),
                      child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            currentQuestion == questions.length - 1
                              ? 'Analyze My Answers'
                              : 'Next'
                          )
                    )
                  )
                ]
              )
            ]
          )
        )
      )
    );
  }
}