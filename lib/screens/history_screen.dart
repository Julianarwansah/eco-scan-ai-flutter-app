import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService();
  late List<Map<dynamic, dynamic>> _history;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _history = _historyService.getHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Pemilahan")),
      body: _history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 60, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada riwayat",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getColorForLabel(item['label']),
                      child: const Icon(Icons.recycling, color: Colors.white),
                    ),
                    title: Text(
                      item['label'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Akurasi: ${(item['confidence'] * 100).toStringAsFixed(1)}% • +${item['points']} Poin",
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to detail?
                      // For now just show image path in snackbar or re-open ResultScreen if we want.
                      // Re-opening result screen might re-trigger analysis which is bad.
                      // Ideally ResultScreen should take a "ScanResult" object not just image path.
                      // Leaving unimplemented for now as per MVP.
                    },
                  ),
                );
              },
            ),
    );
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
