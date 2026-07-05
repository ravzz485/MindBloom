import 'package:flutter/material.dart';

class DailyCheckInScreen extends StatelessWidget {
  const DailyCheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-In'),
        backgroundColor: const Color(0xFF174143),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('CheckIn Screen')
      ),
    );
  }
}