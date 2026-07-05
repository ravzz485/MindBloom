import 'package:flutter/material.dart';

class MLResultScreen extends StatelessWidget {
  final String mlPrediction;
  final double mlConfidence;
  final String detectedIssue;
  final String riskLevel;
  final String disclaimer;

  const MLResultScreen({
    super.key,
    required this.mlPrediction,
    required this.mlConfidence,
    required this.detectedIssue,
    required this.riskLevel,
    required this.disclaimer,
  });

  Color getResultColor() {
    if (mlPrediction.toLowerCase() == 'depression') {
      if (mlConfidence >= 80) return Colors.red;
      if (mlConfidence >= 50) return Colors.orange;
      return Colors.yellow.shade700;
    }
    return Colors.green;
  }

  String getResultMessage() {
    if (mlPrediction.toLowerCase() == 'depression') {
      return 'Our AI detected patterns commonly associated with depression in your responses.';
    }
    return 'Your responses do not show strong indicators of depression at this time.';
  }

  @override
  Widget build(BuildContext context) {
    final color = getResultColor();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F4),
      appBar: AppBar(
        title: const Text(
          'AI Check-In Results',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
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
              const SizedBox(height: 20),

              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // ignore: deprecated_member_use
                  color: color.withOpacity(0.15)
                ),
                child: Center(
                  child: Text(
                    '${mlConfidence.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: color
                    )
                  )
                )
              ),

              const SizedBox(height: 24),

              Text(
                mlPrediction.toLowerCase() == 'depression'
                  ? 'Depression Indicators Detected'
                  : 'No Strong Indicators Detected',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF174143)
                )
              ),

              const SizedBox(height: 12),

              Text(
                getResultMessage(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  height: 1.5
                )
              ),

              const SizedBox(height: 32),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                    _buildInfoRow('AI Confidence', '${mlConfidence.toStringAsFixed(1)}%'),
                    const Divider(height: 24),
                    _buildInfoRow('Detected Issue', detectedIssue),
                    const Divider(height: 24),
                    _buildInfoRow('Risk Level', riskLevel),
                  ]
                )
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade200)
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        disclaimer,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange.shade900
                        )
                      )
                    )
                  ]
                )
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF174143),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)
                    )
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  )
                )
              )
            ]
          )
        )
      )
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF174143),
            fontSize: 14,
            fontWeight: FontWeight.bold
          )
        )
      ]
    );
  }
}