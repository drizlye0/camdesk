import 'package:camera/camera.dart';
import 'package:camera_frames/core/globals.dart';
import 'package:camera_frames/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  await Permission.location.request();
  hostIP = await NetworkInfo().getWifiIP();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Camera Frame")),
        body: HomeScreen(),
      ),
    );
  }
}
