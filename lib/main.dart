import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/history_service.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HistoryService().init();

  // Request camera permission
  final cameraStatus = await Permission.camera.request();

  if (cameraStatus.isGranted) {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        debugPrint('No cameras found on this device');
      }
    } on CameraException catch (e) {
      debugPrint('Camera Error: ${e.code}\nMessage: ${e.description}');
      cameras = [];
    }
  } else {
    debugPrint('Camera permission denied');
    cameras = [];
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pemilah Sampah AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
