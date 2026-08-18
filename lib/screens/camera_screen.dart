import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hand_landmarker/hand_landmarker.dart';
import '../hand_tracking/hand_painter.dart';
import '../camera/camera_service.dart';
import '../hand_tracking/hand_tracker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final CameraService _cameraService = CameraService();
  final HandTracker _handTracker = HandTracker();

  List<Hand> _hands = [];

  bool _isInitializing = true;
  String? _error;
  int _detectedHands = 0;
  int _processedFrames = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initialize();

      _handTracker.initialize();

      _handTracker.landmarkStream.listen((hands) {
        if (!mounted) return;

        setState(() {
          _detectedHands = hands.length;
          _hands = hands;
        });

        if (_processedFrames % 30 == 0) {
          debugPrint(
            'Hands detected: ${hands.length}'
                '${hands.isNotEmpty ? ' | Landmarks: ${hands.first.landmarks.length}' : ''}',
          );
        }
      });

      await _cameraService.startImageStream((CameraImage image) {
        _processedFrames++;

        _handTracker.processFrame(
          image,
          _cameraService.controller!.description.sensorOrientation,
        );
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
    _handTracker.dispose();
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(controller),

          IgnorePointer(
            child: CustomPaint(
              painter: HandPainter(_hands),
            ),
          ),

          Positioned(
            top: 40,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              color: Colors.black54,
              child: Text(
                'Hands: $_detectedHands',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}