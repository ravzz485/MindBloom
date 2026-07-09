import 'package:flutter/material.dart';
import 'screens/selfcare/recommendation_screen.dart';
import 'theme/mindbloom_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindBloom',
      debugShowCheckedModeBanner: false,
      theme: MBTheme.theme,
      home: const RecommendationScreen(
        userId: '507f1f77bcf86cd799439011',
        riskLevel: 'moderate',
      ),
    );
  }
}
