import 'package:flutter/material.dart';
import 'package:hand_landmarker/hand_landmarker.dart';

class HandPainter extends CustomPainter {
  final List<Hand> hands;

  HandPainter(this.hands);

  static const List<List<int>> connections = [
    // Thumb
    [0, 1],
    [1, 2],
    [2, 3],
    [3, 4],

    // Index finger
    [0, 5],
    [5, 6],
    [6, 7],
    [7, 8],

    // Middle finger
    [5, 9],
    [9, 10],
    [10, 11],
    [11, 12],

    // Ring finger
    [9, 13],
    [13, 14],
    [14, 15],
    [15, 16],

    // Pinky
    [13, 17],
    [17, 18],
    [18, 19],
    [19, 20],

    // Palm
    [0, 17],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final pointPaint = Paint()
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (final hand in hands) {
      final landmarks = hand.landmarks;

      if (landmarks.length != 21) {
        continue;
      }

      // Draw connections.
      for (final connection in connections) {
        final start = landmarks[connection[0]];
        final end = landmarks[connection[1]];

        final startPoint = _transform(start, size);
        final endPoint = _transform(end, size);

        canvas.drawLine(
          startPoint,
          endPoint,
          linePaint,
        );
      }

      // Draw landmark points.
      for (final landmark in landmarks) {
        final point = _transform(landmark, size);

        canvas.drawCircle(
          point,
          5,
          pointPaint,
        );
      }
    }
  }

  Offset _transform(
      Landmark landmark,
      Size size,
      ) {
    return Offset(
      (1 - landmark.y) * size.width,
      (1 - landmark.x) * size.height,
    );
  }

  @override
  bool shouldRepaint(covariant HandPainter oldDelegate) {
    return oldDelegate.hands != hands;
  }
}