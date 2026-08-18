import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../camera/camera_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final CameraService _cameraService = CameraService();

  bool _isInitializing = true;
  String? _error;
  int _frameCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initialize();

      await _cameraService.startImageStream((CameraImage image) {
        _frameCount++;

        if (_frameCount % 30 == 0) {
          debugPrint(
            'Frames: $_frameCount | '
                'Resolution: ${image.width}x${image.height} | '
                'Planes: ${image.planes.length}',
          );
        }
      });

      if (!mounted) return;

      setState(() {
        _isInitializing = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isInitializing = false;
        _error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Camera error:\n$_error',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final controller = _cameraService.controller;

    if (controller == null || !controller.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: Text('Camera is not initialized'),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: CameraPreview(controller),
      ),
    );
  }
}