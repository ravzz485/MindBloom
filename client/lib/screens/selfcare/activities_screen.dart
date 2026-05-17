import 'package:flutter/material.dart';
import '../../services/selfcare_service.dart';
import 'breathing_screen.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  List<dynamic> activities = [];
  bool isLoading = true;
  String selectedType = 'all';
  String selectedRisk = 'all';

  final List<Map<String, dynamic>> types = [
    {'label': 'All', 'value': 'all', 'icon': Icons.apps},
    {'label': 'Breathing', 'value': 'breathing', 'icon': Icons.air},
    {
      'label': 'Meditation',
      'value': 'meditation',
      'icon': Icons.self_improvement,
    },
    {'label': 'Journaling', 'value': 'journaling', 'icon': Icons.book},
    {'label': 'Sleep', 'value': 'sleep_tips', 'icon': Icons.bedtime},
    {'label': 'Audio', 'value': 'audio', 'icon': Icons.headphones},
  ];

  final List<Map<String, dynamic>> risks = [
    {'label': 'All', 'value': 'all', 'color': Colors.grey},
    {'label': 'Low', 'value': 'low', 'color': Colors.green},
    {'label': 'Moderate', 'value': 'moderate', 'color': Colors.orange},
    {'label': 'High', 'value': 'high', 'color': Colors.red},
  ];

  @override
  void initState() {
    super.initState();
    loadActivities();
  }

  Future<void> loadActivities() async {
    setState(() => isLoading = true);
    try {
      final data = await SelfcareService.getActivities(
        type: selectedType == 'all' ? null : selectedType,
        riskLevel: selectedRisk == 'all' ? null : selectedRisk,
      );
      setState(() {
        activities = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  IconData getIcon(String type) {
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

  Color getRiskColor(String risk) {
    switch (risk) {
      case 'low':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F7),
      appBar: AppBar(
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
        title: const Text('Self-Care Activities'),
      ),
      body: Column(
        children: [
          // Type filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: types.length,
                itemBuilder: (context, index) {
                  final type = types[index];
                  final isSelected = selectedType == type['value'];
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedType = type['value']);
                      loadActivities();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.teal.shade400
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            type['icon'] as IconData,
                            size: 16,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            type['label'],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontSize: 13,
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
          ),

          // Risk filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: Row(
              children: risks.map((risk) {
                final isSelected = selectedRisk == risk['value'];
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedRisk = risk['value']);
                    loadActivities();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (risk['color'] as Color).withOpacity(0.15)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? risk['color'] as Color
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      risk['label'],
                      style: TextStyle(
                        color: isSelected
                            ? risk['color'] as Color
                            : Colors.grey.shade600,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Activities list
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4CAF82)),
                  )
                : activities.isEmpty
                ? const Center(child: Text('No activities found'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
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
                                    color: getRiskColor(
                                      activity['riskLevel'],
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    getIcon(activity['type']),
                                    color: getRiskColor(activity['riskLevel']),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activity['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: getRiskColor(
                                                activity['riskLevel'],
                                              ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              activity['riskLevel'],
                                              style: TextStyle(
                                                color: getRiskColor(
                                                  activity['riskLevel'],
                                                ),
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${activity['duration']} min',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              activity['content'],
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                            if (activity['type'] == 'breathing') ...[
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BreathingScreen(
                                      riskLevel: activity['riskLevel'],
                                    ),
                                  ),
                                ),
                                icon: const Icon(Icons.air, size: 16),
                                label: const Text('Start Exercise'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.shade400,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
