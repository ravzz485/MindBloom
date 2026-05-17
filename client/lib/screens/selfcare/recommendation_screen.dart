import 'package:flutter/material.dart';
import '../../services/selfcare_service.dart';
import 'activities_screen.dart';
import 'breathing_screen.dart';
import 'journal_screen.dart';
import 'emergency_screen.dart';

class RecommendationScreen extends StatefulWidget {
  final String userId;
  final String riskLevel;

  const RecommendationScreen({
    super.key,
    required this.userId,
    required this.riskLevel,
  });

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  List<dynamic> recommendations = [];
  List<dynamic> mlScores = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadRecommendations();
  }

  Future<void> loadRecommendations() async {
    try {
      final data = await SelfcareService.getRecommendations(
        widget.userId,
        widget.riskLevel,
      );
      setState(() {
        recommendations = data['recommendations'];
        mlScores = data['mlScores'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load recommendations';
        isLoading = false;
      });
    }
  }

  Color getRiskColor() {
    switch (widget.riskLevel) {
      case 'high':
        return Colors.red.shade400;
      case 'moderate':
        return Colors.orange.shade400;
      default:
        return Colors.green.shade400;
    }
  }

  IconData getActivityIcon(String type) {
    switch (type) {
      case 'breathing':
        return Icons.air;
      case 'meditation':
        return Icons.self_improvement;
      case 'journaling':
        return Icons.book;
      case 'sleep_tips':
        return Icons.bedtime;
      case 'audio':
        return Icons.headphones;
      default:
        return Icons.favorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF82),
        foregroundColor: Colors.white,
        title: const Text(
          'MindBloom',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.emergency),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EmergencyScreen()),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4CAF82)),
            )
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Risk level banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: getRiskColor().withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: getRiskColor()),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.monitor_heart, color: getRiskColor()),
                        const SizedBox(width: 8),
                        Text(
                          'Risk Level: ${widget.riskLevel.toUpperCase()}',
                          style: TextStyle(
                            color: getRiskColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick actions
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.air,
                          label: 'Breathing',
                          color: Colors.blue.shade400,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BreathingScreen(riskLevel: widget.riskLevel),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.book,
                          label: 'Journal',
                          color: Colors.purple.shade400,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  JournalScreen(userId: widget.userId),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.list,
                          label: 'Activities',
                          color: Colors.teal.shade400,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ActivitiesScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Recommendations
                  const Text(
                    'Recommended For You',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Personalized based on your wellness profile',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  ...recommendations.asMap().entries.map((entry) {
                    final index = entry.key;
                    final activity = entry.value;
                    final score = index < mlScores.length
                        ? mlScores[index]
                        : null;
                    return _ActivityCard(
                      activity: activity,
                      mlScore: score,
                      icon: getActivityIcon(activity['type']),
                      userId: widget.userId,
                      riskLevel: widget.riskLevel,
                    );
                  }),
                ],
              ),
            ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatefulWidget {
  final Map<String, dynamic> activity;
  final Map<String, dynamic>? mlScore;
  final IconData icon;
  final String userId;
  final String riskLevel;

  const _ActivityCard({
    required this.activity,
    required this.mlScore,
    required this.icon,
    required this.userId,
    required this.riskLevel,
  });

  @override
  State<_ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<_ActivityCard> {
  int selectedRating = 0;

  Future<void> submitRating(int rating) async {
    await SelfcareService.rateActivity(
      widget.userId,
      widget.activity['_id'],
      rating,
    );
    setState(() => selectedRating = rating);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rating saved! Recommendations will improve.'),
          backgroundColor: Color(0xFF4CAF82),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF82).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, color: const Color(0xFF4CAF82)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.activity['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${widget.activity['duration']} min • ${widget.activity['type']}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.mlScore != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.mlScore!['populationSuccessRate']}%',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.activity['content'],
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          const SizedBox(height: 12),
          // Rating
          Row(
            children: [
              Text(
                'Rate this: ',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              ...List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => submitRating(i + 1),
                  child: Icon(
                    i < selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 22,
                  ),
                );
              }),
            ],
          ),
          if (widget.activity['type'] == 'breathing')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        BreathingScreen(riskLevel: widget.riskLevel),
                  ),
                ),
                icon: const Icon(Icons.air, size: 16),
                label: const Text('Start Breathing Exercise'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF82),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
