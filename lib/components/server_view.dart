import 'package:camera_frames/core/globals.dart';
import 'package:camera_frames/core/image_server.dart';
import 'package:flutter/material.dart';

class ServerView extends StatefulWidget {
  const ServerView({super.key});

  @override
  State<ServerView> createState() => _ServerViewState();
}

class _ServerViewState extends State<ServerView> {
  late final ImageServer _server;
  String _state = "Stopped";
  bool _serverON = false;
  String? _deviceIP;

  @override
  void initState() {
    super.initState();
    if (hostIP == null) return;
    _assignServer();
    setState(() {
      _deviceIP = hostIP;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _assignServer() async {
    final server = await ImageServer.getInstance(8080);
    setState(() {
      _server = server;
    });
  }

  void _startServer() async {
    await _server.startServer();
    _setServerState();
  }

  void _stopServer() async {
    await _server.stop();
    _setServerState();
  }

  void _setServerState() {
    print(">>>>>>>>>>>>>> set state");
    if (!_server.hasClientConnected() && _server.isInitialized()) {
      setState(() {
        _state = "Waiting for Connection";
        _serverON = true;
        print("1 $_serverON");
      });
      return;
    }

    if (!_server.isInitialized()) {
      setState(() {
        _state = "Stopped";
        _serverON = false;
        print("2 $_serverON");
      });
      return;
    }

    if (_server.hasClientConnected()) {
      setState(() {
        _state = "Connected";
        _serverON = true;
        print("3 $_serverON");
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          ListenableBuilder(
            listenable: _server,
            builder: (BuildContext context, Widget? child) {
              return Text("State: $_state");
            },
          ),
          Text("Device IP: ${_deviceIP ?? "not allowed"}"),
          Text("Port: 8080"),
          ElevatedButton(
            onPressed: _serverON ? _stopServer : _startServer,
            child: Text(_serverON ? "Stop Server" : "Start Server"),
          ),
        ],
      ),
    );
  }
}
