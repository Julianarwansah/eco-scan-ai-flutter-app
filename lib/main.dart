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
  debugPrint('✓ Hive initialized successfully');

  // Request camera permission
  debugPrint('Requesting camera permission...');
  final cameraStatus = await Permission.camera.request();

  if (cameraStatus.isGranted) {
    debugPrint('✓ Camera permission granted');
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        debugPrint('⚠ No cameras found on this device');
      } else {
        debugPrint('✓ Found ${cameras.length} camera(s):');
        for (var i = 0; i < cameras.length; i++) {
          debugPrint(
            '  Camera $i: ${cameras[i].name} - ${cameras[i].lensDirection}',
          );
        }
      }
    } on CameraException catch (e) {
      debugPrint('❌ Camera Error: ${e.code}');
      debugPrint('   Message: ${e.description}');
      cameras = [];
    } catch (e) {
      debugPrint('❌ Unexpected error initializing camera: $e');
      cameras = [];
    }
  } else if (cameraStatus.isDenied) {
    debugPrint('❌ Camera permission denied');
    cameras = [];
  } else if (cameraStatus.isPermanentlyDenied) {
    debugPrint('❌ Camera permission permanently denied');
    debugPrint('   User needs to enable it in app settings');
    cameras = [];
  } else {
    debugPrint('❌ Camera permission status: $cameraStatus');
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
