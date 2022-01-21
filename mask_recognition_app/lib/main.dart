import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mask_recognition_app/screens/home.dart';

List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mask Recognition',
      theme: ThemeData(
        primaryColorDark: Color(0xFF7ECECD),
        primaryColor: Color(0xFF7ECECD),
        primaryColorLight: Colors.white,
        accentColor: Colors.white,
      ),
      home: Home(),
    );
  }
}
