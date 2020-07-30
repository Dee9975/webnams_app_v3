import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:webnams_app_v3/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  var firstCamera;
  try {
     firstCamera = cameras.first;
  } catch (e) {
    print(e);
  }

  runApp(App(camera: firstCamera));
}