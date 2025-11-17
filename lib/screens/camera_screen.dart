import 'package:camera/camera.dart';
import 'package:camera_frames/core/globals.dart';
import 'package:camera_frames/core/image_server.dart';
import 'package:camera_frames/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  ImageServer? _server;

  void _initializeStream() async {
    _server = await ImageServer.getInstance(8080);
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller.initialize();

    if (!mounted) {
      return;
    }

    _controller.startImageStream((CameraImage image) {
      try {
        imglib.Image? frame = imageFromCameraImage(image);
        if (frame != null) {
          _server?.sendImage(frame);
        }
      } catch (e) {
        print(">>>>>>> ERROR: ${e.toString()} ");
      }
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Scaffold(
        appBar: appBar(),
        body: Container(
          alignment: Alignment.center,
          child: Text("Camera Error"),
        ),
      );
    }
    return Scaffold(appBar: appBar(), body: CameraPreview(_controller));
  }

  AppBar appBar() => AppBar(title: Text("Camera Frame"), centerTitle: true);
}
