import 'package:flutter/material.dart';
import 'result_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GAD7Screen extends StatefulWidget {
  const GAD7Screen({super.key});

  @override
  State<GAD7Screen> createState() =>
    _GAD7ScreenState();
}

class _GAD7ScreenState extends
  State<GAD7Screen> {

  static const String baseUrl =
  'http://10.0.2.2:5000/api';

  final List<String> questions = [
    'Feeling nervous, anxious, or on edge?',
    'Not being able to stop or control worrying?',
    'Worrying too much about different things?',
    'Trouble relaxing?',
    'Being so restless that it is hard to sit still?',
    'Becoming easily annoyed or irritable?',
    'Feeling afraid as if something awful might happen?'
  ];

  final List<String> options = [
    'Not at all',
    'Several days',
    'More than half the days',
    'Nearly every day'
  ];

  List<int> answers = List.filled(7, -1);
  bool isLoading = false;
  int currentQuestion = 0;

  Future<void> submitAssessment() async {
    setState(() => isLoading = true);

    try {
      final prefs =
        await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('$baseUrl/assessment/gad7'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'answers': answers})
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                type: 'GAD-7',
                score: data['score'],
                maxScore: data['maxScore'],
                riskLevel: data['riskLevel'],
                message: data['message'],
                color: data['color'],
                disclaimer: data['disclaimer']
              )
            )
          );
        }
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
          'GAD-7 Anxiety Screening',
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
                crossAxisAlignment:
                  CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
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
                    value: (currentQuestion + 1) /
                      questions.length,
                    backgroundColor:
                      Colors.grey.shade200,
                    valueColor:
                      const AlwaysStoppedAnimation(
                        Color(0xFF174143)
                      ),
                    minHeight: 8,
                    borderRadius:
                      BorderRadius.circular(4)
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
                    borderRadius:
                      BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                          // ignore: deprecated_member_use
                          .withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5)
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment:
                      CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6
                          ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF174143)
                            // ignore: deprecated_member_use
                            .withOpacity(0.1),
                          borderRadius:
                            BorderRadius.circular(20)
                        ),
                        child: const Text(
                          'Over the last 2 weeks...',
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

                      const SizedBox(height: 32),

                      ...List.generate(
                        options.length,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              answers[currentQuestion]
                                = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets
                              .only(bottom: 12),
                            padding:
                              const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: answers[
                                currentQuestion] ==
                                index
                                ? const Color(0xFF174143)
                                : const Color(
                                  0xFFF0F7F4),
                              borderRadius:
                                BorderRadius.circular(
                                  14),
                              border: Border.all(
                                color: answers[
                                  currentQuestion] ==
                                  index
                                  ? const Color(
                                    0xFF174143)
                                  : Colors.grey
                                    .shade200
                              )
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration:
                                    BoxDecoration(
                                      shape:
                                        BoxShape.circle,
                                      color:
                                        Colors.white,
                                      border: Border.all(
                                        color: answers[
                                          currentQuestion]
                                          == index
                                          ? Colors.white
                                          : Colors.grey
                                            .shade400
                                      )
                                    ),
                                  child: answers[
                                    currentQuestion]
                                    == index
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Color(
                                          0xFF174143)
                                      )
                                    : null
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '($index) ${options[index]}',
                                    style: TextStyle(
                                      color: answers[
                                        currentQuestion]
                                        == index
                                        ? Colors.white
                                        : const Color(
                                          0xFF174143),
                                      fontWeight:
                                        FontWeight.w500,
                                      fontSize: 15
                                    )
                                  )
                                )
                              ]
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
                          foregroundColor:
                            const Color(0xFF174143),
                          side: const BorderSide(
                            color: Color(0xFF174143)
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                              BorderRadius.circular(14)
                          ),
                          padding:
                            const EdgeInsets.symmetric(
                              vertical: 16)
                        ),
                        child: const Text('Previous')
                      )
                    ),

                  if (currentQuestion > 0)
                    const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: answers[
                        currentQuestion] == -1
                        ? null
                        : () {
                            if (currentQuestion <
                              questions.length - 1) {
                              setState(() {
                                currentQuestion++;
                              });
                            } else {
                              submitAssessment();
                            }
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                          const Color(0xFF174143),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                            BorderRadius.circular(14)
                        ),
                        padding:
                          const EdgeInsets.symmetric(
                            vertical: 16)
                      ),
                      child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white
                          )
                        : Text(
                            currentQuestion ==
                              questions.length - 1
                              ? 'Submit'
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