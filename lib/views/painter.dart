import 'package:drawing_app_test/models/drawing_points.dart';
import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;

  DrawingPainter({required this.drawingPoints});

  @override
  void paint(Canvas canvas, Size size) {
    for (var drawingPoint in drawingPoints) {
      final paint = Paint()
        ..color = drawingPoint.color
        ..isAntiAlias = true
        ..strokeWidth = drawingPoint.width
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      for (var i = 0; i < drawingPoint.offsets.length; i++) {
        bool notLastOffset = i != drawingPoint.offsets.length - 1;

        // define first and last points for convenience
        Offset firstPoint = drawingPoint.offsets.first;
        Offset lastPoint = drawingPoint.offsets.last;

        // create rect to use rectangle and circle
        Rect rect = Rect.fromPoints(firstPoint, lastPoint);

        if (notLastOffset && drawingPoint.mode == DrawingMode.scibble) {
          final current = drawingPoint.offsets[i];
          final next = drawingPoint.offsets[i + 1];
          canvas.drawLine(current, next, paint);
        } else if (drawingPoint.mode == DrawingMode.line) {
          canvas.drawLine(firstPoint, lastPoint, paint);
        } else if (drawingPoint.mode == DrawingMode.circle) {
          canvas.drawOval(rect, paint);
        } else if (drawingPoint.mode == DrawingMode.sqaure) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(0)),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
