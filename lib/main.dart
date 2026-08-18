import 'package:flutter/material.dart';

import 'screens/camera_screen.dart';

void main() {
  runApp(const GestureMapperApp());
}

class GestureMapperApp extends StatelessWidget {
  const GestureMapperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GestureMapper',
      home: const CameraScreen(),
    );
  }
}