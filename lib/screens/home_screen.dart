import 'package:camera_frames/components/server_view.dart';
import 'package:camera_frames/screens/camera_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Text("Camera App"),
          ServerView(),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => CameraScreen()),
          //     );
          //   },
          //   child: Text("Go to Camera"),
          // ),
        ],
      ),
    );
  }
}
