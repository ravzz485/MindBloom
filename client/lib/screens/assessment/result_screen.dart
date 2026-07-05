// ignore_for_file: duplicate_ignore, deprecated_member_use

import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class ResultScreen extends StatelessWidget {
  final String type;
  final int score;
  final int maxScore;
  final String riskLevel;
  final String message;
  final String color;
  final String disclaimer;

  const ResultScreen({
    super.key,
    required this.type,
    required this.score,
    required this.maxScore,
    required this.riskLevel,
    required this.message,
    required this.color,
    required this.disclaimer,
  });

  Color get riskColor {
    switch (color) {
      case 'green': return const Color(0xFF43A047);
      case 'yellow': return const Color(0xFFFF9800);
      case 'orange': return const Color(0xFFFF5722);
      case 'red': return const Color(0xFFE53935);
      default: return const Color(0xFF174143);
    }
  }

  String get riskEmoji {
    switch (riskLevel) {
      case 'minimal': return '🟢';
      case 'mild': return '🟡';
      case 'moderate': return '🟠';
      case 'severe': return '🔴';
      default: return '⚪';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F4),
      appBar: AppBar(
        title: Text(
          '$type Results',
          style: const TextStyle(
            fontWeight: FontWeight.bold
          )
        ),
        backgroundColor: const Color(0xFF174143),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Result card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                    BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                        // ignore: deprecated_member_use
                        .withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10)
                    )
                  ]
                ),
                child: Column(
                  children: [
                    // Risk emoji
                    Text(
                      riskEmoji,
                      style:
                        const TextStyle(fontSize: 80)
                    ),

                    const SizedBox(height: 16),

                    // Risk level
                    Text(
                      riskLevel.toUpperCase(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: riskColor
                      )
                    ),

                    const SizedBox(height: 8),

                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        height: 1.4
                      )
                    ),

                    const SizedBox(height: 24),

                    // Score display
                    Container(
                      padding:
                        const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: riskColor
                          .withOpacity(0.1),
                        borderRadius:
                          BorderRadius.circular(16)
                      ),
                      child: Row(
                        mainAxisAlignment:
                          MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                '$score',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight:
                                    FontWeight.bold,
                                  color: riskColor
                                )
                              ),
                              Text(
                                'out of $maxScore',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14
                                )
                              )
                            ]
                          ),
                          const SizedBox(width: 32),
                          Column(
                            crossAxisAlignment:
                              CrossAxisAlignment.start,
                            children: [
                              _buildScoreRange(
                                '0-4', 'Minimal',
                                const Color(0xFF43A047)
                              ),
                              _buildScoreRange(
                                '5-9', 'Mild',
                                const Color(0xFFFF9800)
                              ),
                              _buildScoreRange(
                                '10-14', 'Moderate',
                                const Color(0xFFFF5722)
                              ),
                              _buildScoreRange(
                                '15+', 'Severe',
                                const Color(0xFFE53935)
                              ),
                            ]
                          )
                        ]
                      )
                    )
                  ]
                )
              ),

              const SizedBox(height: 20),

              // Disclaimer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius:
                    BorderRadius.circular(16),
                  border: Border.all(
                    color:
                      Colors.orange.withOpacity(0.3)
                  )
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 20
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        disclaimer,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          height: 1.4
                        )
                      )
                    )
                  ]
                )
              ),

              const SizedBox(height: 24),

              // Buttons
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                          const HomeScreen()
                      ),
                      (route) => false
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                      const Color(0xFF174143),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                        BorderRadius.circular(16)
                    )
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    )
                  )
                )
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                      const Color(0xFF174143),
                    side: const BorderSide(
                      color: Color(0xFF174143)
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                        BorderRadius.circular(16)
                    )
                  ),
                  child: const Text(
                    'Take Another Assessment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    )
                  )
                )
              ),

              const SizedBox(height: 20)
            ]
          )
        )
      )
    );
  }

  Widget _buildScoreRange(
    String range,
    String level,
    Color color
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle
            )
          ),
          const SizedBox(width: 6),
          Text(
            '$range: $level',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold
            )
          )
        ]
      )
    );
  }
}