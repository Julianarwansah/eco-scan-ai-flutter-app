import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Ensure pubspec has fl_chart
import '../theme/app_colors.dart';
import '../services/history_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final HistoryService _historyService = HistoryService();
  int _totalPoints = 0;
  int _totalScans = 0;
  String _currentLevel = "New Recycler";
  Map<String, int> _categoryCounts = {};

  @override
  void initState() {
    super.initState();
    _calculateStats();
  }

  void _calculateStats() {
    final history = _historyService.getHistory();
    int points = 0;
    Map<String, int> counts = {};

    for (var item in history) {
      points += (item['points'] as int? ?? 0);
      String label = item['label'] as String? ?? 'Unknown';
      counts[label] = (counts[label] ?? 0) + 1;
    }

    setState(() {
      _totalPoints = points;
      _totalScans = history.length;
      _categoryCounts = counts;
      _currentLevel = _getLevel(points);
    });
  }

  String _getLevel(int points) {
    if (points > 1000) return "Planet Guardian";
    if (points > 500) return "Eco Warrior";
    if (points > 200) return "Eco Helper";
    return "New Recycler";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Saya")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              "Pahlawan Lingkungan",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              _currentLevel,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),

            // Stats Grid
            Row(
              children: [
                _buildStatItem("Total Poin", "$_totalPoints", Icons.star),
                const SizedBox(width: 16),
                _buildStatItem("Total Scan", "$_totalScans", Icons.camera_alt),
              ],
            ),
            const SizedBox(height: 32),

            // Chart Section (Simple implementation)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Statistik Sampah",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            _categoryCounts.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(32),
                    child: const Text("Belum ada data statistik"),
                  )
                : AspectRatio(
                    aspectRatio: 1.3,
                    child: PieChart(
                      PieChartData(
                        sections: _generateChartSections(),
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),

            // Legend
            if (_categoryCounts.isNotEmpty)
              Wrap(
                spacing: 16,
                children: _categoryCounts.entries.map((e) {
                  return Chip(
                    avatar: CircleAvatar(
                      backgroundColor: _getColorForLabel(e.key),
                      radius: 6,
                    ),
                    label: Text("${e.key}: ${e.value}"),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Expanded _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.secondary, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateChartSections() {
    return _categoryCounts.entries.map((entry) {
      final color = _getColorForLabel(entry.key);
      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        title: '${entry.value}',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getColorForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'plastik':
        return AppColors.plastic;
      case 'organik':
        return AppColors.organic;
      case 'kaca':
        return AppColors.glass;
      case 'logam':
        return AppColors.metal;
      case 'kertas':
        return AppColors.paper;
      default:
        return AppColors.other;
    }
  }
}
