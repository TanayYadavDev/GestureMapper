import 'package:camera/camera.dart';
import 'package:hand_landmarker/hand_landmarker.dart';

class HandTracker {
  HandLandmarkerPlugin? _plugin;

  HandLandmarkerPlugin? get plugin => _plugin;

  void initialize() {
    _plugin = HandLandmarkerPlugin.create(
      numHands: 2,
      minHandDetectionConfidence: 0.7,
      delegate: HandLandmarkerDelegate.gpu,
    );
  }

  void processFrame(
      CameraImage image,
      int sensorOrientation,
      ) {
    if (_plugin == null) return;

    _plugin!.processFrame(
      image,
      sensorOrientation,
    );
  }

  Stream<List<Hand>> get landmarkStream {
    if (_plugin == null) {
      throw StateError('HandTracker is not initialized');
    }

    return _plugin!.landmarkStream;
  }

  void dispose() {
    _plugin?.dispose();
    _plugin = null;
  }
}