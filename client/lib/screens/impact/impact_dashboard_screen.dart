import 'package:flutter/material.dart';
import '../../services/impact_service.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/insight_card.dart';
import '../../widgets/trend_chart.dart';

class ImpactDashboardScreen extends StatefulWidget {
  const ImpactDashboardScreen({super.key});

  @override
  State<ImpactDashboardScreen> createState() => _ImpactDashboardScreenState();
}

class _ImpactDashboardScreenState extends State<ImpactDashboardScreen> {
  bool isLoading = true;

  Map<String, dynamic> dashboard = {};
  Map<String, dynamic> insights = {};
  Map<String, dynamic> monthlyReport = {};
  Map<String, dynamic> chartsData = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final dashboardRes = await ImpactService.getDashboard();
      final insightsRes = await ImpactService.getInsights();
      final reportRes = await ImpactService.getMonthlyReport();
      final chartsRes = await ImpactService.getCharts();

      setState(() {
        dashboard = dashboardRes['data'] ?? {};
        insights = insightsRes['data'] ?? {};
        monthlyReport = reportRes['data'] ?? {};
        chartsData = chartsRes['data'] ?? {};
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Impact Analysis Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              children: [
                SummaryCard(
                  title: 'Average Mood',
                  value: dashboard['avgMood']?.toString() ?? '0',
                ),
                SummaryCard(
                  title: 'Average Stress',
                  value: dashboard['avgStress']?.toString() ?? '0',
                ),
                SummaryCard(
                  title: 'Average Sleep',
                  value: dashboard['avgSleep']?.toString() ?? '0',
                ),
                SummaryCard(
                  title: 'Total Records',
                  value: dashboard['totalRecords']?.toString() ?? '0',
                ),
              ],
            ),
            const SizedBox(height: 20),

            InsightCard(
              insight:
                  insights['insight']?.toString() ?? 'No insight available',
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monthly Report Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      monthlyReport['summary']?.toString() ??
                          'No summary available',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            TrendChart(title: 'Mood Trend', values: chartsData['mood'] ?? []),

            TrendChart(
              title: 'Stress Trend',
              values: chartsData['stress'] ?? [],
            ),

            TrendChart(title: 'Sleep Trend', values: chartsData['sleep'] ?? []),
          ],
        ),
      ),
    );
  }
}
