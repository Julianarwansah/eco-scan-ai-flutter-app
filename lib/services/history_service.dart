import 'package:hive_flutter/hive_flutter.dart';

class HistoryService {
  static const String boxName = 'waste_history';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  Box get _box => Hive.box(boxName);

  List<Map<dynamic, dynamic>> getHistory() {
    return _box.values.toList().cast<Map<dynamic, dynamic>>().reversed.toList();
  }

  Future<void> saveScan({
    required String label,
    required double confidence,
    required String imagePath,
    required int points,
  }) async {
    final scan = {
      'label': label,
      'confidence': confidence,
      'imagePath': imagePath,
      'points': points,
      'date': DateTime.now().toIso8601String(),
    };
    await _box.add(scan);
  }
}
