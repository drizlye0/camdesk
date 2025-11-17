import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as imglib;

class ImageServer with ChangeNotifier {
  static ImageServer? _instance;

  Socket? _client;
  ServerSocket? _server;
  final int port;
  bool _serverIsInitialized = false;
  bool _clientConnected = false;
  String state = "Stopped";

  ImageServer._(this.port);

  static Future<ImageServer> getInstance(int port) async {
    if (_instance != null) return _instance!;

    _instance = ImageServer._(port);

    return _instance!;
  }

  Future<void> startServer() async {
    if (_serverIsInitialized) return;
    _server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    _setServerIsInitialized(true);
    _server!.listen((Socket client) {
      _setClientConnected(true);
      _client = client;
      print("client connectd");
      _client?.listen(
        (Uint8List data) {},

        onError: (error) {
          print(">>>>> ERROR: ${error.toString()}");
          _client?.close();
          _setClientConnected(false);
        },

        onDone: () {
          print(">>>>> client left");
          _client?.close();
          _setClientConnected(false);
        },
      );
    });
  }

  Future<void> stop() async {
    await _client?.close();
    await _server?.close();
    _server = null;
    _setClientConnected(false);
    _setServerIsInitialized(false);
  }

  void sendImage(imglib.Image image) {
    if (_client != null && _clientConnected) {
      _client?.add(imglib.encodePng(image));
    }
  }

  bool isInitialized() {
    return _serverIsInitialized;
  }

  bool hasClientConnected() {
    return _clientConnected;
  }

  void _setClientConnected(bool value) {
    _clientConnected = value;
    if (value) {
      state = "Connected";
    } else {
      state = "Waiting for connection";
    }
    notifyListeners();
  }

  void _setServerIsInitialized(bool value) {
    _serverIsInitialized = value;
    if (value) {
      state = "Waiting for connection";
    } else {
      state = "Stopped";
    }
    notifyListeners();
  }
}
